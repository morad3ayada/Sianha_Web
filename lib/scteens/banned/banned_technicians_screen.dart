// banned_technicians_screen.dart
import 'package:flutter/material.dart';
import 'banned_screen.dart';

class BannedTechniciansScreen extends StatelessWidget {
  final List<BannedUser> bannedTechnicians = [
    BannedUser('أحمد محمد', 'فني موبايل', 'الجيزة - فيصل', 'مخالفات متكررة',
        '2024-01-15'),
    BannedUser(
        'محمود علي', 'ونش', 'القاهرة - مدينة نصر', 'تأخير متعمد', '2024-01-14'),
    BannedUser('خالد إبراهيم', 'فني منازل', 'الإسكندرية - سيدي بشر',
        'شكاوى عملاء', '2024-01-13'),
    BannedUser('كريم سعيد', 'فني إلكترونيات', 'قنا - نجع حمادي',
        'سلوك غير لائق', '2024-01-12'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('الفنيين المحظورين'),
        backgroundColor: Colors.red[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => BannedScreen())),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // إحصائيات سريعة
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem('إجمالي المحظورين', '8', Colors.red),
                  ),
                  Expanded(
                    child: _buildStatItem('هذا الشهر', '3', Colors.orange),
                  ),
                  Expanded(
                    child: _buildStatItem('تم الإلغاء', '2', Colors.green),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // قائمة الفنيين المحظورين
          Text(
            'قائمة الفنيين المحظورين',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          ...bannedTechnicians
              .map((technician) => _buildBannedUserCard(technician, context))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildBannedUserCard(BannedUser user, BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red[100],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.engineering, color: Colors.red),
        ),
        title: Text(
          user.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${user.type} - ${user.location}'),
            Text(
              user.reason,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              'تم الحظر: ${user.date}',
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.visibility, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('عرض التفاصيل'),
                ],
              ),
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.lock_open, color: Colors.green),
                  SizedBox(width: 8),
                  Text('إلغاء الحظر'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BannedUser {
  final String name;
  final String type;
  final String location;
  final String reason;
  final String date;

  BannedUser(this.name, this.type, this.location, this.reason, this.date);
}
