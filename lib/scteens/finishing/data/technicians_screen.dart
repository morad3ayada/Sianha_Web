import 'package:flutter/material.dart';
import '/scteens/models/technician_model.dart';
import 'technicians_data.dart';

class TechniciansScreen extends StatelessWidget {
  final District district;

  const TechniciansScreen({Key? key, required this.district}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // فلترة الفنيين حسب المنطقة
    final technicians = TechniciansData.technicians
        .where((tech) =>
            tech.district == district.name &&
            tech.governorate == district.governorate)
        .toList();

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('فنيين ${district.name}'),
        backgroundColor: _getGovernorateColor(district.governorate),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeaderSection(technicians),
          Expanded(child: _buildTechniciansList(technicians)),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(List<Technician> technicians) {
    final availableCount =
        technicians.where((tech) => tech.status == 'متاح').length;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            _getGovernorateColor(district.governorate),
            _getGovernorateColor(district.governorate).withOpacity(0.7)
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
                child: Icon(Icons.engineering, color: Colors.white, size: 30),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'فنيين ${district.name}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$availableCount فني متاح من أصل ${technicians.length}',
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

  Widget _buildTechniciansList(List<Technician> technicians) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: technicians.length,
        itemBuilder: (context, index) {
          return _buildTechnicianCard(technicians[index]);
        },
      ),
    );
  }

  Widget _buildTechnicianCard(Technician technician) {
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
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                // صورة الفني
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getSpecialtyColor(technician.specialty)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getSpecialtyIcon(technician.specialty),
                    color: _getSpecialtyColor(technician.specialty),
                    size: 30,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        technician.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        technician.specialty,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: technician.status == 'متاح'
                        ? Colors.green.withOpacity(0.1)
                        : technician.status == 'مشغول'
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: technician.status == 'متاح'
                          ? Colors.green
                          : technician.status == 'مشغول'
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                  child: Text(
                    technician.status,
                    style: TextStyle(
                      color: technician.status == 'متاح'
                          ? Colors.green
                          : technician.status == 'مشغول'
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
            // المعلومات التفصيلية
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTechInfoItem('التقييم', '${technician.rating}',
                    Icons.star, Colors.amber),
                _buildTechInfoItem('المشاريع', '${technician.activeProjects}',
                    Icons.assignment, Colors.blue),
                _buildTechInfoItem('الخبرة', '${technician.experience} سنة',
                    Icons.work, Colors.green),
              ],
            ),
            SizedBox(height: 16),
            // المهارات
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: technician.skills.take(3).map((skill) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            // زر التواصل
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // إجراء الاتصال
                },
                icon: Icon(Icons.phone, size: 18),
                label: Text('اتصل: ${technician.phone}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getGovernorateColor(district.governorate),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechInfoItem(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
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

  Color _getSpecialtyColor(String specialty) {
    Map<String, Color> colors = {
      'سباك': Colors.blue,
      'كهرباء': Colors.orange,
      'دهان': Colors.green,
      'نجار': Colors.brown,
      'جبس': Colors.cyan,
      'سيراميك': Colors.purple,
    };
    return colors[specialty] ?? Colors.grey;
  }

  IconData _getSpecialtyIcon(String specialty) {
    Map<String, IconData> icons = {
      'سباك': Icons.plumbing,
      'كهرباء': Icons.electrical_services,
      'دهان': Icons.format_paint,
      'نجار': Icons.construction,
      'جبس': Icons.account_balance,
      'سيراميك': Icons.square_foot,
    };
    return icons[specialty] ?? Icons.person;
  }
}
