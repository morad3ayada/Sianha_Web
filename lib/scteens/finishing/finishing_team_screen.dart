import 'package:flutter/material.dart';
import 'teams_screen.dart';
import 'active_projects_screen.dart';
import 'completed_projects_screen.dart';
import 'data/governorates_screen.dart';

class FinishingTeamScreen extends StatelessWidget {
  final List<Map<String, dynamic>> teamCards = [
    {
      'title': 'فرق التشطيب',
      'value': '5',
      'icon': Icons.construction,
      'color': Colors.orange,
      'screen': TeamsScreen(),
    },
    {
      'title': 'مشاريع نشطة',
      'value': '12',
      'icon': Icons.assignment_outlined,
      'color': Colors.blue,
      'screen': ActiveProjectsScreen(),
    },
    {
      'title': 'مشاريع منتهية',
      'value': '28',
      'icon': Icons.check_circle_outline,
      'color': Colors.teal,
      'screen': CompletedProjectsScreen(),
    },
    {
      'title': 'فنيين تشطيب',
      'value': '15',
      'icon': Icons.engineering_outlined,
      'color': Colors.purple,
      'screen': GovernoratesScreen(),
    },
  ];

  FinishingTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط العنوان - مخفف للتركيز على البطاقات
            _buildMinimalAppBar(screenWidth),

            SizedBox(height: screenHeight * 0.02),

            // 2. عنوان النظرة العامة - بحجم أصغر
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "نظرة عامة",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.015),

            // 3. بطاقات الإحصائيات - مساحة أكبر وتصميم محسن
            Expanded(
              flex: 4, // زيادة المساحة للبطاقات
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.02,
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: screenHeight * 0.02,
                    crossAxisSpacing: screenWidth * 0.03,
                    childAspectRatio: 1.1, // نسبة مربعة أكثر
                  ),
                  itemCount: teamCards.length,
                  itemBuilder: (context, index) {
                    return _buildEnhancedTeamCard(
                      teamCards[index],
                      context,
                      screenWidth,
                      screenHeight,
                    );
                  },
                ),
              ),
            ),

            // 4. قسم المشاريع - بحجم أصغر لإعطاء مساحة أكبر للبطاقات
            Expanded(
              flex: 2,
              child: _buildCompactProjectsSection(screenWidth, screenHeight),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildEnhancedFloatingActionButton(),
    );
  }

  Widget _buildMinimalAppBar(double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenWidth * 0.03,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'لوحة التحكم',
                style: TextStyle(
                  fontSize: screenWidth * 0.032,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 2),
              Text(
                'فريق التشطيب',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
              ),
            ],
          ),
          Container(
            width: screenWidth * 0.1,
            height: screenWidth * 0.1,
            decoration: BoxDecoration(
              color: Colors.orange[50],
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.orange.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.person,
              color: Colors.orange[700],
              size: screenWidth * 0.05,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTeamCard(
    Map<String, dynamic> data,
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToScreen(data['screen'] as Widget, context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // خلفية متدرجة
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (data['color'] as Color).withOpacity(0.05),
                      Colors.white,
                    ],
                  ),
                ),
              ),

              // الزخرفة الدائرية
              Positioned(
                top: -screenWidth * 0.05,
                right: -screenWidth * 0.05,
                child: Container(
                  width: screenWidth * 0.25,
                  height: screenWidth * 0.25,
                  decoration: BoxDecoration(
                    color: (data['color'] as Color).withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // محتوى البطاقة
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // الصف العلوي: الأيقونة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(screenWidth * 0.025),
                          decoration: BoxDecoration(
                            color: (data['color'] as Color).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            data['icon'] as IconData,
                            color: data['color'] as Color,
                            size: screenWidth * 0.08,
                          ),
                        ),
                        // مؤشر الحالة
                        Container(
                          width: screenWidth * 0.025,
                          height: screenWidth * 0.025,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // الصف الأوسط: القيمة
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            data['value'] as String,
                            style: TextStyle(
                              fontSize: screenWidth * 0.1,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[900],
                              height: 0.9,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // الصف السفلي: العنوان
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenWidth * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: (data['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        data['title'] as String,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                          color: (data['color'] as Color),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactProjectsSection(double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.01,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenWidth * 0.05),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المشاريع الحالية',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: screenWidth * 0.04,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.015),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.assignment,
                    color: Colors.orange,
                    size: screenWidth * 0.06,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'بدون مشاريع نشطة',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'أضف مشروع جديد',
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.orange,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange[400]!, Colors.orange[700]!],
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  void _navigateToScreen(Widget screen, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
