import 'package:flutter/material.dart';
import 'delegate_tracking_screen.dart';

class DelegateProfileScreen extends StatelessWidget {
  final Map<String, dynamic>? delegate;

  DelegateProfileScreen({this.delegate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ملف المندوب'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // صورة الملف الشخصي
            _buildProfileHeader(),
            SizedBox(height: 20),

            // المعلومات الشخصية
            _buildPersonalInfo(),
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

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, size: 70, color: Colors.blue),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Text(
          delegate?['name'] ?? 'أحمد محمد',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          'مندوب - ${delegate?['governorate'] ?? 'القاهرة'}',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            delegate?['status'] ?? 'نشط',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'المعلومات الشخصية',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow(Icons.location_on, 'المحافظة',
                delegate?['governorate'] ?? 'القاهرة'),
            _buildInfoRow(Icons.location_city, 'المركز',
                delegate?['center'] ?? 'المعادي'),
            _buildInfoRow(
                Icons.place, 'المنطقة', delegate?['area'] ?? 'حي النور'),
            _buildInfoRow(Icons.cake, 'العمر', delegate?['age'] ?? '28 سنة'),
            _buildInfoRow(
                Icons.phone, 'الهاتف', delegate?['phone'] ?? '01234567890'),
            _buildInfoRow(Icons.email, 'البريد',
                delegate?['email'] ?? 'ahmed@example.com'),
            _buildInfoRow(Icons.calendar_today, 'تاريخ الانضمام',
                delegate?['joinDate'] ?? '01/01/2024'),
          ],
        ),
      ),
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
                Icon(Icons.analytics, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'الإحصائيات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCircle(
                    Icons.shopping_cart, 'طلبات', '156', Colors.green),
                _buildStatCircle(
                    Icons.check_circle, 'مكتمل', '142', Colors.blue),
                _buildStatCircle(Icons.star, 'تقييم', '4.5', Colors.amber),
                _buildStatCircle(
                    Icons.timer, 'متوسط وقت', '25 د', Colors.purple),
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
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12),
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
                      builder: (context) => DelegateTrackingScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.track_changes),
                label: Text('تتبع الطلبات'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue[800],
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _callDelegate,
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
                onPressed: _sendMessage,
                icon: Icon(Icons.message),
                label: Text('رسالة'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _viewHistory,
                icon: Icon(Icons.history),
                label: Text('سجل الطلبات'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.orange),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _editProfile() {
    // تعديل الملف الشخصي
  }

  void _callDelegate() {
    // الاتصال بالمندوب
  }

  void _sendMessage() {
    // إرسال رسالة
  }

  void _viewHistory() {
    // عرض سجل الطلبات
  }
}

// إذا أردت استخدام نموذج بيانات منفصل، أضف هذا في ملف جديد أو في نفس الملف:
class Delegate {
  final String id;
  final String name;
  final String governorate;
  final String center;
  final String area;
  final String age;
  final String phone;
  final String email;
  final String status;
  final String joinDate;
  final int totalOrders;
  final int completedOrders;
  final double rating;
  final String averageTime;

  Delegate({
    required this.id,
    required this.name,
    required this.governorate,
    required this.center,
    required this.area,
    required this.age,
    required this.phone,
    required this.email,
    required this.status,
    required this.joinDate,
    required this.totalOrders,
    required this.completedOrders,
    required this.rating,
    required this.averageTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'governorate': governorate,
      'center': center,
      'area': area,
      'age': age,
      'phone': phone,
      'email': email,
      'status': status,
      'joinDate': joinDate,
      'totalOrders': totalOrders,
      'completedOrders': completedOrders,
      'rating': rating,
      'averageTime': averageTime,
    };
  }
}
