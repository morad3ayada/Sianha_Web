import 'package:flutter/material.dart';

class ClientProfile extends StatelessWidget {
  final Map<String, dynamic> client;

  ClientProfile({required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("بيانات العميل"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("الاسم: ${client["name"]}", style: TextStyle(fontSize: 20)),
            Text("رقم الهاتف: ${client["phone"]}",
                style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
