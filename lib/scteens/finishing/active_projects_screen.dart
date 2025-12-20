import 'package:flutter/material.dart';
import 'project_tracking_screen.dart';

class ActiveProjectsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> activeProjects = [
    {
      'id': 'PRJ-2024-001',
      'projectName': 'تشطيب فيلا فاخرة',
      'clientName': 'أحمد محمد',
      'teamName': 'فريق التشطيب المتميز',
      'governorate': 'محافظة الرياض',
      'district': 'حي النخيل',
      'progress': 85,
      'remainingDays': 15,
      'startDate': '2024-10-01',
      'endDate': '2024-11-15',
      'totalAmount': 75000,
      'paidAmount': 50000,
    },
    {
      'id': 'PRJ-2024-002',
      'projectName': 'تشطيب شقة سكنية',
      'clientName': 'سارة عبدالله',
      'teamName': 'فريق التشطيب السريع',
      'governorate': 'محافظة جدة',
      'district': 'حي الصفا',
      'progress': 60,
      'remainingDays': 30,
      'startDate': '2024-10-10',
      'endDate': '2024-12-10',
      'totalAmount': 45000,
      'paidAmount': 25000,
    },
    {
      'id': 'PRJ-2024-003',
      'projectName': 'تشطيب عمارة سكنية',
      'clientName': 'خالد الحربي',
      'teamName': 'فريق التشطيب المتكامل',
      'governorate': 'محافظة الدمام',
      'district': 'حي الثقبة',
      'progress': 45,
      'remainingDays': 45,
      'startDate': '2024-09-15',
      'endDate': '2024-12-30',
      'totalAmount': 120000,
      'paidAmount': 60000,
    },
    {
      'id': 'PRJ-2024-004',
      'projectName': 'تشطيب مكتب تجاري',
      'clientName': 'شركة التقنية المحدودة',
      'teamName': 'فريق التشطيب التجاري',
      'governorate': 'محافظة الرياض',
      'district': 'حي العليا',
      'progress': 75,
      'remainingDays': 20,
      'startDate': '2024-10-05',
      'endDate': '2024-11-25',
      'totalAmount': 85000,
      'paidAmount': 55000,
    },
    {
      'id': 'PRJ-2024-005',
      'projectName': 'تشطيب مطعم',
      'clientName': 'مطعم الأصالة',
      'teamName': 'فريق التشطيب الفاخر',
      'governorate': 'محافظة مكة',
      'district': 'حي الزاهر',
      'progress': 30,
      'remainingDays': 60,
      'startDate': '2024-10-20',
      'endDate': '2024-12-20',
      'totalAmount': 95000,
      'paidAmount': 30000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('المشاريع النشطة'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // رأس الصفحة
          _buildHeaderSection(),
          // قائمة المشاريع
          Expanded(
            child: _buildProjectsList(),
          ),
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
          colors: [Colors.blue[700]!, Colors.blue[500]!],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المشاريع النشطة',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${activeProjects.length} مشروع قيد التنفيذ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.assignment, color: Colors.white, size: 30),
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
                _buildStatItem('مكتمل', '85%', Icons.check_circle),
                _buildStatItem('قيد العمل', '12', Icons.build),
                _buildStatItem('متبقي', '30 يوم', Icons.schedule),
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

  Widget _buildProjectsList() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: activeProjects.length,
        itemBuilder: (context, index) {
          return _buildProjectCard(activeProjects[index], context);
        },
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project, BuildContext context) {
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
      child: Column(
        children: [
          // رأس البطاقة
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.architecture, color: Colors.blue, size: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['projectName'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        project['id'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    'نشط',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // محتوى البطاقة
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // معلومات المشروع
                Row(
                  children: [
                    Expanded(
                      child: _buildProjectInfoItem(
                          'العميل', project['clientName'], Icons.person),
                    ),
                    Expanded(
                      child: _buildProjectInfoItem(
                          'الفريق', project['teamName'], Icons.group),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildProjectInfoItem('المحافظة',
                          project['governorate'], Icons.location_city),
                    ),
                    Expanded(
                      child: _buildProjectInfoItem(
                          'المنطقة', project['district'], Icons.place),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // شريط التقدم
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تقدم المشروع',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        Text(
                          '${project['progress']}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: project['progress'] / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // المبالغ والأيام
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAmountItem(
                        'المبلغ الكلي', '${project['totalAmount']} ريال'),
                    _buildAmountItem(
                        'المبلغ المدفوع', '${project['paidAmount']} ريال'),
                    _buildAmountItem(
                        'الأيام المتبقية', '${project['remainingDays']} يوم'),
                  ],
                ),
              ],
            ),
          ),

          // زر التتبع
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _navigateToProjectTracking(context, project);
                },
                icon: Icon(Icons.track_changes, size: 20),
                label: Text(
                  'تتبع المشروع',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectInfoItem(String title, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.blueGrey[600]),
            SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
          ),
        ),
      ],
    );
  }

  void _navigateToProjectTracking(
      BuildContext context, Map<String, dynamic> project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectTrackingScreen(projectData: project),
      ),
    );
  }
}
