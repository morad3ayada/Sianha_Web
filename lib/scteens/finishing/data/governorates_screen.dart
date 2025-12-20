import 'package:flutter/material.dart';
import '/scteens/models/technician_model.dart';
import 'technicians_data.dart';
import 'districts_screen.dart';

class GovernoratesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('المحافظات'),
        backgroundColor: Color(0xFF2D5A78),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildHeaderSection(),
          Expanded(child: _buildGovernoratesList()),
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
          colors: [Color(0xFF2D5A78), Color(0xFF1E3A5C)],
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
                child: Icon(Icons.map, color: Colors.white, size: 30),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المحافظات',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'اختر المحافظة لعرض المناطق والفنيين',
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
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                    'المحافظات',
                    '${TechniciansData.governorates.length}',
                    Icons.location_city),
                _buildStatItem('فنيين متاحين', '130', Icons.engineering),
                _buildStatItem('تخصصات', '12', Icons.build),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildGovernoratesList() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: TechniciansData.governorates.length,
        itemBuilder: (context, index) {
          return _buildGovernorateCard(
              TechniciansData.governorates[index], context);
        },
      ),
    );
  }

  Widget _buildGovernorateCard(Governorate governorate, BuildContext context) {
    double availabilityRate = governorate.availableTechnicians /
        (governorate.availableTechnicians + governorate.busyTechnicians);

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
            _navigateToDistricts(context, governorate);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getGovernorateColor(governorate.name)
                            .withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.location_city,
                          color: _getGovernorateColor(governorate.name),
                          size: 24),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            governorate.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${governorate.availableTechnicians} فني متاح - ${governorate.busyTechnicians} مشغول',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: availabilityRate > 0.7
                            ? Colors.green.withOpacity(0.1)
                            : availabilityRate > 0.4
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: availabilityRate > 0.7
                              ? Colors.green
                              : availabilityRate > 0.4
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                      child: Text(
                        '${(availabilityRate * 100).toInt()}%',
                        style: TextStyle(
                          color: availabilityRate > 0.7
                              ? Colors.green
                              : availabilityRate > 0.4
                                  ? Colors.orange
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // شريط التقدم
                LinearProgressIndicator(
                  value: availabilityRate,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    availabilityRate > 0.7
                        ? Colors.green
                        : availabilityRate > 0.4
                            ? Colors.orange
                            : Colors.red,
                  ),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(10),
                ),
                SizedBox(height: 12),
                // التخصصات المتاحة
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      governorate.availableSpecialties.take(4).map((specialty) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
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
                if (governorate.availableSpecialties.length > 4)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '+ ${governorate.availableSpecialties.length - 4} تخصصات أخرى',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
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

  void _navigateToDistricts(BuildContext context, Governorate governorate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DistrictsScreen(governorate: governorate),
      ),
    );
  }
}
