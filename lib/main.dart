import 'package:flutter/material.dart';
import 'scteens/login_screen.dart'; // شاشة الدخول

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // نخفي الشريط الأحمر
      title: 'خدمة - لوحة الإدارة',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      home: const LoginScreen(), // شاشة البداية
    );
  }
}
