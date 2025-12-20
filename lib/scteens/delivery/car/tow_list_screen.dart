import 'package:flutter/material.dart';
import 'tow_profile_screen.dart';
import 'tow_tracking_screen.dart';

class TowListScreen extends StatefulWidget {
  @override
  _TowListScreenState createState() => _TowListScreenState();
}

class _TowListScreenState extends State<TowListScreen> {
  List<Governorate> governorates = [];
  List<Tow> tows = [];
  String selectedGovernorate = 'الكل';
  String searchQuery = '';
  String _selectedStatus = 'الكل';
  bool _showByGovernorate = false;

  @override
  void initState() {
    super.initState();
    _loadGovernorates();
    _loadTows();
  }

  void _loadGovernorates() {
    governorates = [
      Governorate('القاهرة', 15, [
        Tow('ونش 101', 'القاهرة', 'مدينة نصر', 'متاح', '01234567891'),
        Tow('ونش 102', 'القاهرة', 'المعادي', 'مشغول', '01234567892'),
        Tow('ونش 103', 'القاهرة', 'الزمالك', 'متاح', '01234567893'),
      ]),
      Governorate('الجيزة', 12, [
        Tow('ونش 201', 'الجيزة', 'الدقي', 'متاح', '01234567894'),
        Tow('ونش 202', 'الجيزة', 'المهندسين', 'في الطريق', '01234567895'),
      ]),
      Governorate('الإسكندرية', 8, [
        Tow('ونش 301', 'الإسكندرية', 'سموحة', 'متاح', '01234567896'),
        Tow('ونش 302', 'الإسكندرية', 'المنتزه', 'مشغول', '01234567897'),
      ]),
      Governorate('الدقهلية', 6, []),
      Governorate('المنوفية', 5, []),
    ];
  }

  void _loadTows() {
    tows = governorates.expand((gov) => gov.tows).toList();
  }

