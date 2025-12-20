import 'package:flutter/material.dart';
import 'modelstechnician.dart';
import 'technician_details_screen.dart';

class RejectedTechniciansScreen extends StatelessWidget {
  final List<Technician> rejectedTechnicians = [
    Technician(
        name: 'أحمد محمد علي',
        specialty: 'صيانة مكيفات',
        phone: '01012345678',
        status: 'مرفوض',
        rejectionReason: 'بيانات ناقصة'),
    Technician(
        name: 'محمد إبراهيم',
        specialty: 'فني تكييف',
        phone: '01123456789',
        status: 'مرفوض',
        rejectionReason: 'بيانات ناقصة'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الفنيين المرفوضين'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: rejectedTechnicians.length,
          itemBuilder: (context, index) {
            final tech = rejectedTechnicians[index];
            return _buildRejectedTechCard(context, tech);
          },
        ),
      ),
    );
  }

  Widget _buildRejectedTechCard(BuildContext context, Technician tech) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tech.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('التخصص: ${tech.specialty}'),
          Text('الهاتف: ${tech.phone}'),
          SizedBox(height: 8),
          Text('سبب الرفض: ${tech.rejectionReason}',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AccountRecoveryDetailsScreen(
                                technician: tech)));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  child: Text('عرض التفاصيل'),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
