// main.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // لإظهار التاريخ والوقت بشكل جميل
import "OrdersListScreen.dart";

void main() {
  runApp(MyApp());
}

/*
  نسخة احترافية لشاشة تتبع تاجر (Merchant Tracking Screen)
  - فلاتر: محافظة -> مركز -> تخصص محل
  - قسم "طلبات اليوم": احصاءات ولفترة اليوم
  - قسم "طلبات قيد التجهيز": الطلبات التي ما زالت تحت التجهيز
  - بيانات وهمية (Dummy Data) قابلة للاستبدال بربط API لاحقًا
  - RTL / Arabic friendly
*/

// ----------------------- نموذج (Model) -----------------------
class Merchant {
  final String id;
  final String name;
  final String governorate;
  final String center;
  final String shopType;

  Merchant({
    required this.id,
    required this.name,
    required this.governorate,
    required this.center,
    required this.shopType,
  });
}

enum OrderStatus { success, failed, preparing }

class Order {
  final String id;
  final String merchantId;
  final DateTime date;
  final OrderStatus status;
  final String details;

  Order({
    required this.id,
    required this.merchantId,
    required this.date,
    required this.status,
    required this.details,
  });
}

// ----------------------- بيانات المحافظات والمراكز -----------------------
final Map<String, List<String>> governorates = {
  "القاهرة": ["مدينة نصر", "المطرية", "المقطم", "الزمالك"],
  "الجيزة": ["الهرم", "أكتوبر", "الطالبية", "الوراق"],
  "الإسكندرية": ["سيدي جابر", "العصافرة", "محرم بك"],
  "سوهاج": ["طهطا", "طما", "جرجا", "ساقلته"],
  "أسيوط": ["ديروط", "منفلوط", "القوصية"],
};

// ----------------------- تخصصات المحلات -----------------------
final List<String> shopCategories = [
  "موبايلات",
  "أدوات كهرباء",
  "أدوات سباكة",
  "ملابس",
  "دهانات",
  "موتوسيكلات",
];

// ----------------------- قائمة التجار الوهمية -----------------------
final List<Merchant> allMerchants = [
  Merchant(
      id: 'm1',
      name: 'تاجر محمد علي',
      governorate: 'القاهرة',
      center: 'مدينة نصر',
      shopType: 'موبايلات'),
  Merchant(
      id: 'm2',
      name: 'متجر محمود',
      governorate: 'القاهرة',
      center: 'المطرية',
      shopType: 'أدوات كهرباء'),
  Merchant(
      id: 'm3',
      name: 'محل عمرو',
      governorate: 'الجيزة',
      center: 'الهرم',
      shopType: 'موبايلات'),
  Merchant(
      id: 'm4',
      name: 'محلات الورد',
      governorate: 'الإسكندرية',
      center: 'محرم بك',
      shopType: 'ملابس'),
  Merchant(
      id: 'm5',
      name: 'خليل سباكة',
      governorate: 'سوهاج',
      center: 'طهطا',
      shopType: 'أدوات سباكة'),
  Merchant(
      id: 'm6',
      name: 'ورشة سليم',
      governorate: 'الجيزة',
      center: 'أكتوبر',
      shopType: 'موتوسيكلات'),
];

// ----------------------- أوامر وهمية -----------------------
// بعض الطلبات بتاريخ اليوم وبعضها قبل اليوم لبناء الاحصاءات
final DateTime now = DateTime.now();
final List<Order> allOrders = List.generate(40, (i) {
  // نوزّع الطلبات عبر التجار
  final merchant = allMerchants[i % allMerchants.length];
  // تاريخ: بعضهم اليوم وبعضهم قبل كم يوم
  final date = now.subtract(Duration(days: i % 5, hours: i % 24));
  // حالة توزيع بسيطة
  final status = (i % 7 == 0)
      ? OrderStatus.failed
      : (i % 5 == 0 ? OrderStatus.preparing : OrderStatus.success);
  return Order(
    id: 'o$i',
    merchantId: merchant.id,
    date: date,
    status: status,
    details: "طلب رقم $i من ${merchant.name}",
  );
});

// ----------------------- التطبيق -----------------------
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Merchant Tracking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

// ----------------------- الشاشة الرئيسية: MerchantTrackingScreen -----------------------
class PreparingOrdersScreen extends StatefulWidget {
  @override
  _MerchantTrackingScreenState createState() => _MerchantTrackingScreenState();
}

class _MerchantTrackingScreenState extends State<PreparingOrdersScreen> {
  String? selectedGov;
  String? selectedCenter;
  String? selectedCategory;

  List<String> centers = [];
  List<Merchant> filteredMerchants = [];
  List<Order> filteredOrders = [];

  // تبويب نشط: 0 -> طلبات اليوم ، 1 -> طلبات قيد التجهيز
  int activeTab = 0;

  @override
  void initState() {
    super.initState();
    resetFiltersAndData();
  }

