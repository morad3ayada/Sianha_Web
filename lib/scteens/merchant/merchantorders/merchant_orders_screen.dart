import 'package:flutter/material.dart';

// استيراد الشاشات الأخرى
import 'AccountReviewScreen.dart';
import 'MerchantApp.dart';
import 'RejectionApp.dart';

class MerchantOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA), // لون خلفية هادئ جداً
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. الهيدر والبحث
            _buildHeaderSection(),

            // 2. شريط الحالات (Filter Chips)
            _buildStatusFilters(),

            SizedBox(height: 10),

            // 3. الإجراءات السريعة (Grid Icons)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildActionCard(
                    context,
                    icon: Icons.person_add_rounded,
                    color: Colors.blueAccent,
                    label: "تاجر جديد",
                    onTap: () => _navigateToMerchantApp(context),
                  ),
                  SizedBox(width: 15),
                  _buildActionCard(
                    context,
                    icon: Icons.cancel_presentation_rounded,
                    color: Colors.redAccent,
                    label: "رفض طلب",
                    onTap: () => _navigateToRejectionScreen(context),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 4. عنوان القائمة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "أحدث الطلبات",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            SizedBox(height: 10),

            // 5. قائمة الطلبات
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: 8,
                itemBuilder: (context, index) =>
                    _buildModernOrderCard(index, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets Components ---

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "بحث عن رقم الطلب...",
                icon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilters() {
    final statuses = [
      {
        'label': 'الكل',
        'count': '15',
        'color': Colors.blue,
        'icon': Icons.dashboard
      },
      {
        'label': 'انتظار',
        'count': '8',
        'color': Colors.orange,
        'icon': Icons.timer
      },
      {
        'label': 'مكتمل',
        'count': '5',
        'color': Colors.green,
        'icon': Icons.check_circle
      },
      {
        'label': 'مرفوض',
        'count': '2',
        'color': Colors.red,
        'icon': Icons.cancel
      },
    ];

    return Container(
      height: 80,
      child: Expanded(
        // استخدام Expanded لحل مشكلة الـ Overflow
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: statuses.map((item) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(item['icon'] as IconData, color: item['color'] as Color),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['label'] as String,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${item['count']} طلب',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context,
      {required IconData icon,
      required Color color,
      required String label,
      required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernOrderCard(int index, BuildContext context) {
    // بيانات تجريبية
    List<Map<String, dynamic>> orders = [
      {
        'id': '#2023-001',
        'store': 'محل التقنية',
        'amount': '1,250',
        'color': Colors.orange,
        'icon': Icons.computer
      },
      {
        'id': '#2023-002',
        'store': 'متجر الأزياء',
        'amount': '2,800',
        'color': Colors.purple,
        'icon': Icons.shopping_bag
      },
      {
        'id': '#2023-003',
        'store': 'سوبر ماركت',
        'amount': '3,150',
        'color': Colors.green,
        'icon': Icons.local_grocery_store
      },
      {
        'id': '#2023-004',
        'store': 'مكتبة المعرفة',
        'amount': '450',
        'color': Colors.red,
        'icon': Icons.menu_book
      },
    ];

    var order = orders[index % orders.length];

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: Offset(0, 4)),
        ],
      ),
      child: ListTile(
        onTap: () => _navigateToAccountReview(context),
        contentPadding: EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: (order['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(order['icon'], color: order['color']),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(order['store'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text("${order['amount']} ج.م",
                style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w900,
                    fontSize: 14)),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Icon(Icons.tag, size: 14, color: Colors.grey),
              Text(order['id'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              Spacer(),
              Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text("منذ ساعتين",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: Colors.grey[300]),
      ),
    );
  }

  // دوال التنقل
  void _navigateToRejectionScreen(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RejectionApp()));
  }

  void _navigateToMerchantApp(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MerchantApp()));
  }

  void _navigateToAccountReview(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AccountReviewScreen()));
  }
}
