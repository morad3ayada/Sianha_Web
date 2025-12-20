import 'package:flutter/material.dart';

class SolvedComplaintsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الشكاوى المحلولة"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(icon: Icon(Icons.print), onPressed: () {}),
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ملخص الحل
            _buildSolutionSummary(),
            SizedBox(height: 20),
            
            // فريق العمل
            _buildSectionTitle("فريق العمل"),
            _buildTeamMember("المشرف المسؤول:", "أحمد محمد", "مشرف عام"),
            _buildTeamMember("الفني المنفذ:", "خالد محمود", "فني مختص"),
            _buildTeamMember("مساعد الفني:", "محمود السيد", "فني مساعد"),
            SizedBox(height: 16),
            
            // التاجر والمندوب
            _buildSectionTitle("الموردين"),
            _buildTeamMember("التاجر:", "شركة التقنية المتطورة", "مورد معتمد"),
            _buildTeamMember("المندوب:", "علي حسن", "مندوب مبيعات"),
            SizedBox(height: 16),
            
            // معلومات العميل
            _buildSectionTitle("العميل"),
            _buildTeamMember("اسم العميل:", "سعيد عبدالله", "عميل نهائي"),
            _buildTeamMember("رقم الهاتف:", "+20123456789", "الاتصال"),
            _buildTeamMember("المحافظة:", "القاهرة", "الموقع"),
            _buildTeamMember("المركز:", "وسط البلد", "المنطقة"),
            SizedBox(height: 16),
            
            // التكلفة والوقت
            _buildSectionTitle("التكلفة والوقت"),
            _buildMetricCard("التكلفة الإجمالية", "1,250 جنيه", Icons.attach_money),
            _buildMetricCard("الوقت المستغرق", "3 أيام", Icons.access_time),
            _buildMetricCard("قطع الغيار", "5 قطع", Icons.build),
            SizedBox(height: 20),
            
            // تقييم الخدمة
            _buildSectionTitle("تقييم الخدمة"),
            _buildRatingSection(),
            SizedBox(height: 20),
            
            // ختم النظام
            _buildSystemStamp(),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionSummary() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 24),
                SizedBox(width: 8),
                Text("تم حل الشكوى بنجاح", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
              ],
            ),
            SizedBox(height: 12),
            _buildInfoRow("رقم الشكوى:", "COM-2024-001"),
            _buildInfoRow("نوع المشكلة:", "فنية - عطل كهربائي"),
            _buildInfoRow("الحل النهائي:", "تم استبدال المحول الرئيسي وتحديث البرنامج"),
            _buildInfoRow("تاريخ الإغلاق:", "2024-01-18 14:30"),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildTeamMember(String role, String name, String position) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Icon(Icons.person, color: Colors.blue[800]),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(position, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          Icon(Icons.phone, color: Colors.green, size: 20),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 120,
            child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
          ),
          Expanded(child: Text(value, style: TextStyle(color: Colors.grey[600]))),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: Colors.green, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text("تقييم العميل", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  Icon(Icons.star_half, color: Colors.amber, size: 20),
                ],
              ),
              Text("4.5/5", style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text("تقييم الإدارة", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.blue, size: 20),
                  Icon(Icons.star, color: Colors.blue, size: 20),
                  Icon(Icons.star, color: Colors.blue, size: 20),
                  Icon(Icons.star, color: Colors.blue, size: 20),
                  Icon(Icons.star, color: Colors.blue, size: 20),
                ],
              ),
              Text("5/5", style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSystemStamp() {
    return Card(
      color: Colors.grey[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.verified_user, color: Colors.green, size: 40),
            SizedBox(height: 8),
            Text("معتمدة من نظام إدارة الشكاوى", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            Text("رقم المرجع: CMS-2024-001", style: TextStyle(color: Colors.grey[600])),
            Text("آخر تحديث: 2024-01-18", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
      ),
    );
  }
}