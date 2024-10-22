// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'management_screen.dart'; // 导入 ManagementScreen
import 'package:shared_preferences/shared_preferences.dart'; // 导入 SharedPreferences

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  String _selectedIdentity = '超级管理';
  bool _isLoginFailed = false;
  String _errorMessage = '';

  final List<String> _identityOptions = [
    '超级管理',
    '题库管理',
    '讲义管理',
    '教务管理',
  ];

  @override
  void initState() {
    super.initState();
    _loadIdentity();
  }

  Future<void> _loadIdentity() async {
    final prefs = await SharedPreferences.getInstance();
    final identity = prefs.getString('identity');
    if (identity != null && _identityOptions.contains(identity)) {
      setState(() {
        _selectedIdentity = identity;
      });
    }
  }

  Future<void> _saveIdentity(String identity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('identity', identity);
  }

  Future<void> _login() async {
    setState(() {
      _isLoginFailed = false; // 先假设登录成功
      _errorMessage = ''; // 清空错误信息
    });

    final url = Uri.parse('http://192.168.1.100:8080/login'); // 使用开发机器的实际 IP 地址
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'identity': _selectedIdentity,
      'password': _passwordController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // 登录成功
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          _saveIdentity(_selectedIdentity); // 保存身份
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ManagementScreen()),
          );
        } else {
          // 服务器返回失败
          setState(() {
            _isLoginFailed = true;
            _errorMessage = '登录失败，请检查身份和密码';
          });
        }
      } else {
        // 网络请求失败
        setState(() {
          _isLoginFailed = true;
          _errorMessage = '网络请求失败，状态码: ${response.statusCode}';
        });
      }
    } catch (e) {
      // 处理网络连接失败
      setState(() {
        _isLoginFailed = true;
        _errorMessage = '网络连接失败，请检查网络设置: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('登录')),
      body: Stack(
        children: [
          // 添加背景图
          // Image.asset(
          //   'assets/images/background.jpg', // 替换为你的背景图路径
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // 水平居中
                    children: [
                      Container(
                        width: 100, // 左侧文字的宽度
                        alignment: Alignment.centerRight,
                        child: Text(
                          '身份： ',
                          style: TextStyle(fontSize: 18), // 增大字体大小
                        ),
                      ),
                      Container(
                        width: 260, // 调整宽度
                        child: DropdownButtonFormField<String>(
                          value: _selectedIdentity,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedIdentity = newValue!;
                            });
                          },
                          items: _identityOptions.map((String identity) {
                            return DropdownMenuItem<String>(
                              value: identity,
                              child: Text(identity),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(), // 设置方形输入框
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // 水平居中
                    children: [
                      Container(
                        width: 100, // 左侧文字的宽度
                        alignment: Alignment.centerRight,
                        child: Text(
                          '密码： ',
                          style: TextStyle(fontSize: 18), // 增大字体大小
                        ),
                      ),
                      Container(
                        width: 260, // 调整宽度
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(), // 设置方形输入框
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('登录'),
                  ),
                  if (_isLoginFailed)
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}