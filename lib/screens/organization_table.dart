import 'package:flutter/material.dart';
import '../widgets/table_item_card.dart';
import '../widgets/custom_button.dart';

class OrganizationTable extends StatefulWidget {
  @override
  _OrganizationTableState createState() => _OrganizationTableState();
}

class _OrganizationTableState extends State<OrganizationTable> {
  List<Map<String, String>> organizations = [
    {"name": "机构 A", "location": "上海"},
    {"name": "机构 B", "location": "北京"},
  ];

  void _addOrganization() {
    setState(() {
      organizations.add({"name": "新机构", "location": "未知"});
    });
  }

  void _deleteOrganization(int index) {
    setState(() {
      organizations.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: organizations.length,
                itemBuilder: (context, index) {
                  return TableItemCard(
                    icon: Icons.business,
                    title: organizations[index]["name"] ?? '',
                    subtitle: organizations[index]["location"] ?? '',
                    onDelete: () => _deleteOrganization(index),
                  );
                },
              ),
            ),
            CustomButton(
              text: '新增机构',
              icon: Icons.add,
              onPressed: _addOrganization,
            ),
          ],
        ),
      ),
    );
  }
}
