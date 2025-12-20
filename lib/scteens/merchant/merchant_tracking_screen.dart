import 'package:flutter/material.dart';

import 'PreparingOrdersScreen.dart';

class MerchantTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Media Query عشان ناخد أبعاد الشاشة
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // ================== 1. الهيدر (ثابت) ==================
            Container(
              height: screenHeight * 0.12,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.blue[700]!, Colors.purple[700]!],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.menu, color: Colors.white, size: 24),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'نظام متابعة التاجر',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Merchant Tracking System',
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: screenWidth * 0.05,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.blue[700],
                      size: screenWidth * 0.05,
                    ),
                  ),
                ],
              ),
            ),

            // ================== 2. باقي الشاشة (قابل للسكرول) ==================
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // -------- البطاقات الإحصائية --------
                    Container(
                      height: screenHeight * 0.25,
                      padding: EdgeInsets.all(16),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics:
                            NeverScrollableScrollPhysics(), // عشان السكرول الرئيسي يشتغل
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.3,
                        children: [
                          _buildStatCard(
                            context,
                            title: 'قيد التجهيز',
                            value: '12',
                            subtitle: 'في الانتظار',
                            icon: Icons.timer,
                            color: Colors.orange,
                            screen: PreparingOrdersScreen(),
                          ),
                        ],
                      ),
                    ),

                    // -------- قسم الخريطة والإحصائيات السريعة --------
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // عنوان الخريطة
                          Container(
                            height: screenHeight * 0.05,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.map,
                                    color: Colors.blue[700],
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'خريطة النشاط والطلبات',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),

                          // --- الخريطة (تم تحديد طولها هنا لتجنب Overflow) ---
                          SizedBox(
                            height: screenHeight * 0.35, // طول مناسب للخريطة
                            width: double.infinity,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final containerHeight = constraints.maxHeight;
                                final containerWidth = constraints.maxWidth;

                                return Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  margin: EdgeInsets.only(bottom: 8),
                                  child: Container(
                                    width: containerWidth,
                                    height: containerHeight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.blue[50]!,
                                          Colors.blue[100]!,
                                        ],
                                      ),
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        // خلفية الخريطة
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    'https://images.unsplash.com/photo-1569336415962-a4bd9f69cd83?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
                                                  ),
                                                  fit: BoxFit.cover,
                                                  colorFilter: ColorFilter.mode(
                                                    Colors.blue[100]!
                                                        .withOpacity(0.6),
                                                    BlendMode.darken,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.map_outlined,
                                                      size:
                                                          containerWidth * 0.15,
                                                      color: Colors.blue[300],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'خريطة الطلبات النشطة',
                                                      style: TextStyle(
                                                        fontSize:
                                                            containerWidth *
                                                                0.04,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue[800],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // نقاط وهمية على الخريطة
                                        Positioned(
                                          top: containerHeight * 0.1,
                                          left: containerWidth * 0.2,
                                          child: _buildMapPoint(
                                              Colors.red, '12', containerWidth),
                                        ),
                                        Positioned(
                                          top: containerHeight * 0.3,
                                          right: containerWidth * 0.15,
                                          child: _buildMapPoint(Colors.orange,
                                              '8', containerWidth),
                                        ),
                                        Positioned(
                                          bottom: containerHeight * 0.2,
                                          left: containerWidth * 0.25,
                                          child: _buildMapPoint(Colors.green,
                                              '25', containerWidth),
                                        ),

                                        // زر التكبير
                                        Positioned(
                                          bottom: 12,
                                          right: 12,
                                          child: FloatingActionButton(
                                            onPressed: () {
                                              _showMapDetails(context);
                                            },
                                            mini: true,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.zoom_in_map,
                                              color: Colors.blue[700],
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // -------- بطاقة الإحصائيات السريعة (أسفل الخريطة) --------
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 20), // مسافة في الأسفل عشان السكرول
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.deepPurple[50]!,
                                      Colors.deepPurple[100]!,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: _buildMiniStat(
                                          'نشط الآن',
                                          '23',
                                          Icons.location_on,
                                          Colors.green,
                                          screenWidth),
                                    ),
                                    Expanded(
                                      child: _buildMiniStat(
                                          'قيد التوصيل',
                                          '15',
                                          Icons.delivery_dining,
                                          Colors.orange,
                                          screenWidth),
                                    ),
                                    Expanded(
                                      child: _buildMiniStat(
                                          'منتهي',
                                          '33',
                                          Icons.check_circle,
                                          Colors.blue,
                                          screenWidth),
                                    ),
                                  ],
                                ),
                              ),
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
      ),

      // -------- البار السفلي --------
      bottomNavigationBar: Container(
        height: screenHeight * 0.08,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MerchantTrackingScreen()),
              );
            },
            icon: Icon(Icons.analytics, size: screenWidth * 0.05),
            label: Text(
              'الإحصائيات المتقدمة',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ... (باقي الدوال Helper Methods زي ما هي في كودك الأصلي)
  Widget _buildStatCard(BuildContext context,
      {required String title,
      required String value,
      required String subtitle,
      required IconData icon,
      required Color color,
      required Widget screen}) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
          ),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 3))
          ],
        ),
        child: Stack(
          children: [
            Positioned(
                top: -8,
                right: -8,
                child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle))),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(icon, color: color, size: 18)),
                        Icon(Icons.arrow_forward_ios_rounded,
                            color: color.withOpacity(0.5), size: 14),
                      ]),
                  SizedBox(height: 4),
                  Text(value,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color)),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800])),
                        Text(subtitle,
                            style: TextStyle(
                                fontSize: 9, color: Colors.grey[600])),
                      ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPoint(Color color, String count, double containerWidth) {
    return Container(
      width: containerWidth * 0.08,
      height: containerWidth * 0.08,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.5), blurRadius: 6, spreadRadius: 2)
        ],
      ),
      child: Center(
          child: Text(count,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: containerWidth * 0.025))),
    );
  }

  Widget _buildMiniStat(String title, String value, IconData icon, Color color,
      double screenWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: screenWidth * 0.04, color: color)),
        SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.bold,
                color: color)),
        Text(title,
            style: TextStyle(
                fontSize: screenWidth * 0.025, color: Colors.grey[600])),
      ],
    );
  }

  void _showMapDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [
          Icon(Icons.map, color: Colors.blue),
          SizedBox(width: 8),
          Text('خريطة الطلبات التفصيلية')
        ]),
        content: Container(
          width: double.maxFinite,
          height: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.blue[50]),
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Icon(Icons.map_outlined, size: 60, color: Colors.blue[300]),
                SizedBox(height: 16),
                Text('شاشة الخريطة التفصيلية',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800])),
              ])),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('إغلاق'))
        ],
      ),
    );
  }
}
