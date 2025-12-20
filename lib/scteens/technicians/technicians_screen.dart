import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/api/api_constants.dart';
import '../../core/api/api_service.dart';
import 'technician_profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filter Technicians App',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.yellow[800],
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        fontFamily: 'Cairo',
      ),
      home: FilterScreen(),
    );
  }
}

class Technician {
  final String id; // userId
  final String technicianId; // actual technician ID
  final String name;
  final String governorate;
  final String center;
  final String category;
  final String phone;
  bool isActive;

  Technician({
    required this.id,
    required this.technicianId,
    required this.name,
    required this.governorate,
    required this.center,
    required this.category,
    required this.phone,
    this.isActive = false,
  });

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(
      id: json['id'] ?? '',
      technicianId: json['technicianId'] ?? json['id'] ?? '', // Use technicianId if available, fallback to id
      name: json['fullName'] ?? 'Unknown',
      governorate: json['governorateName'] ?? 'غير محدد',
      center: json['areaName'] ?? 'غير محدد',
      category: json['details'] ?? 'عام',
      phone: json['phoneNumber'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'governorate': governorate,
      'center': center,
      'category': category,
      'image': 'https://via.placeholder.com/150',
      'specialization': category,
      'rating': 4.5,
      'completedJobs': 50,
      'experience': '5 سنوات',
      'hourlyRate': '100 جنيه',
      'phone': phone,
      'address': '$governorate - $center',
      'reviews': 25,
      'reviews': 25,
      'isOnline': true,
      'isActive': isActive,
    };
  }
}

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<Technician> allTechs = [];
  List<Technician> filteredTechs = [];
  bool _isLoading = true;
  String? _errorMessage;

  String? selectedGov;
  String? selectedCenter;
  String? selectedCategory;

  List<String> governorates = [];
  List<String> centers = [];
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchTechnicians();
  }

  Future<void> _fetchTechnicians() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService().get(
        '${ApiConstants.users}?Role=2',
        hasToken: true,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic> data = responseBody['items'] ?? [];

        setState(() {
          allTechs = data.map((json) => Technician.fromJson(json)).toList();
          filteredTechs = List.from(allTechs);
          _extractFilterOptions();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "فشل تحميل البيانات: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "حدث خطأ: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _blockTechnician(Technician t) async {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('تأكيد الحظر'),
        content: Text('هل أنت متأكد من حظر هذا الفني؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogContext); // Close dialog using its context
              
              try {
                final response = await ApiService().post(
                  '${ApiConstants.users}/${t.id}/block',
                  hasToken: true,
                );
                
                if (!mounted) return; // Check if screen is still mounted

                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar( // Use screen context
                    SnackBar(
                      content: Text('تم حظر الفني بنجاح'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _fetchTechnicians(); 
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('فشل حظر الفني: ${response.statusCode}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('حدث خطأ: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('حظر', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _extractFilterOptions() {
    governorates = allTechs.map((t) => t.governorate).toSet().toList();
    governorates.sort();
  }

  void _updateCenters() {
    if (selectedGov != null) {
      centers = allTechs
          .where((t) => t.governorate == selectedGov)
          .map((t) => t.center)
          .toSet()
          .toList();
      centers.sort();
    } else {
      centers = [];
    }
  }

  void _updateCategories() {
    if (selectedGov != null && selectedCenter != null) {
      categories = allTechs
          .where((t) =>
              t.governorate == selectedGov && t.center == selectedCenter)
          .map((t) => t.category)
          .toSet()
          .toList();
      categories.sort();
    } else {
      categories = [];
    }
  }

  void filterTechs() {
    setState(() {
      filteredTechs = allTechs
          .where((t) =>
              (selectedGov == null || t.governorate == selectedGov) &&
              (selectedCenter == null || t.center == selectedCenter) &&
              (selectedCategory == null || t.category == selectedCategory))
          .toList();
    });
  }

  void resetFilters() {
    setState(() {
      selectedGov = null;
      selectedCenter = null;
      selectedCategory = null;
      centers = [];
      categories = [];
      filteredTechs = List.from(allTechs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("البحث عن فنيين 🛠️"),
        backgroundColor: Colors.yellow[700],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'تحديث البيانات',
            onPressed: _fetchTechnicians,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                      ElevatedButton(
                          onPressed: _fetchTechnicians,
                          child: Text("إعادة المحاولة"))
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      _buildDropdown(
                        value: selectedGov,
                        hint: "اختار المحافظة",
                        items: governorates,
                        onChanged: (value) {
                          setState(() {
                            selectedGov = value;
                            selectedCenter = null;
                            selectedCategory = null;
                            _updateCenters();
                            filterTechs();
                          });
                        },
                      ),
                      SizedBox(height: 15),
                      if (centers.isNotEmpty)
                        _buildDropdown(
                          value: selectedCenter,
                          hint: "اختار المركز",
                          items: centers,
                          onChanged: (value) {
                            setState(() {
                              selectedCenter = value;
                              selectedCategory = null;
                              _updateCategories();
                              filterTechs();
                            });
                          },
                        ),
                      SizedBox(height: 15),
                      if (categories.isNotEmpty)
                        _buildDropdown(
                          value: selectedCategory,
                          hint: "اختار التخصص",
                          items: categories,
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value;
                              filterTechs();
                            });
                          },
                        ),
                      SizedBox(height: 25),
                      _buildResultHeader(),
                      SizedBox(height: 10),
                      Expanded(
                        child: filteredTechs.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                itemCount: filteredTechs.length,
                                itemBuilder: (context, index) {
                                  final t = filteredTechs[index];
                                  return _buildTechnicianCard(context, t);
                                },
                              ),
                      )
                    ],
                  ),
                ),
    );
  }

  Widget _buildDropdown({
    String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.yellow.shade200, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
        isExpanded: true,
        underline: SizedBox(),
        icon: Icon(Icons.arrow_drop_down_circle_outlined,
            color: Colors.yellow.shade800),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text("الكل",
                style: TextStyle(
                    color: Colors.red.shade400, fontWeight: FontWeight.bold)),
          ),
          ...items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: TextStyle(fontSize: 16)),
            );
          }).toList(),
        ],
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTechnicianCard(BuildContext context, Technician t) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.yellow.shade100,
          child: Icon(Icons.person_pin_outlined,
              color: Colors.yellow.shade800, size: 30),
        ),
        title: Text(
          t.name,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.location_on, "${t.governorate} - ${t.center}",
                  Colors.grey.shade600),
              SizedBox(height: 3),
              _buildInfoRow(
                  Icons.build_circle, t.category, Colors.teal.shade700,
                  bold: true),
              SizedBox(height: 3),
              _buildInfoRow(Icons.phone, t.phone, Colors.black54),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             IconButton(
              icon: Icon(Icons.block, color: Colors.red),
              tooltip: 'حظر الفني',
              onPressed: () => _blockTechnician(t),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 18, color: Colors.yellow.shade800),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TechnicianProfile(
                userId: t.id,
                technicianId: t.technicianId,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color,
      {bool bold = false}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
          SizedBox(height: 15),
          Text(
            "لا يوجد فنيون مطابقون لمعايير البحث",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildResultHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "عدد الفنيين المطابقين: ${filteredTechs.length}",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.yellow.shade800,
            ),
          ),
          if (selectedGov != null ||
              selectedCenter != null ||
              selectedCategory != null)
            TextButton(
              onPressed: resetFilters,
              child: Text(
                "مسح الفلاتر",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