  List<Tow> get filteredTows {
    return tows.where((tow) {
      if (selectedGovernorate != 'الكل' &&
          tow.governorate != selectedGovernorate) {
        return false;
      }
      if (_selectedStatus != 'الكل' && tow.status != _selectedStatus) {
        return false;
      }
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        if (!tow.name.toLowerCase().contains(query) &&
            !tow.area.toLowerCase().contains(query) &&
            !tow.phone.contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('قائمة الونشات'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNewTow,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFiltersSection(),
          _buildQuickStats(),
          Expanded(
            child: _showByGovernorate
                ? _buildGovernoratesList()
                : _buildTowsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showByGovernorate = !_showByGovernorate;
          });
        },
        child: Icon(_showByGovernorate ? Icons.list : Icons.map),
        tooltip: _showByGovernorate ? 'عرض القائمة' : 'عرض الخريطة',
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن ونش...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedGovernorate,
                    items: [
                      DropdownMenuItem(value: 'الكل', child: Text('الكل')),
                      ...governorates.map((gov) {
                        return DropdownMenuItem(
                          value: gov.name,
                          child: Text('${gov.name} (${gov.totalTows})'),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedGovernorate = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'المحافظة',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    items: [
                      DropdownMenuItem(value: 'الكل', child: Text('الكل')),
                      DropdownMenuItem(value: 'متاح', child: Text('متاح')),
                      DropdownMenuItem(value: 'مشغول', child: Text('مشغول')),
                      DropdownMenuItem(
                          value: 'في الطريق', child: Text('في الطريق')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'الحالة',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    int availableTows = tows.where((t) => t.status == 'متاح').length;
    int busyTows = tows.where((t) => t.status == 'مشغول').length;
    int inTransitTows = tows.where((t) => t.status == 'في الطريق').length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: _buildStatCard('المتاحة', availableTows, Colors.green)),
          SizedBox(width: 8),
          Expanded(child: _buildStatCard('المشغولة', busyTows, Colors.red)),
          SizedBox(width: 8),
          Expanded(
              child: _buildStatCard('في الطريق', inTransitTows, Colors.orange)),
          SizedBox(width: 8),
          Expanded(child: _buildStatCard('الإجمالي', tows.length, Colors.blue)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGovernoratesList() {
    return ListView.builder(
      itemCount: governorates.length,
      itemBuilder: (context, index) {
        return _buildGovernorateCard(governorates[index]);
      },
    );
  }

  Widget _buildGovernorateCard(Governorate gov) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange[100],
          child: Text(
            gov.totalTows.toString(),
            style: TextStyle(
                color: Colors.orange[800], fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          gov.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${gov.availableTows} متاح - ${gov.busyTows} مشغول'),
        children: gov.tows.map((tow) {
          return _buildTowListItem(tow);
        }).toList(),
      ),
    );
  }

  Widget _buildTowsList() {
    final displayTows = filteredTows;

    if (displayTows.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'لا توجد ونشات',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'تغيير الفلاتر أو إضافة ونش جديد',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: displayTows.length,
      itemBuilder: (context, index) {
        return _buildTowListItem(displayTows[index]);
      },
    );
  }

  Widget _buildTowListItem(Tow tow) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(tow.status),
          child: Icon(Icons.local_shipping, color: Colors.white),
        ),
        title: Text(
          tow.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${tow.governorate} - ${tow.area}'),
            Text(tow.phone),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(tow.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _getStatusColor(tow.status)),
              ),
              child: Text(
                tow.status,
                style: TextStyle(
                  fontSize: 10,
                  color: _getStatusColor(tow.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 4),
            Icon(Icons.arrow_forward_ios, size: 12),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TowProfileScreen(
                towData: {
                  // ✅ تم التغيير هنا من tow إلى towData
                  'name': tow.name,
                  'governorate': tow.governorate,
                  'area': tow.area,
                  'phone': tow.phone,
                  'status': tow.status,
                  'plateNumber': 'أ ب ج 123',
                  'type': 'ونش متوسط',
                  'year': '2022',
                  'driverName': 'محمد أحمد',
                  'licenseNumber': '123456',
                  'experience': '5 سنوات',
                  'rating': '4.5',
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _addNewTow() {
    String? selectedGovernorate;
    String towName = '';
    String area = '';
    String phone = '';
    String driver = '';
    String plateNumber = '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('إضافة ونش جديد'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'المحافظة'),
                    items: governorates.map((gov) {
                      return DropdownMenuItem(
                        value: gov.name,
                        child: Text(gov.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedGovernorate = value;
                    },
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(labelText: 'اسم الونش'),
                    onChanged: (value) => towName = value,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(labelText: 'المنطقة/المركز'),
                    onChanged: (value) => area = value,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(labelText: 'رقم الهاتف'),
                    onChanged: (value) => phone = value,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(labelText: 'اسم السائق'),
                    onChanged: (value) => driver = value,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(labelText: 'رقم اللوحة'),
                    onChanged: (value) => plateNumber = value,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedGovernorate != null &&
                      towName.isNotEmpty &&
                      phone.isNotEmpty) {
                    // إضافة الونش الجديد
                    final newTow =
                        Tow(towName, selectedGovernorate!, area, 'متاح', phone);

                    // تحديث القوائم
                    final govIndex = governorates
                        .indexWhere((g) => g.name == selectedGovernorate);
                    if (govIndex != -1) {
                      governorates[govIndex].tows.add(newTow);
                    }

                    _loadTows(); // إعادة تحميل الونشات

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم إضافة الونش بنجاح'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('يرجى ملء جميع الحقول المطلوبة'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text('إضافة'),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'متاح':
        return Colors.green;
      case 'مشغول':
        return Colors.red;
      case 'في الطريق':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

// نماذج البيانات
class Governorate {
  final String name;
  final int totalTows;
  final List<Tow> tows;

  Governorate(this.name, this.totalTows, this.tows);

  int get availableTows => tows.where((t) => t.status == 'متاح').length;
  int get busyTows => tows.where((t) => t.status == 'مشغول').length;
}

class Tow {
  final String name;
  final String governorate;
  final String area;
  final String status;
  final String phone;

  Tow(this.name, this.governorate, this.area, this.status, this.phone);
}
