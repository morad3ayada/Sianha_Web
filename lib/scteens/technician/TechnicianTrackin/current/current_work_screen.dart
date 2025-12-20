import 'package:flutter/material.dart';
import 'OrderTrackingScreen.dart'; // تأكد من استيراد الملف الصحيح

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filter Technicians App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade800,
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
  final String name;
  final String governorate;
  final String center;
  final String category;

  Technician({
    required this.name,
    required this.governorate,
    required this.center,
    required this.category,
  });

  // دالة لتحويل الكائن إلى Map
  Map<String, dynamic> toMap() {
    return {
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
      'phone': '01234567890',
      'address': '$governorate - $center',
      'reviews': 25,
      'isOnline': true,
    };
  }
}

final Map<String, Map<String, List<String>>> data = {
  'القاهرة': {
    'وسط البلد': ['كهرباء', 'سباكة', 'تكييف'],
    'المعادي': ['كهرباء', 'سباكة', 'نجارة'],
  },
  'الجيزة': {
    'الدقي': ['كهرباء', 'سباكة', 'تبريد'],
    'المهندسين': ['سباكة', 'تكييف', 'دهانات'],
  },
  'الإسكندرية': {
    'سموحة': ['كهرباء', 'سباكة'],
    'المعمورة': ['تبريد', 'نجارة'],
  },
};

final List<Technician> allTechs = [
  Technician(
      name: 'محمد أحمد',
      governorate: 'القاهرة',
      center: 'وسط البلد',
      category: 'كهرباء'),
  Technician(
      name: 'أحمد محمود',
      governorate: 'القاهرة',
      center: 'وسط البلد',
      category: 'سباكة'),
  Technician(
      name: 'علي خالد',
      governorate: 'القاهرة',
      center: 'المعادي',
      category: 'كهرباء'),
  Technician(
      name: 'محمود سعيد',
      governorate: 'الجيزة',
      center: 'الدقي',
      category: 'سباكة'),
  Technician(
      name: 'سعيد فوزي',
      governorate: 'الجيزة',
      center: 'المهندسين',
      category: 'تكييف'),
  Technician(
      name: 'خالد وليد',
      governorate: 'الإسكندرية',
      center: 'سموحة',
      category: 'كهرباء'),
  Technician(
      name: 'وليد عمرو',
      governorate: 'الإسكندرية',
      center: 'المعمورة',
      category: 'تبريد'),
  Technician(
      name: 'يوسف جمال',
      governorate: 'القاهرة',
      center: 'المعادي',
      category: 'نجارة'),
  Technician(
      name: 'عمرو حسين',
      governorate: 'الجيزة',
      center: 'الدقي',
      category: 'كهرباء'),
];

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? selectedGov;
  String? selectedCenter;
  String? selectedCategory;

  List<String> centers = [];
  List<String> categories = [];

  List<Technician> filteredTechs = [];

  @override
  void initState() {
    super.initState();
    filteredTechs = List.from(allTechs);
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'تصفير البحث',
            onPressed: resetFilters,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _buildDropdown(
              value: selectedGov,
              hint: "اختار المحافظة",
              items: data.keys.toList(),
              onChanged: (value) {
                setState(() {
                  selectedGov = value;
                  selectedCenter = null;
                  selectedCategory = null;

                  if (value != null) {
                    centers = data[value]!.keys.toList();
                  } else {
                    centers = [];
                  }

                  categories = [];
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

                    if (selectedGov != null && value != null) {
                      categories = data[selectedGov]![value]!;
                    } else {
                      categories = [];
                    }

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
        border: Border.all(color: Colors.blue.shade200, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
        isExpanded: true,
        underline: SizedBox(),
        icon: Icon(Icons.arrow_drop_down_circle_outlined,
            color: Colors.blue.shade800),
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
          backgroundColor: Colors.blue.shade100,
          child: Icon(Icons.person_pin_outlined,
              color: Colors.blue.shade800, size: 30),
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
            ],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios,
            size: 18, color: Colors.blue.shade800),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderTrackingScreen(
                orderId: DateTime.now().millisecondsSinceEpoch.toString(),
                technicianName: t.name,
                governorate: t.governorate,
                center: t.center,
                serviceType: t.category,
                technicianPhone: '01234567890', // يمكنك إضافة رقم هاتف حقيقي
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
              color: Colors.blue.shade800,
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
