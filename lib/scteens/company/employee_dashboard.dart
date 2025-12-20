
import 'package:flutter/material.dart';

class EmployeeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة الموظف'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.fingerprint, color: Colors.blue),
                title: Text('تسجيل الحضور'),
                subtitle: Text('سجل حضورك اليوم'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // شاشة الحضور
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.blue),
                title: Text('ملفي الشخصي'),
                subtitle: Text('عرض وتعديل بياناتك'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // شاشة الملف الشخصي
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.attach_money, color: Colors.blue),
                title: Text('راتبي'),
                subtitle: Text('عرض كشف الراتب'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // شاشة الراتب
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.beach_access, color: Colors.blue),
                title: Text('طلبات الإجازة'),
                subtitle: Text('طلب ومراجعة الإجازات'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // شاشة الإجازات
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.task, color: Colors.blue),
                title: Text('مهامي'),
                subtitle: Text('المهام الموكلة إليك'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // شاشة المهام
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}