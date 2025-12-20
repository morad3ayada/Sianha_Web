import 'package:flutter/material.dart';
import '../../models/technician_model.dart';
import 'technicians_data.dart';

class TeamFormationScreen extends StatefulWidget {
  @override
  _TeamFormationScreenState createState() => _TeamFormationScreenState();
}

class _TeamFormationScreenState extends State<TeamFormationScreen> {
  String? selectedGovernorate;
  String? selectedDistrict;
  List<String> requiredSpecialties = [];

  final List<String> allSpecialties = [
    'سباك',
    'كهرباء',
    'دهان',
    'نجار',
    'جبس',
    'سيراميك',
    'ألومنيوم'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('تكوين فريق'),
        backgroundColor: Color(0xFF2D5A78),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoCard(),
            SizedBox(height: 20),
            _buildLocationSection(),
            SizedBox(height: 20),
            _buildSpecialtiesSection(),
            SizedBox(height: 30),
            _buildFormationButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF2D5A78), Color(0xFF1E3A5C)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.group_work, color: Colors.white, size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تكوين فريق متكامل',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'اختر الموقع والتخصصات المطلوبة لتكوين الفريق',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الموقع',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
          SizedBox(height: 16),
          // اختيار المحافظة
          DropdownButtonFormField<String>(
            value: selectedGovernorate,
            decoration: InputDecoration(
              labelText: 'اختر المحافظة',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: TechniciansData.governorates.map((gov) {
              return DropdownMenuItem(
                value: gov.name,
                child: Text(gov.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedGovernorate = value;
                selectedDistrict = null;
              });
            },
          ),
          SizedBox(height: 16),
          // اختيار المنطقة
          DropdownButtonFormField<String>(
            value: selectedDistrict,
            decoration: InputDecoration(
              labelText: 'اختر المنطقة',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: _getAvailableDistricts().map((district) {
              return DropdownMenuItem(
                value: district.name,
                child: Text(district.name),
              );
            }).toList(),
            onChanged: selectedGovernorate != null
                ? (value) {
                    setState(() {
                      selectedDistrict = value;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtiesSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التخصصات المطلوبة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'اختر التخصصات اللازمة للمشروع',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: allSpecialties.map((specialty) {
              final isSelected = requiredSpecialties.contains(specialty);
              return FilterChip(
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      requiredSpecialties.add(specialty);
                    } else {
                      requiredSpecialties.remove(specialty);
                    }
                  });
                },
                label: Text(specialty),
                selectedColor: Colors.blue.withOpacity(0.2),
                checkmarkColor: Colors.blue,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormationButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _formTeam,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2D5A78),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
        ),
        child: Text(
          'تكوين الفريق',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<District> _getAvailableDistricts() {
    if (selectedGovernorate == null) return [];
    return TechniciansData.districts
        .where((district) => district.governorate == selectedGovernorate)
        .toList();
  }

  void _formTeam() {
    if (selectedGovernorate == null ||
        selectedDistrict == null ||
        requiredSpecialties.isEmpty) {
      _showErrorDialog('يرجى اختيار الموقع والتخصصات المطلوبة');
      return;
    }

    // البحث عن فنيين متاحين
    final availableTechnicians = TechniciansData.technicians.where((tech) {
      return tech.governorate == selectedGovernorate &&
          tech.district == selectedDistrict &&
          tech.status == 'متاح' &&
          requiredSpecialties.contains(tech.specialty);
    }).toList();

    // التحقق من توفر جميع التخصصات
    final missingSpecialties = requiredSpecialties.where((specialty) {
      return !availableTechnicians.any((tech) => tech.specialty == specialty);
    }).toList();

    if (missingSpecialties.isNotEmpty) {
      _showMissingSpecialtiesDialog(missingSpecialties);
    } else {
      _showTeamReadyDialog(availableTechnicians);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('خطأ'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showMissingSpecialtiesDialog(List<String> missingSpecialties) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('تخصصات ناقصة'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('التخصصات التالية غير متاحة حالياً:'),
            SizedBox(height: 12),
            ...missingSpecialties.map((specialty) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text('• $specialty'),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showTeamReadyDialog(List<Technician> technicians) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('الفريق جاهز'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تم تكوين فريق متكامل مكون من:'),
            SizedBox(height: 12),
            ...technicians.map((tech) => ListTile(
                  leading: Icon(_getSpecialtyIcon(tech.specialty),
                      color: _getSpecialtyColor(tech.specialty)),
                  title: Text(tech.name),
                  subtitle: Text(tech.specialty),
                  trailing: Text('${tech.rating} ⭐'),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // الانتقال لشاشة تأكيد الفريق
            },
            child: Text('تأكيد الفريق'),
          ),
        ],
      ),
    );
  }

  Color _getSpecialtyColor(String specialty) {
    Map<String, Color> colors = {
      'سباك': Colors.blue,
      'كهرباء': Colors.orange,
      'دهان': Colors.green,
      'نجار': Colors.brown,
    };
    return colors[specialty] ?? Colors.grey;
  }

  IconData _getSpecialtyIcon(String specialty) {
    Map<String, IconData> icons = {
      'سباك': Icons.plumbing,
      'كهرباء': Icons.electrical_services,
      'دهان': Icons.format_paint,
      'نجار': Icons.construction,
    };
    return icons[specialty] ?? Icons.person;
  }
}
