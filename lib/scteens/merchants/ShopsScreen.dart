import 'package:flutter/material.dart';
import 'shop_details.dart';

class ShopsScreen extends StatefulWidget {
  final String governorate;
  final String center;
  final String categoryType;

  ShopsScreen({
    required this.governorate,
    required this.center,
    required this.categoryType,
  });

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  final Map<String, List<Map<String, dynamic>>> categorizedShops = {
    "electric": [
      {
        "name": "محل كهرباء الطاهر",
        "type": "كهرباء منازل",
        "phone": "01000000001",
        "rating": 4.5,
        "distance": "1.2 كم"
      },
      {
        "name": "محل كهرباء الرحمة",
        "type": "كهرباء عامة",
        "phone": "01000000002",
        "rating": 4.2,
        "distance": "0.8 كم"
      },
      {
        "name": "كهرباء النور",
        "type": "إضاءة وديكور",
        "phone": "01000000003",
        "rating": 4.8,
        "distance": "2.1 كم"
      },
    ],
    "plumber": [
      {
        "name": "سباكة مرسي",
        "type": "كشف تسريب",
        "phone": "01011111111",
        "rating": 4.3,
        "distance": "1.5 كم"
      },
      {
        "name": "سباك المستقبل",
        "type": "سباكة كاملة",
        "phone": "01022222222",
        "rating": 4.6,
        "distance": "0.5 كم"
      },
    ],
    "finishing": [
      {
        "name": "تشطيبات المهندس",
        "type": "أسقف وجبس",
        "phone": "01033333333",
        "rating": 4.7,
        "distance": "1.8 كم"
      },
      {
        "name": "ديكورات الفا",
        "type": "دهانات وتشطيبات",
        "phone": "01044444444",
        "rating": 4.4,
        "distance": "2.3 كم"
      },
    ],
    "parts": [
      {
        "name": "محل قطع غيار النور",
        "type": "أدوات كهرباء",
        "phone": "01055555555",
        "rating": 4.1,
        "distance": "1.0 كم"
      },
      {
        "name": "محل قطع غيار المدينة",
        "type": "سباكة وكهرباء",
        "phone": "01066666666",
        "rating": 4.9,
        "distance": "0.3 كم"
      },
    ],
  };

  List<Map<String, dynamic>> filteredShops = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredShops = categorizedShops[widget.categoryType] ?? [];
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredShops = categorizedShops[widget.categoryType] ?? [];
      } else {
        filteredShops = (categorizedShops[widget.categoryType] ?? [])
            .where((shop) =>
                shop["name"].toLowerCase().contains(query) ||
                shop["type"].toLowerCase().contains(query))
            .toList();
      }
    });
  }

  String getCategoryTitle(String category) {
    switch (category) {
      case "electric":
        return "كهرباء";
      case "plumber":
        return "سباكة";
      case "finishing":
        return "تشطيبات";
      case "parts":
        return "قطع غيار";
      default:
        return "محلات";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "${getCategoryTitle(widget.categoryType)} - ${widget.center}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          // 🔍 شريط البحث
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "ابحث عن محل...",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.blue[700]),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            searchController.clear();
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),

          // ℹ️ معلومات النتائج
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "عدد المحلات: ${filteredShops.length}",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (searchController.text.isNotEmpty)
                  Text(
                    "نتائج البحث عن: \"${searchController.text}\"",
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // 📋 قائمة المحلات
          Expanded(
            child: filteredShops.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.store_mall_directory_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          searchController.text.isEmpty
                              ? "لا توجد محلات متاحة"
                              : "لا توجد نتائج للبحث",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (searchController.text.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              searchController.clear();
                            },
                            child: Text("عرض جميع المحلات"),
                          ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredShops.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final shop = filteredShops[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.blue[50]!,
                                Colors.white,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.blue[100]!,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue[800],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.store,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            title: Text(
                              shop["name"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Text(
                                  shop["type"],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      shop["rating"].toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      shop["distance"],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue[800],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ShopDetailsScreen(shop: shop),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // 🔔 رسالة ترحيبية
      floatingActionButton: searchController.text.isEmpty
          ? FloatingActionButton.extended(
              onPressed: () {},
              icon: Icon(Icons.info_outline),
              label: Text("المحلات القريبة منك"),
              backgroundColor: Colors.blue[700],
            )
          : null,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
