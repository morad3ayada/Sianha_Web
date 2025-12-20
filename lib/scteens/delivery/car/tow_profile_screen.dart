import 'package:flutter/material.dart';
import 'tow_tracking_screen.dart';

class TowProfileScreen extends StatelessWidget {
  final Map<String, dynamic>? towData; // تغيير الاسم من tow إلى towData

  TowProfileScreen({this.towData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ملف الونش'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editProfile,
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // صورة الونش
            _buildTowHeader(),
            SizedBox(height: 20),

            // المعلومات الأساسية
            _buildBasicInfo(),
            SizedBox(height: 20),

            // تفاصيل الونش
            _buildTowDetails(),
            SizedBox(height: 20),

            // معلومات السائق
            _buildDriverInfo(),
            SizedBox(height: 20),

            // الإحصائيات
            _buildStatistics(),
            SizedBox(height: 20),

            // الأزرار
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTowHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.orange[100],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange, width: 3),
              ),
              child: Icon(
                Icons.local_shipping,
                size: 70,
                color: Colors.orange[800],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _getStatusColor(towData?['status'] ?? 'متاح'),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getStatusIcon(towData?['status'] ?? 'متاح'),
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Text(
          towData?['name'] ?? 'ونش 101',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '${towData?['governorate'] ?? 'القاهرة'} - ${towData?['area'] ?? 'مدينة نصر'}',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color:
                _getStatusColor(towData?['status'] ?? 'متاح').withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: _getStatusColor(towData?['status'] ?? 'متاح')),
          ),
          child: Text(
            towData?['status'] ?? 'متاح',
            style: TextStyle(
              color: _getStatusColor(towData?['status'] ?? 'متاح'),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'المعلومات الأساسية',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow(Icons.location_on, 'المحافظة',
                towData?['governorate'] ?? 'القاهرة'),
            _buildInfoRow(
                Icons.place, 'المنطقة/المركز', towData?['area'] ?? 'مدينة نصر'),
            _buildInfoRow(Icons.confirmation_number, 'رقم اللوحة',
                towData?['plateNumber'] ?? 'أ ب ج 123'),
            _buildInfoRow(Icons.local_shipping, 'نوع الونش',
                towData?['type'] ?? 'ونش متوسط'),
            _buildInfoRow(Icons.event, 'سنة الصنع', towData?['year'] ?? '2022'),
            _buildInfoRow(
                Icons.phone, 'رقم التواصل', towData?['phone'] ?? '01234567890'),
          ],
        ),
      ),
    );
  }

  Widget _buildTowDetails() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.details, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'تفاصيل الونش',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _buildDetailItem(
                        'السعة', '3 طن', Icons.fitness_center)),
                Expanded(
                    child:
                        _buildDetailItem('الطول', '8 متر', Icons.straighten)),
                Expanded(
                    child: _buildDetailItem('الارتفاع', '3 متر', Icons.height)),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildDetailItem(
                        'المسافة', '50 كم', Icons.directions_car)),
                Expanded(
                    child: _buildDetailItem('السرعة', '80 كم/س', Icons.speed)),
                Expanded(
                    child: _buildDetailItem(
                        'الوقود', 'ديزل', Icons.local_gas_station)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.orange, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildDriverInfo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'معلومات السائق',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green[100],
                  child: Icon(Icons.person, size: 30, color: Colors.green),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        towData?['driverName'] ?? 'محمد أحمد',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          'رقم الرخصة: ${towData?['licenseNumber'] ?? '123456'}'),
                      Text(
                          'سنوات الخبرة: ${towData?['experience'] ?? '5 سنوات'}'),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(' ${towData?['rating'] ?? '4.5'}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'إحصائيات العمل',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCircle(
                    Icons.assignment_turned_in, 'الرحلات', '156', Colors.green),
                _buildStatCircle(
                    Icons.timer, 'المتوسط', '45 دقيقة', Colors.blue),
                _buildStatCircle(Icons.monetization_on, 'الإيراد', '25,000 ج',
                    Colors.orange),
                _buildStatCircle(
                    Icons.rate_review, 'التقييم', '4.7', Colors.amber),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCircle(
      IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 18),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TowTrackingScreen(
                        towData: towData,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.track_changes),
                label: Text('تتبع الونش'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange[800],
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _callTow,
                icon: Icon(Icons.phone),
                label: Text('اتصال'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _requestTow,
                icon: Icon(Icons.local_shipping),
                label: Text('طلب الونش'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.orange),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _viewHistory,
                icon: Icon(Icons.history),
                label: Text('سجل الرحلات'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child:
                Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'متاح':
        return Colors.green;
      case 'مشغول':
        return Colors.red;
      case 'في الطريق':
        return Colors.orange;
      case 'في الصيانة':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'متاح':
        return Icons.check;
      case 'مشغول':
        return Icons.close;
      case 'في الطريق':
        return Icons.directions_car;
      case 'في الصيانة':
        return Icons.build;
      default:
        return Icons.info;
    }
  }

  void _editProfile() {
    // تعديل ملف الونش
  }

  void _shareProfile() {
    // مشاركة ملف الونش
  }

  void _callTow() {
    // الاتصال بالونش
  }

  void _requestTow() {
    // طلب الونش
  }

  void _viewHistory() {
    // عرض سجل الرحلات
  }
}
