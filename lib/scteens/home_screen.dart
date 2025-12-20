import 'package:flutter/material.dart';

// استيراد الشاشات الأخرى
import '/scteens/technicians/technicians_screen.dart';
import 'merchants/merchants_screen.dart';
import 'complaints/complaints_screen.dart';
import 'financial/financial_dashboard_screen.dart';
import 'technician/TechnicianTrackin/technician_tracking_screen.dart';
import 'merchant/merchant_tracking_screen.dart';
import 'merchant/merchantorders/merchant_orders_screen.dart';
import 'technician/technician_orders_screen.dart';
import 'banned/banned_screen.dart';
import 'delivery/delivery_screen.dart';

import 'finishing/finishing_team_screen.dart';
// استيراد شاشة العملاء (أنشئ هذا الملف لاحقاً)
import 'customers/customers_screen.dart';
import 'governorates/governorates_screen.dart';
import 'areas/areas_screen.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;

  // قائمة العناصر الرئيسية
  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'الفنيين',
      'icon': Icons.engineering,
      'builder': (context) => FilterScreen()
    },
    {
      'title': 'تاجر',
      'icon': Icons.store,
      'builder': (context) => MerchantFilterScreen()
    },
    {
      'title': 'العملاء', // أضيف قسم العملاء هنا
      'icon': Icons.people_outline,
      'builder': (context) => CustomersScreen()
    },
    {
      'title': 'الشكاوي',
      'icon': Icons.report_problem,
      'builder': (context) => ComplaintsScreen()
    },
    {
      'title': 'قسم مالي',
      'icon': Icons.attach_money,
      'builder': (context) => FinancialManagementApp()
    },
    {
      'title': 'متابعة الفنيين',
      'icon': Icons.track_changes,
      'builder': (context) => OrdersMainScreen(
            governorate: 'القاهرة',
            center: 'المعادي',
          )
    },
    {
      'title': 'متابعة تاجر',
      'icon': Icons.inventory,
      'builder': (context) => MerchantTrackingScreen()
    },
    {
      'title': 'طلبات عمل تاجر',
      'icon': Icons.shopping_cart,
      'builder': (context) => MerchantOrdersScreen()
    },
    {
      'title': 'طلبات عمل فنيين',
      'icon': Icons.work,
      'builder': (context) => TechnicianManagementScreen()
    },
    {
      'title': 'محظورين',
      'icon': Icons.block,
      'builder': (context) => BannedScreen()
    },
    {
      'title': 'المحافظات',
      'icon': Icons.location_city,
      'builder': (context) => GovernoratesScreen()
    },
    {
      'title': 'المناطق',
      'icon': Icons.map,
      'builder': (context) => AreasScreen()
    },
    {
      'title': 'فريق التشطيب',
      'icon': Icons.construction,
      'builder': (context) => FinishingTeamScreen()
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      // AppBar يظهر فقط على الموبايل
      appBar: isMobile
          ? AppBar(
              title: Text("لوحة التحكم"),
              backgroundColor: Colors.yellow[800],
            )
          : null,

      // Drawer للموبايل فقط
      drawer: isMobile
          ? Drawer(
              child: _buildSideMenu(BoxConstraints(maxWidth: 250)),
            )
          : null,

      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            // شاشة كبيرة → Sidebar ثابت
            return Row(
              children: [
                _buildSideMenu(constraints),
                Expanded(
                  child: _menuItems[_selectedIndex]['builder'](context),
                ),
              ],
            );
          }

          // شاشة موبايل → محتوى فقط
          return _menuItems[_selectedIndex]['builder'](context);
        },
      ),
    );
  }

  // بناء القائمة الجانبية (يستخدم للـ Drawer و Sidebar)
  Widget _buildSideMenu(BoxConstraints constraints) {
    double menuWidth = constraints.maxWidth > 1200 ? 280 : 250;

    return Container(
      width: menuWidth,
      decoration: BoxDecoration(
        color: Colors.yellow[700],
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 0))
        ],
      ),
      child: Column(
        children: [
          // رأس القائمة
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.yellow[700],
            child: Column(
              children: [
                CircleAvatar(
                  radius: constraints.maxWidth > 1200 ? 40 : 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.yellow[700]),
                ),
                SizedBox(height: 10),
                Text('مسئول النظام',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text('Admin@system.com',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),

          // عناصر القائمة
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return _buildMenuItem(
                  title: item['title'],
                  icon: item['icon'],
                  isSelected: _selectedIndex == index,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });

                    // لو Drawer مفتوح → اقفله
                    if (Navigator.of(context).canPop())
                      Navigator.of(context).pop();
                  },
                  constraints: constraints,
                );
              },
            ),
          ),

          // زر الخروج
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.logout, size: 16),
              label: Text('تسجيل خروج'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // عنصر من عناصر القائمة
  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required BoxConstraints constraints,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading:
            Icon(icon, color: isSelected ? Colors.yellow[700] : Colors.white70),
        title: Text(title,
            style:
                TextStyle(color: isSelected ? Colors.yellow[700] : Colors.white)),
        tileColor: isSelected ? Colors.white : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: onTap,
      ),
    );
  }
}
