import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  final String governorate;
  final String center;

  AnalyticsScreen({required this.governorate, required this.center});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('الإحصائيات - $center',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.purple[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // إحصائيات سريعة
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'نظرة عامة',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAnalyticsItem('65%', 'معدل الإنجاز',
                            Icons.trending_up, Colors.green),
                        _buildAnalyticsItem('8%', 'معدل الرفض',
                            Icons.trending_down, Colors.red),
                        _buildAnalyticsItem(
                            '2.5', 'متوسط الوقت', Icons.timer, Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // تقرير شهري
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تقرير الشهر الحالي',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    _buildReportItem('طلبات جديدة', '28 طلب'),
                    _buildReportItem('طلبات مكتملة', '22 طلب'),
                    _buildReportItem('طلبات مرفوضة', '2 طلب'),
                    _buildReportItem('إجمالي الإيرادات', '4,250 جنيه'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsItem(
      String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        SizedBox(height: 8),
        Text(value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildReportItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14)),
          Text(value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
