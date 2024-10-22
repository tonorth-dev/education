import 'package:flutter/material.dart';
import '../widgets/table_item_card.dart';
import '../widgets/custom_button.dart';

class StudentTable extends StatefulWidget {
  @override
  _StudentTableState createState() => _StudentTableState();
}
/**
 * 学员列表页
 */
class _StudentTableState extends State<StudentTable> {
  List<Map<String, String>> students = [
    {"name": "学员 A", "age": "20"},
    {"name": "学员 B", "age": "22"},
  ];

  void _addStudent() {
    setState(() {
      students.add({"name": "新学员", "age": "未知"});
    });
  }

  void _deleteStudent(int index) {
    setState(() {
      students.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return TableItemCard(
                    icon: Icons.person,
                    title: students[index]["name"] ?? '',
                    subtitle: "年龄: ${students[index]["age"]}",
                    onDelete: () => _deleteStudent(index),
                  );
                },
              ),
            ),
            CustomButton(
              text: '新增学员',
              icon: Icons.add,
              onPressed: _addStudent,
            ),
          ],
        ),
      ),
    );
  }
}
