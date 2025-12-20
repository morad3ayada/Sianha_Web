import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2C3E50);
  static const Color secondary = Color(0xFF3498DB);
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color danger = Color(0xFFE74C3C);
  static const Color info = Color(0xFF2980B9);

  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);

  // ألوان الحالات
  static Color getStatusColor(String status) {
    switch (status) {
      case 'شغال':
        return success;
      case 'أجازة':
        return warning;
      case 'موقوف':
        return danger;
      default:
        return textSecondary;
    }
  }
}
