import 'package:flutter/material.dart';
import '/scteens/models/technician_model.dart';
import 'technicians_data.dart';
import 'technicians_screen.dart';

class DistrictsScreen extends StatelessWidget {
  final Governorate governorate;

  const DistrictsScreen({Key? key, required this.governorate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // فلترة المناطق التابعة للمحافظة مع التحويل الصحيح للنوع
    final List<District> districts = TechniciansData.districts
        .where((district) => district.governorate == governorate.name)
        .toList()
        .cast<District>(); // إضافة cast للتأكد من النوع

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('مناطق ${governorate.name}'),
        backgroundColor: _getGovernorateColor(governorate.name),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeaderSection(),
          Expanded(child: _buildDistrictsList(districts)),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            _getGovernorateColor(governorate.name),
            _getGovernorateColor(governorate.name).withOpacity(0.7)
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.place, color: Colors.white, size: 30),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مناطق ${governorate.name}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'اختر المنطقة لعرض الفنيين المتاحين',
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
        ],
      ),
    );
  }

  Widget _buildDistrictsList(List<District> districts) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: districts.length,
        itemBuilder: (context, index) {
          return _buildDistrictCard(districts[index], context);
        },
      ),
    );
  }

  Widget _buildDistrictCard(District district, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _navigateToTechnicians(context, district);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        _getGovernorateColor(governorate.name).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.location_on,
                      color: _getGovernorateColor(governorate.name), size: 24),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        district.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${district.technicianCount} فني متاح',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: district.specialties.take(3).map((specialty) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.blue.withOpacity(0.3)),
                            ),
                            child: Text(
                              specialty,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: _getGovernorateColor(governorate.name), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getGovernorateColor(String governorate) {
    Map<String, Color> colors = {
      'القاهرة': Colors.blue,
      'الجيزة': Colors.green,
      'الإسكندرية': Colors.orange,
      'سوهاج': Colors.purple,
    };
    return colors[governorate] ?? Colors.grey;
  }

  void _navigateToTechnicians(BuildContext context, District district) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TechniciansScreen(district: district),
      ),
    );
  }
}
