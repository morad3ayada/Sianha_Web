import 'package:flutter/material.dart';

// استيراد الشاشات الأخرى
import 'technicians/technicians_screen.dart';
import 'merchants/merchants_screen.dart';
import 'complaints/complaints_screen.dart';
import 'financial/financial_dashboard_screen.dart';
import 'technician/TechnicianTrackin/technician_tracking_screen.dart';
import 'merchant/merchant_tracking_screen.dart';
import 'categories/categories_screen.dart';
import 'categories/sub_categories_screen.dart';
import 'reports/reports_screen.dart';
import 'merchant/merchantorders/merchant_orders_screen.dart';
import 'technician/technician_orders_screen.dart';
import 'banned/banned_screen.dart';
import 'delivery/delivery_screen.dart';

// استيراد شاشة العملاء (أنشئ هذا الملف لاحقاً)
import 'customers/customers_screen.dart';
import 'governorates/governorates_screen.dart';
import 'areas/areas_screen.dart';
import 'financial/profile_screen.dart';
import 'financial/admins_screen.dart';
import 'financial/auth_service.dart';
import 'financial/user_service.dart';
import 'login_screen.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  String _userName = 'جاري التحميل...';
  String _userEmail = '...';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final data = await _userService.getProfile();
      if (mounted) {
        setState(() {
          _userName = data['fullName'] ?? 'مسئول النظام';
          _userEmail = data['email'] ?? 'Admin@system.com';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _userName = 'مسئول النظام';
          _userEmail = 'Admin@system.com';
        });
      }
    }
  }

  Future<void> _showComingSoonDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('تنبيه', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Icon(Icons.info_outline, color: Colors.yellow[800]),
          ],
        ),
        content: const Text(
          'يتم حالياً تحديث هذا القسم، وسيكون متاحاً قريباً جداً. شكراً لتفهمكم.',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً', style: TextStyle(color: Colors.yellow[800], fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟', textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('خروج', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white)),
      );

      try {
        await _authService.logout();
      } finally {
        if (mounted) {
          // Remove loading indicator
          Navigator.pop(context);
          // Go to login screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      }
    }
  }

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
      'title': 'الأقسام الرئيسية',
      'icon': Icons.category,
      'builder': (context) => CategoriesScreen()
    },
    {
      'title': 'الأقسام الفرعية',
      'icon': Icons.subdirectory_arrow_right,
      'builder': (context) => SubCategoriesScreen()
    },
    {
      'title': 'طلبات عمل تاجر',
      'icon': Icons.shopping_cart,
      'builder': (context) => MerchantOrdersScreen()
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
      'title': 'التقييمات',
      'icon': Icons.star,
      'builder': (context) => ReportsScreen()
    },
    {
      'title': 'الملف الشخصي',
      'icon': Icons.person_outline,
      'builder': (context) => ProfileScreen()
    },
    {
      'title': 'المسؤولين',
      'icon': Icons.admin_panel_settings_outlined,
      'builder': (context) => AdminsScreen()
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
                Text(_userName,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text(_userEmail,
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
                    if (item['title'] == 'طلبات عمل تاجر') {
                      _showComingSoonDialog();
                      return;
                    }
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
              onPressed: _logout,
              icon: Icon(Icons.logout, size: 16),
              label: Text('تسجيل خروج'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          // حقل المطور
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.code, size: 14, color: Colors.white.withOpacity(0.5)),
                SizedBox(width: 5),
                Text(
                  'Developed by Morad3ayada',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required BoxConstraints constraints,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected 
          ? [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
          : [],
      ),
      child: Stack(
        children: [
          ListTile(
            leading: Icon(
              icon, 
              color: isSelected ? Colors.yellow[800] : Colors.white,
              size: 22,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black87 : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onTap: onTap,
            hoverColor: Colors.white.withOpacity(0.1),
          ),
          if (isSelected)
            Positioned(
              right: 0,
              top: 12,
              bottom: 12,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: Colors.yellow[800],
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(4)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
