import 'package:flutter/material.dart';

class PermissionsManagementScreen extends StatefulWidget {
  @override
  _PermissionsManagementScreenState createState() =>
      _PermissionsManagementScreenState();
}

class _PermissionsManagementScreenState
    extends State<PermissionsManagementScreen> {
  List<Map<String, dynamic>> _employees = [
    {
      'id': '1',
      'name': 'أحمد محمد',
      'role': 'محاسب',
      'permissions': ['الفواتير', 'المرتبات'],
    },
    {
      'id': '2',
      'name': 'سارة علي',
      'role': 'خدمة عملاء',
      'permissions': ['الشكاوى', 'الطلبات'],
    },
    {
      'id': '3',
      'name': 'محمد حسن',
      'role': 'مندوب',
      'permissions': ['طلباته فقط'],
    },
    {
      'id': '4',
      'name': 'علي محمود',
      'role': 'مدير',
      'permissions': ['كل الصلاحيات'],
    },
  ];

  List<String> _availableRoles = [
    'مدير',
    'محاسب',
    'مندوب',
    'فني',
    'خدمة عملاء',
    'موظف عادي',
  ];

  Map<String, List<String>> _rolePermissions = {
    'مدير': ['كل الصلاحيات'],
    'محاسب': ['الفواتير', 'المرتبات', 'التقارير المالية'],
    'مندوب': ['طلباته فقط', 'تحديث حالة الطلبات'],
    'فني': ['طلبات الصيانة', 'تقرير الإنجاز'],
    'خدمة عملاء': ['الشكاوى', 'الطلبات', 'العملاء'],
    'موظف عادي': ['ملفه الشخصي', 'حضوره'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة الصلاحيات'),
      ),
      body: Column(
        children: [
          // معلومات
          Container(
            padding: EdgeInsets.all(15),
            color: Colors.blue[50],
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'يمكنك تعديل صلاحيات الموظفين حسب أدوارهم في النظام',
                    style: TextStyle(color: Colors.blue[800]),
                  ),
                ),
              ],
            ),
          ),

          // قائمة الموظفين والصلاحيات
          Expanded(
            child: ListView.builder(
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                final employee = _employees[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        employee['name'][0],
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    ),
                    title: Text(employee['name']),
                    subtitle: Text('الدور: ${employee['role']}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الصلاحيات الحالية:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: (employee['permissions'] as List)
                                  .map((permission) => Chip(
                                        label: Text(permission),
                                        backgroundColor: Colors.blue[100],
                                        labelStyle: TextStyle(color: Colors.blue[800]),
                                      ))
                                  .toList(),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'تغيير الدور:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: employee['role'],
                              items: _availableRoles.map((role) {
                                return DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              onChanged: (newRole) {
                                setState(() {
                                  employee['role'] = newRole!;
                                  employee['permissions'] =
                                      _rolePermissions[newRole] ?? [];
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _showCustomPermissions(employee),
                                icon: Icon(Icons.edit),
                                label: Text('تخصيص الصلاحيات'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange, // تم التغيير من primary إلى backgroundColor
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // زر حفظ التغييرات
          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: Text(
                  'حفظ جميع التغييرات',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2C3E50),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomPermissions(Map<String, dynamic> employee) {
    List<String> allPermissions = [
      'إدارة الموظفين',
      'إدارة العملاء',
      'الفواتير',
      'المرتبات',
      'الحضور',
      'التقارير',
      'الإعدادات',
      'الشكاوى',
      'الطلبات',
      'الصيانة',
      'الصلاحيات',
      'إدارة النظام',
    ];

    List<String> currentPermissions = List.from(employee['permissions']);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.security, color: Colors.blue),
                SizedBox(width: 10),
                Text('تخصيص صلاحيات ${employee['name']}'),
              ],
            ),
            content: Container(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اختر الصلاحيات المناسبة للموظف:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    ...allPermissions
                        .map((permission) => CheckboxListTile(
                              title: Text(
                                permission,
                                style: TextStyle(fontSize: 14),
                              ),
                              value: currentPermissions.contains(permission),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    currentPermissions.add(permission);
                                  } else {
                                    currentPermissions.remove(permission);
                                  }
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                            ))
                        .toList(),
                    SizedBox(height: 10),
                    if (currentPermissions.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Text(
                            'الصلاحيات المختارة:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: currentPermissions
                                .map((permission) => Chip(
                                      label: Text(
                                        permission,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      backgroundColor: Colors.green[100],
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'إلغاء',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _saveEmployeePermissions(employee, currentPermissions);
                  Navigator.pop(context);
                },
                child: Text('حفظ التغييرات'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _saveEmployeePermissions(
      Map<String, dynamic> employee, List<String> newPermissions) {
    setState(() {
      employee['permissions'] = newPermissions;
      employee['role'] = 'مخصص';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحديث صلاحيات ${employee['name']} بنجاح'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _saveChanges() {
    // هنا يمكنك حفظ التغييرات في قاعدة البيانات
    print('حفظ التغييرات للموظفين:');
    for (var employee in _employees) {
      print('${employee['name']}: ${employee['permissions']}');
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حفظ جميع التغييرات بنجاح'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'تم',
          onPressed: () {},
          textColor: Colors.white,
        ),
      ),
    );
  }
}