  void resetFiltersAndData() {
    selectedGov = null;
    selectedCenter = null;
    selectedCategory = null;
    centers = [];
    applyFilters();
  }

  void applyFilters() {
    // فلترة التجار
    filteredMerchants = allMerchants.where((m) {
      final matchGov = selectedGov == null || m.governorate == selectedGov;
      final matchCenter = selectedCenter == null || m.center == selectedCenter;
      final matchCat =
          selectedCategory == null || m.shopType == selectedCategory;
      return matchGov && matchCenter && matchCat;
    }).toList();

    // فلترة الطلبات تبعًا لاختيارات المستخدم
    filteredOrders = allOrders.where((o) {
      final merchant = allMerchants.firstWhere((m) => m.id == o.merchantId);
      final matchGov =
          selectedGov == null || merchant.governorate == selectedGov;
      final matchCenter =
          selectedCenter == null || merchant.center == selectedCenter;
      final matchCat =
          selectedCategory == null || merchant.shopType == selectedCategory;
      return matchGov && matchCenter && matchCat;
    }).toList();

    setState(() {});
  }

  // احصاءات طلبات اليوم للاختيارات الحالية
  Map<String, dynamic> todaysStats() {
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayOrders =
        filteredOrders.where((o) => o.date.isAfter(todayStart)).toList();
    final success =
        todayOrders.where((o) => o.status == OrderStatus.success).length;
    final failed =
        todayOrders.where((o) => o.status == OrderStatus.failed).length;
    final preparing =
        todayOrders.where((o) => o.status == OrderStatus.preparing).length;
    final total = todayOrders.length;
    final successRate = total == 0 ? 0 : (success / total * 100).round();
    return {
      'total': total,
      'success': success,
      'failed': failed,
      'preparing': preparing,
      'successRate': successRate,
      'list': todayOrders,
    };
  }

  // طلبات قيد التجهيز (عامة، ليست مقتصرة على اليوم)
  List<Order> preparingOrders() {
    return filteredOrders
        .where((o) => o.status == OrderStatus.preparing)
        .toList();
  }

  // عدد الطلبات لكل تاجر في فترة الفلترة (لكرت الإحصاء)
  Map<String, Map<String, int>> merchantOrderSummary() {
    final Map<String, Map<String, int>> summary = {};
    for (var m in filteredMerchants) {
      final orders = filteredOrders.where((o) => o.merchantId == m.id);
      final success =
          orders.where((o) => o.status == OrderStatus.success).length;
      final failed = orders.where((o) => o.status == OrderStatus.failed).length;
      final preparing =
          orders.where((o) => o.status == OrderStatus.preparing).length;
      summary[m.id] = {
        'success': success,
        'failed': failed,
        'preparing': preparing,
        'total': orders.length,
      };
    }
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final stats = todaysStats();
    final preparing = preparingOrders();
    final merchantSummary = merchantOrderSummary();

    return Scaffold(
      appBar: AppBar(
        title: Text('شاشة تتبع التاجر'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'إعادة تحميل/إعادة تعيين',
            onPressed: () {
              resetFiltersAndData();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildFiltersCard(),
            SizedBox(height: 12),
            _buildTabs(),
            SizedBox(height: 12),

            // المحتوى بحسب التبويب
            Expanded(
              child: activeTab == 0
                  ? _buildTodaysOrdersView(stats, merchantSummary)
                  : _buildPreparingOrdersView(preparing),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------- فلترة UI -----------------------
  Widget _buildFiltersCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildGovernorateDropdown()),
                SizedBox(width: 10),
                Expanded(child: _buildCenterDropdown()),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildCategoryDropdown()),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // طبّق الفلاتر
                    applyFilters();
                  },
                  icon: Icon(Icons.search),
                  label: Text('تطبيق'),
                  style: ElevatedButton.styleFrom(minimumSize: Size(90, 45)),
                ),
                SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    resetFiltersAndData();
                  },
                  child: Text('مسح'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGovernorateDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: _dropdownDecoration(),
      child: DropdownButton<String>(
        hint: Text('اختار المحافظة'),
        isExpanded: true,
        value: selectedGov,
        underline: SizedBox(),
        items: [
          DropdownMenuItem<String>(value: null, child: Text('الكل')),
          ...governorates.keys
              .map((g) => DropdownMenuItem<String>(value: g, child: Text(g))),
        ],
        onChanged: (val) {
          setState(() {
            selectedGov = val;
            selectedCenter = null;
            if (val != null)
              centers = governorates[val] ?? [];
            else
              centers = [];
          });
        },
      ),
    );
  }

