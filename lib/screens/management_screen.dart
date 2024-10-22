import 'package:flutter/material.dart';
import 'organization_table.dart';
import 'student_table.dart';

class ManagementScreen extends StatefulWidget {
  @override
  _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  int _selectedIndex = 0;

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Management'),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onMenuItemSelected,
            labelType: NavigationRailLabelType.selected,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.account_balance),
                selectedIcon: Icon(Icons.account_balance),
                label: Text('机构'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                selectedIcon: Icon(Icons.people),
                label: Text('学员'),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: _selectedIndex == 0
                  ? OrganizationTable()
                  : StudentTable(),
            ),
          ),
        ],
      ),
    );
  }
}
