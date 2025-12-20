// banned_merchants_screen.dart
import 'package:flutter/material.dart';
import 'banned_screen.dart';

class BannedMerchantsScreen extends StatelessWidget {
  final List<BannedUser> bannedMerchants = [
    BannedUser('تاجر الإلكترونيات', 'قطع غيار', 'القاهرة - مدينة نصر',
        'بضاعة مغشوشة', '2024-01-15'),
    BannedUser('متجر المحلة', 'إلكترونيات', 'الإسكندرية - سيدي بشر',
        'تأخير في التسليم', '2024-01-10'),
    BannedUser(
        'شركة التقنية', 'أجهزة', 'الجيزة - فيصل', 'شكاوى متكررة', '2024-01-05'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('التجار المحظورين'),
        backgroundColor: Colors.yellow[800],
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
                    child:
                        _buildStatItem('إجمالي المحظورين', '3', Colors.orange),
                  ),
                  Expanded(
                    child:
                        _buildStatItem('خسائر متوقعة', '15,000 ج', Colors.red),
                  ),
                  Expanded(
                    child:
                        _buildStatItem('تم التعويض', '8,000 ج', Colors.green),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // قائمة التجار المحظورين
          Text(
            'قائمة التجار المحظورين',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          ...bannedMerchants
              .map((merchant) => _buildBannedMerchantCard(merchant, context))
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildBannedMerchantCard(BannedUser merchant, BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.orange[100],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.store, color: Colors.orange),
        ),
        title: Text(
          merchant.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${merchant.type} - ${merchant.location}'),
            Text(
              merchant.reason,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              'تم الحظر: ${merchant.date}',
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.receipt, color: Colors.blue),
              onPressed: () {},
            ),
            PopupMenuButton(
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
          ],
        ),
      ),
    );
  }
}

// إضافة تعريف BannedUser هنا
class BannedUser {
  final String name;
  final String type;
  final String location;
  final String reason;
  final String date;

  BannedUser(this.name, this.type, this.location, this.reason, this.date);
}
