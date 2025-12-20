import 'package:flutter/material.dart';
import 'new_complaints_screen.dart';
import 'processing_complaints_screen.dart';
import 'solved_complaints_screen.dart';

class ComplaintsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // شريط العنوان
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('شاشة الشكاوي',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800])),
                  Row(children: [
                    IconButton(
                        icon: Icon(Icons.refresh, color: Colors.blue),
                        onPressed: () {}),
                    IconButton(
                        icon: Icon(Icons.analytics, color: Colors.green),
                        onPressed: () {}),
                  ]),
                ],
              ),
            ),

            // البطاقات الإحصائية كأزرار
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(children: [
                Expanded(
                  child: _buildStatCardButton(
                    'شكاوي جديدة',
                    '23',
                    Icons.warning,
                    Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NewComplaintsScreen()), // ✅ اسم صحيح
                      );
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCardButton(
                    'قيد المعالجة',
                    '15',
                    Icons.schedule,
                    Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProcessingComplaintsScreen()), // ✅ اسم صحيح
                      );
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCardButton(
                    'تم الحل',
                    '89',
                    Icons.check_circle,
                    Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SolvedComplaintsScreen()), // ✅ اسم صحيح
                      );
                    },
                  ),
                ),
              ]),
            ),

            // باقي الكود...
          ],
        ),
      ),
    );
  }

  Widget _buildStatCardButton(
      String title, String value, IconData icon, Color color,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color)),
                  SizedBox(height: 4),
                  Text(title,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
