import 'package:flutter/material.dart';

class CompletedProjectsScreen extends StatelessWidget {
  // بيانات المشاريع المنتهية
  final List<Map<String, dynamic>> completedProjects = [
    {
      'id': 'PRJ-2024-001',
      'projectName': 'تشطيب فيلا فاخرة - حي النخيل',
      'clientName': 'أحمد محمد',
      'teamName': 'فريق التشطيب المتميز',
      'completionDate': '2024-11-15',
      'daysAgo': 5,
      'totalAmount': 75000,
      'clientRating': 4.8,
      'duration': '45 يوم',
      'specialties': ['سباك', 'كهرباء', 'دهان', 'نجار'],
      'address': 'حي النخيل - شارع الملك فهد',
      'supervisor': 'محمود عبدالله',
    },
    {
      'id': 'PRJ-2024-002',
      'projectName': 'تشطيب شقة سكنية - حي الصفا',
      'clientName': 'سارة عبدالله',
      'teamName': 'فريق التشطيب السريع',
      'completionDate': '2024-11-10',
      'daysAgo': 10,
      'totalAmount': 45000,
      'clientRating': 4.5,
      'duration': '30 يوم',
      'specialties': ['دهان', 'نجار', 'سيراميك'],
      'address': 'حي الصفا - شارع الأمير سلطان',
      'supervisor': 'خالد الحربي',
    },
    {
      'id': 'PRJ-2024-003',
      'projectName': 'تشطيب عمارة سكنية - حي الثقبة',
      'clientName': 'شركة الأمل العقارية',
      'teamName': 'فريق التشطيب المتكامل',
      'completionDate': '2024-11-05',
      'daysAgo': 15,
      'totalAmount': 120000,
      'clientRating': 4.9,
      'duration': '60 يوم',
      'specialties': ['سباك', 'كهرباء', 'دهان', 'نجار', 'سيراميك', 'جبس'],
      'address': 'حي الثقبة - شارع الخليج',
      'supervisor': 'فارس العتيبي',
    },
    {
      'id': 'PRJ-2024-004',
      'projectName': 'تشطيب مطعم - حي الزاهر',
      'clientName': 'مطعم الأصالة',
      'teamName': 'فريق التشطيب الفاخر',
      'completionDate': '2024-10-28',
      'daysAgo': 22,
      'totalAmount': 95000,
      'clientRating': 4.7,
      'duration': '40 يوم',
      'specialties': ['كهرباء', 'دهان', 'نجار', 'ألومنيوم'],
      'address': 'حي الزاهر - شارع التحلية',
      'supervisor': 'ياسر القحطاني',
    },
    {
      'id': 'PRJ-2024-005',
      'projectName': 'تشطيب عيادة طبية - حي العليا',
      'clientName': 'د. محمد الشهري',
      'teamName': 'فريق التشطيب الطبي',
      'completionDate': '2024-10-20',
      'daysAgo': 30,
      'totalAmount': 68000,
      'clientRating': 4.6,
      'duration': '35 يوم',
      'specialties': ['كهرباء', 'سباك', 'دهان', 'جبس'],
      'address': 'حي العليا - شارع العروبة',
      'supervisor': 'نواف المطيري',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('المشاريع المنتهية'),
        backgroundColor: Colors.teal,
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
          colors: [Colors.teal[700]!, Colors.teal[500]!],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المشاريع المكتملة',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${completedProjects.length} مشروع منتهي',
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
                child: Icon(Icons.verified, color: Colors.white, size: 30),
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
                _buildStatItem('معدل التقييم', '4.7/5', Icons.star),
                _buildStatItem(
                    'إجمالي القيمة', '403,000 ريال', Icons.attach_money),
                _buildStatItem('متوسط المدة', '42 يوم', Icons.schedule),
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
        itemCount: completedProjects.length,
        itemBuilder: (context, index) {
          return _buildProjectCard(completedProjects[index]);
        },
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
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
              color: Colors.teal.withOpacity(0.05),
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
                    color: Colors.teal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.architecture, color: Colors.teal, size: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['projectName'],
                        style: TextStyle(
                          fontSize: 16,
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
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.teal),
                  ),
                  child: Text(
                    'مكتمل',
                    style: TextStyle(
                      color: Colors.teal,
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
                // المعلومات الأساسية
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
                      child: _buildProjectInfoItem('المشرف',
                          project['supervisor'], Icons.supervisor_account),
                    ),
                    Expanded(
                      child: _buildProjectInfoItem(
                          'المدة', project['duration'], Icons.schedule),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // التخصصات
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التخصصات:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: project['specialties'].map<Widget>((specialty) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.teal.withOpacity(0.3)),
                          ),
                          child: Text(
                            specialty,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // التقييم والسعر
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // التقييم
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تقييم العميل',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            _buildRatingStars(project['clientRating']),
                            SizedBox(width: 8),
                            Text(
                              '${project['clientRating']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[800],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // السعر
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'القيمة الإجمالية',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${project['totalAmount']} ريال',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // العنوان وتاريخ الإنهاء
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'العنوان',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            project['address'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey[700],
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'تم الإنتهاء',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'منذ ${project['daysAgo']} يوم',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
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
            Icon(icon, size: 14, color: Colors.teal),
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

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }
}
