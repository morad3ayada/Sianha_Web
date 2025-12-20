import 'package:flutter/material.dart';

class ProjectTrackingScreen extends StatelessWidget {
  final Map<String, dynamic> projectData;

  ProjectTrackingScreen({Key? key, required this.projectData})
      : super(key: key);

  // تعريف timelineSteps كمتغير داخل الكلاس
  final List<Map<String, dynamic>> timelineSteps = [
    {
      'title': 'انتظار الموافقة',
      'date': '01/10/2024',
      'completed': true,
      'icon': Icons.pending_actions,
      'color': Colors.grey,
    },
    {
      'title': 'تم الموافقة',
      'date': '05/10/2024',
      'completed': true,
      'icon': Icons.thumb_up,
      'color': Colors.green,
    },
    {
      'title': 'تفاصيل التشطيب',
      'date': '05/10/2024',
      'completed': true,
      'icon': Icons.construction,
      'color': Colors.green,
    },
    {
      'title': 'تجميع الفريق',
      'date': '07/10/2024',
      'completed': true,
      'icon': Icons.group,
      'color': Colors.green,
    },
    {
      'title': 'تم الدهان',
      'date': '10-17/10/2024',
      'completed': true,
      'icon': Icons.format_paint,
      'color': Colors.green,
    },
    {
      'title': 'تم دفع العربون',
      'date': '18/10/2024',
      'completed': true,
      'icon': Icons.payment,
      'color': Colors.green,
    },
    {
      'title': 'إنجاز 50% من التشطيب',
      'date': '25/10/2024',
      'completed': true,
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
    {
      'title': 'تم دفع 25% من المبلغ',
      'date': '26/10/2024',
      'completed': true,
      'icon': Icons.attach_money,
      'color': Colors.green,
    },
    {
      'title': 'انتهاء التشطيب',
      'date': '05/11/2024',
      'completed': true,
      'icon': Icons.done_all,
      'color': Colors.green,
    },
    {
      'title': 'مراجعة التشطيب مع العميل',
      'date': '06/11/2024',
      'completed': true,
      'icon': Icons.supervisor_account,
      'color': Colors.green,
    },
    {
      'title': 'تم الاستلام',
      'date': '07/11/2024',
      'completed': true,
      'icon': Icons.inventory_2,
      'color': Colors.green,
    },
    {
      'title': 'دفع المبلغ كامل',
      'date': '08/11/2024',
      'completed': false,
      'icon': Icons.account_balance_wallet,
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // شريط العنوان
            _buildAppBar(context),
            // محتوى الشاشة
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // بطاقة معلومات المشروع
                    _buildProjectInfoCard(),
                    // شريط التقدم
                    _buildProgressCard(),
                    // خط زمني للمراحل
                    _buildTimeline(),
                    // تفاصيل المشروع
                    _buildProjectDetails(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF2D5A78), Color(0xFF1E3A5C)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  projectData['projectName'] ?? 'تتبع المشروع',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  projectData['id'] ?? 'كود المشروع',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProjectInfoCard() {
    return Container(
      margin: EdgeInsets.all(16),
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
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF2D5A78).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    Icon(Icons.assignment, color: Color(0xFF2D5A78), size: 30),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      projectData['projectName'] ?? 'مشروع تشطيب',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A5C),
                      ),
                    ),
                    Text(
                      projectData['id'] ?? 'كود المشروع',
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
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  'نشط',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(
                  'المبلغ الكلي',
                  '${projectData['totalAmount'] ?? 0} ريال',
                  Icons.attach_money),
              _buildInfoItem('المبلغ المدفوع',
                  '${projectData['paidAmount'] ?? 0} ريال', Icons.payment),
              _buildInfoItem(
                  'المتبقي',
                  '${(projectData['totalAmount'] ?? 0) - (projectData['paidAmount'] ?? 0)} ريال',
                  Icons.money_off),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF2D5A78).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF2D5A78), size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A5C),
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

  Widget _buildProgressCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تقدم المشروع',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5C),
                ),
              ),
              Text(
                '${projectData['progress'] ?? 0}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D5A78),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: (projectData['progress'] ?? 0) / 100,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D5A78)),
            minHeight: 12,
            borderRadius: BorderRadius.circular(10),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                projectData['startDate'] ?? 'بداية المشروع',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                projectData['endDate'] ?? 'نهاية المشروع',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      margin: EdgeInsets.all(16),
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
            'خط سير المشروع',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A5C),
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: timelineSteps.length,
            itemBuilder: (context, index) {
              final step = timelineSteps[index];
              return _buildTimelineStep(step, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(Map<String, dynamic> step, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الخط العمودي
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: step['completed'] ? step['color'] : Colors.grey[300],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: step['completed'] ? step['color'] : Colors.grey,
                    width: 2,
                  ),
                ),
                child: step['completed']
                    ? Icon(Icons.check, color: Colors.white, size: 16)
                    : SizedBox(),
              ),
              if (index < timelineSteps.length - 1)
                Container(
                  width: 2,
                  height: 40,
                  color: step['completed'] ? step['color'] : Colors.grey[300],
                ),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: step['completed']
                    ? step['color'].withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: step['completed'] ? step['color'] : Colors.grey[300],
                ),
              ),
              child: Row(
                children: [
                  Icon(step['icon'],
                      color: step['completed'] ? step['color'] : Colors.grey),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                step['completed'] ? step['color'] : Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          step['date'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectDetails() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
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
            'تفاصيل المشروع',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A5C),
            ),
          ),
          SizedBox(height: 16),
          _buildDetailItem('اسم العميل',
              projectData['clientName'] ?? 'غير محدد', Icons.person),
          _buildDetailItem(
              'اسم الفريق', projectData['teamName'] ?? 'غير محدد', Icons.group),
          _buildDetailItem('المحافظة', projectData['governorate'] ?? 'غير محدد',
              Icons.location_city),
          _buildDetailItem(
              'المنطقة', projectData['district'] ?? 'غير محدد', Icons.place),
          _buildDetailItem('تاريخ البدء',
              projectData['startDate'] ?? 'غير محدد', Icons.calendar_today),
          _buildDetailItem('تاريخ الانتهاء',
              projectData['endDate'] ?? 'غير محدد', Icons.event_available),
          _buildDetailItem('الأيام المتبقية',
              '${projectData['remainingDays'] ?? 0} يوم', Icons.schedule),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xff362e2e)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF2D5A78).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(0xFF2D5A78), size: 18),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E3A5C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