  Widget _buildCenterDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: _dropdownDecoration(),
      child: DropdownButton<String>(
        hint: Text('اختار المركز'),
        isExpanded: true,
        value: selectedCenter,
        underline: SizedBox(),
        items: [
          DropdownMenuItem<String>(value: null, child: Text('الكل')),
          ...centers
              .map((c) => DropdownMenuItem<String>(value: c, child: Text(c))),
        ],
        onChanged: (val) {
          setState(() {
            selectedCenter = val;
          });
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: _dropdownDecoration(),
      child: DropdownButton<String>(
        hint: Text('اختار تخصص المحل'),
        isExpanded: true,
        value: selectedCategory,
        underline: SizedBox(),
        items: [
          DropdownMenuItem<String>(value: null, child: Text('الكل')),
          ...shopCategories
              .map((c) => DropdownMenuItem<String>(value: c, child: Text(c))),
        ],
        onChanged: (val) {
          setState(() {
            selectedCategory = val;
          });
        },
      ),
    );
  }

  BoxDecoration _dropdownDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    );
  }

  // ----------------------- التبويبات -----------------------
  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                activeTab = 0;
              });
            },
            child: _tabButton('طلبات اليوم', activeTab == 0, icon: Icons.today),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                activeTab = 1;
              });
            },
            child: _tabButton('طلبات قيد التجهيز', activeTab == 1,
                icon: Icons.kitchen),
          ),
        ),
      ],
    );
  }

  Widget _tabButton(String title, bool active, {IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: active ? Colors.blue.shade700 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, color: active ? Colors.white : Colors.black54),
          if (icon != null) SizedBox(width: 8),
          Text(title,
              style: TextStyle(
                  color: active ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ----------------------- محتوى "طلبات اليوم" -----------------------
  Widget _buildTodaysOrdersView(Map<String, dynamic> stats,
      Map<String, Map<String, int>> merchantSummary) {
    final todayList = stats['list'] as List<Order>;
    return Column(
      children: [
        _buildStatsRow(stats),
        SizedBox(height: 10),
        // اجمالي لكل تاجر (Cards)
        Expanded(
          child: merchantSummary.isEmpty
              ? Center(child: Text('لا يوجد تجار مطابقين للفلاتر'))
              : ListView(
                  children: merchantSummary.entries.map((entry) {
                    final merchantId = entry.key;
                    final summary = entry.value;
                    final merchant =
                        allMerchants.firstWhere((m) => m.id == merchantId);
                    return _merchantSummaryCard(merchant, summary);
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(Map<String, dynamic> stats) {
    return Row(
      children: [
        Expanded(
            child: _statCard('إجمالي اليوم', stats['total'].toString(),
                icon: Icons.receipt_long)),
        SizedBox(width: 8),
        Expanded(
            child: _statCard('ناجح', stats['success'].toString(),
                color: Colors.green, icon: Icons.check_circle)),
        SizedBox(width: 8),
        Expanded(
            child: _statCard('فشل', stats['failed'].toString(),
                color: Colors.red, icon: Icons.cancel)),
        SizedBox(width: 8),
        Expanded(
            child: _statCard('نسبة النجاح', '${stats['successRate']}%',
                icon: Icons.trending_up)),
      ],
    );
  }

  Widget _statCard(String title, String value, {Color? color, IconData? icon}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Row(children: [
              if (icon != null) Icon(icon, color: color ?? Colors.blue),
              SizedBox(width: 6),
              Text(title,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
            ]),
            SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color ?? Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _merchantSummaryCard(Merchant merchant, Map<String, int> summary) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          // افتح تفاصيل التاجر (صفحة منفصلة)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TodayOrdersScreen(),
            ),
          );
        },
        leading: CircleAvatar(
            child: Text(merchant.name.substring(0, 1)),
            backgroundColor: Colors.blue.shade100),
        title:
            Text(merchant.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            '${merchant.governorate} - ${merchant.center} • ${merchant.shopType}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('نجاح: ${summary['success']}',
                style: TextStyle(color: Colors.green)),
            Text('فشل: ${summary['failed']}',
                style: TextStyle(color: Colors.red)),
            Text('قيد تجهيز: ${summary['preparing']}',
                style: TextStyle(color: Colors.orange)),
          ],
        ),
      ),
    );
  }

  // ----------------------- محتوى "طلبات قيد التجهيز" -----------------------
  Widget _buildPreparingOrdersView(List<Order> preparing) {
    if (preparing.isEmpty) {
      return Center(child: Text('لا توجد طلبات قيد التجهيز ضمن الفلاتر'));
    }

    return ListView.builder(
      itemCount: preparing.length,
      itemBuilder: (context, index) {
        final order = preparing[index];
        final merchant =
            allMerchants.firstWhere((m) => m.id == order.merchantId);
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(child: Text(merchant.name.substring(0, 1))),
            title: Text('طلب ${order.id} • ${merchant.name}'),
            subtitle: Text(
                '${merchant.governorate} - ${merchant.center}\n${order.details}\n${DateFormat('yyyy/MM/dd – kk:mm').format(order.date)}'),
            isThreeLine: true,
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('قيد التجهيز',
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                ElevatedButton(
                  child: Text('عرض'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TodayOrdersScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
