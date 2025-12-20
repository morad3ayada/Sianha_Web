// banned_customers_screen.dart
import 'package:flutter/material.dart';
import 'banned_screen.dart';

class BannedCustomersScreen extends StatelessWidget {
  final List<BannedUser> bannedCustomers = [
    BannedUser(
        'محمد أحمد', 'عميل', 'الجيزة - فيصل', 'إساءة استخدام', '2024-01-15'),
    BannedUser('سارة محمود', 'عميلة', 'القاهرة - مصر الجديدة', 'شكاوى كاذبة',
        '2024-01-14'),
    BannedUser(
        'خالد حسن', 'عميل', 'الإسكندرية - سموحة', 'عدم السداد', '2024-01-13'),
    BannedUser('فاطمة علي', 'عميلة', 'القاهرة - المعادي', 'سلوك غير لائق',
        '2024-01-12'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('العملاء المحظورين'),
        backgroundColor: Colors.purple[700],
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
            icon: Icon(Icons.add_alert),
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
                        _buildStatItem('إجمالي المحظورين', '12', Colors.purple),
                  ),
                  Expanded(
                    child: _buildStatItem('شكاوى هذا الشهر', '8', Colors.red),
                  ),
                  Expanded(
                    child: _buildStatItem('تم الحل', '5', Colors.green),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // قائمة العملاء المحظورين
          Text(
            'قائمة العملاء المحظورين',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          ...bannedCustomers
              .map((customer) => _buildBannedCustomerCard(customer, context))
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

  Widget _buildBannedCustomerCard(BannedUser customer, BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.purple[100],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person, color: Colors.purple),
        ),
        title: Text(
          customer.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${customer.type} - ${customer.location}'),
            Text(
              customer.reason,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              'تم الحظر: ${customer.date}',
              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.chat, color: Colors.blue),
          onPressed: () {},
        ),
      ),
    );
  }
}

// ⭐⭐⭐ إضافة تعريف BannedUser هنا ⭐⭐⭐
class BannedUser {
  final String name;
  final String type;
  final String location;
  final String reason;
  final String date;

  BannedUser(this.name, this.type, this.location, this.reason, this.date);
}
