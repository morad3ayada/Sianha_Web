import 'package:flutter/material.dart';
import '../../../technicians/technician_profile.dart';
import 'rejected_order.dart';

class RejectionAnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('إحصائيات الرفض',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.red[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatCard(
                'إجمالي الطلبات المرفوضة', '47', Icons.warning, Colors.red),
            SizedBox(height: 15),
            _buildStatCard('أعلى محافظة في الرفض', 'سوهاج (12)',
                Icons.location_on, Colors.orange),
            SizedBox(height: 15),
            _buildStatCard('أكثر خدمة مرفوضة', 'كهرباء (15)',
                Icons.electrical_services, Colors.blue),
            SizedBox(height: 15),
            _buildStatCard(
                'متوسط وقت الرفض', '3 أيام', Icons.access_time, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  Text(value,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  