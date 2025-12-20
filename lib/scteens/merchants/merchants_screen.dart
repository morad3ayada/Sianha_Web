import 'package:flutter/material.dart';
import 'dart:convert';
import '../../core/api/api_constants.dart';
import '../../core/api/api_service.dart';
import 'ShopCategoriesScreen.dart';
import 'merchant_profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'متجر الفنيين - البحث المتقدم',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: Color(0xFFF8FAFF),
      ),
      home: MerchantFilterScreen(),
    );
  }
}

class Merchant {
  final String id;
  final String name;
  final String governorate;
  final String center;
  final String shopType;
  final double rating;
  final bool isVerified;
  final String phone;
  final int experienceYears;
  final String? merchantId;

  Merchant({
    required this.id,
    required this.name,
    required this.governorate,
    required this.center,
    this.shopType = 'متجر عام', // Default as not in API
    this.rating = 4.0, // Default
    this.isVerified = true, // Default
    required this.phone,
    this.experienceYears = 2, // Default
    this.merchantId,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    if (json.keys.contains('merchantId')) {
       print("FOUND merchantId in list: ${json['merchantId']}");
    } else {
       // print("Keys in list item: ${json.keys.toList()}"); 
    }
    
    return Merchant(
      id: json['id'] ?? '',
      name: json['fullName'] ?? 'Unknown',
      governorate: json['governorateName'] ?? 'غير محدد',
      center: json['areaName'] ?? 'غير محدد',
      phone: json['phoneNumber'] ?? '',
      merchantId: json['merchantId'], 
      // Map other fields if available in future
    );
  }
}

class MerchantFilterScreen extends StatefulWidget {
  @override
  _MerchantFilterScreenState createState() => _MerchantFilterScreenState();
}

class _MerchantFilterScreenState extends State<MerchantFilterScreen> {
  List<Merchant> allMerchants = [];
  List<Merchant> filtered = [];
  bool _isLoading = true;
  String? _errorMessage;

  String? selectedGov;
  String? selectedCenter;
  String? selectedShopType;

  // Derived lists for dropdowns
  List<String> governorates = [];
  List<String> centers = [];
  List<String> types = ['متجر عام', 'محل موبايلات', 'محل أدوات كهربائية', 'محل دهانات']; // Examples or extracted

  @override
  void initState() {
    super.initState();
    _fetchMerchants();
  }

  Future<void> _fetchMerchants() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService().get(
        '${ApiConstants.users}?Role=3', // Role 3 for Merchants
        hasToken: true,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic> data = responseBody['items'] ?? [];
        
        setState(() {
          allMerchants = data.map((json) => Merchant.fromJson(json)).toList();
          filtered = List.from(allMerchants);
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

  void _extractFilterOptions() {
    // Extract unique governorates
    governorates = allMerchants.map((m) => m.governorate).toSet().toList();
    governorates.sort();
  }

  void filterMerchants() {
    setState(() {
      filtered = allMerchants.where((m) {
        bool matchGov = selectedGov == null || m.governorate == selectedGov;
        bool matchCenter = selectedCenter == null || m.center == selectedCenter;
        // bool matchType = selectedShopType == null || m.shopType == selectedShopType; 
        // Note: Since shopType is defaulted, this filter might not be very useful yet, but kept logic.
        return matchGov && matchCenter;
      }).toList();
    });
  }

  void _updateCenters() {
    if (selectedGov != null) {
      centers = allMerchants
          .where((m) => m.governorate == selectedGov)
          .map((m) => m.center)
          .toSet()
          .toList();
      centers.sort();
    } else {
      centers = [];
    }
  }

  void resetFilters() {
    setState(() {
      selectedGov = null;
      selectedCenter = null;
      selectedShopType = null;
      centers = [];
      filtered = List.from(allMerchants);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("البحث عن المحلات", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("ابحث عن أفضل المحلات في منطقتك", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _fetchMerchants),
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
                      ElevatedButton(onPressed: _fetchMerchants, child: Text("إعادة المحاولة"))
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Filters Section
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.filter_alt, color: Colors.yellow[900]),
                              SizedBox(width: 8),
                              Text("فلاتر البحث", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.yellow[900])),
                            ],
                          ),
                          SizedBox(height: 16),
                          _buildDropdown(
                            hint: "اختر المحافظة",
                            value: selectedGov,
                            items: governorates,
                            icon: Icons.location_city,
                            onChanged: (val) {
                              setState(() {
                                selectedGov = val;
                                selectedCenter = null;
                                _updateCenters();
                                filterMerchants();
                              });
                            },
                          ),
                          SizedBox(height: 12),
                          if (centers.isNotEmpty)
                            _buildDropdown(
                              hint: "اختر المنطقة",
                              value: selectedCenter,
                              items: centers,
                              icon: Icons.map,
                              onChanged: (val) {
                                setState(() {
                                  selectedCenter = val;
                                  filterMerchants();
                                });
                              },
                            ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: resetFilters,
                              child: Text("مسح الكل"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Results Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("نتائج البحث", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.yellow[900])),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.yellow[900]!.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text("${filtered.length} محل", style: TextStyle(color: Colors.yellow[900], fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    // Processed List
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(child: Text("لا توجد نتائج"))
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                return _buildMerchantCard(context, filtered[index]);
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Row(children: [Icon(icon, color: Colors.yellow[900], size: 20), SizedBox(width: 10), Text(hint)]),
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildMerchantCard(BuildContext context, Merchant m) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MerchantProfileScreen(
                userId: m.id,
                merchantId: m.merchantId,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF1E3A8A).withOpacity(0.1),
                    child: Icon(Icons.store, color: Color(0xFF1E3A8A)),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(m.shopType, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      ],
                    ),
                  ),
                  if (m.isVerified) Icon(Icons.verified, color: Colors.blue, size: 20),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text("${m.governorate} - ${m.center}", style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(m.phone, style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
