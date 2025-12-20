import 'package:flutter/material.dart';

// 1. استيراد الموديل الأساسي (ضروري جداً)
import 'modelstechnician.dart';
import 'add_technician_screen.dart';
import 'rejected_technicians_screen.dart';
import 'rejection_reason_screen.dart';
import 'technician_details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام الفنيين',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: 'Tajawal',
        useMaterial3: true,
      ),
      home: TechnicianManagementScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TechnicianManagementScreen extends StatefulWidget {
  @override
  _TechnicianManagementScreenState createState() =>
      _TechnicianManagementScreenState();
}

class _TechnicianManagementScreenState
    extends State<TechnicianManagementScreen> {
  List<Technician> technicians = [
    Technician(
      name: 'أحمد محمد علي',
      specialty: 'صيانة مكيفات',
      phone: '01012345678',
      status: 'مقبول',
    ),
    Technician(
      name: 'محمد إبراهيم',
      specialty: 'فني تكييف',
      phone: '01123456789',
      status: 'مرفوض',
      rejectionReason: 'بيانات ناقصة',
    ),
    Technician(
      name: 'خالد عبد الرحمن',
      specialty: 'فني تبريد',
      phone: '01234567890',
      status: 'قيد المراجعة',
    ),
    Technician(
      name: 'سعيد محمود',
      specialty: 'فني تكييف مركزي',
      phone: '01555555555',
      status: 'مقبول',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStatsCards(),
            Expanded(
              child: _buildTechniciansList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTechnicianScreen()),
          );
        },
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.person_add_alt_1, size: 28),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.yellow[800]!, Colors.yellow[900]!],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إدارة الفنيين',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Tajawal',
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${technicians.length} فني في النظام',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildHeaderIcon(
                icon: Icons.assignment_late,
                color: Colors.red,
                screen: RejectedTechniciansScreen(),
                tooltip: 'الفنيين المرفوضين',
              ),
              SizedBox(width: 12),
              _buildHeaderIcon(
                icon: Icons.analytics,
                color: Colors.green,
                onPressed: () {},
                tooltip: 'التقارير',
              ),
              SizedBox(width: 12),
              _buildHeaderIcon(
                icon: Icons.settings,
                color: Colors.yellow,
                onPressed: () {},
                tooltip: 'الإعدادات',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon({
    required IconData icon,
    required Color color,
    Widget? screen,
    VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.yellow[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 22),
        color: color,
        onPressed: onPressed ??
            () {
              if (screen != null) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => screen));
              }
            },
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildStatsCards() {
    int accepted = technicians.where((t) => t.status == 'مقبول').length;
    int pending = technicians.where((t) => t.status == 'قيد المراجعة').length;
    int rejected = technicians.where((t) => t.status == 'مرفوض').length;

    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
              child: _buildStatCard(
                  'مقبول', accepted, Colors.green, Icons.check_circle)),
          SizedBox(width: 12),
          Expanded(
              child: _buildStatCard(
                  'قيد المراجعة', pending, Colors.orange, Icons.pending)),
          SizedBox(width: 12),
          Expanded(
              child:
                  _buildStatCard('مرفوض', rejected, Colors.red, Icons.cancel)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechniciansList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: technicians.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildTechnicianCard(technicians[index]);
        },
      ),
    );
  }

  Widget _buildTechnicianCard(Technician tech) {
    Color statusColor = _getStatusColor(tech.status);
    Color cardColor = _getCardColor(tech.status);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(20),
        color: cardColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cardColor, cardColor.withOpacity(0.9)],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tech.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.work_outline,
                                  size: 14, color: Colors.grey[400]),
                              SizedBox(width: 6),
                              Text(
                                tech.specialty,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [statusColor, statusColor.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Text(
                        tech.status,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: Colors.grey[400]),
                    SizedBox(width: 8),
                    Text(
                      tech.phone,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (tech.rejectionReason != null) ...[
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline,
                          size: 16, color: Colors.red[300]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'سبب الرفض: ${tech.rejectionReason}',
                          style: TextStyle(
                            color: Colors.red[300],
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        text: 'عرض التفاصيل',
                        icon: Icons.visibility,
                        color: Colors.yellow,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AccountRecoveryDetailsScreen(
                                      technician: tech),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    if (tech.status == 'قيد المراجعة')
                      Expanded(
                        child: _buildActionButton(
                          text: 'رفض',
                          icon: Icons.close,
                          color: Colors.red,
                          onPressed: () {
                            _showRejectionDialog(context, tech);
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'مقبول':
        return Colors.green;
      case 'مرفوض':
        return Colors.red;
      case 'قيد المراجعة':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getCardColor(String status) {
    switch (status) {
      case 'مقبول':
        return Color(0xFF1A3A2F);
      case 'مرفوض':
        return Color(0xFF3A1F2F);
      case 'قيد المراجعة':
        return Color(0xFF3A2F1F);
      default:
        return Colors.blueGrey[900]!;
    }
  }

  void _showRejectionDialog(BuildContext context, Technician tech) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.yellow[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.warning, color: Colors.red, size: 32),
              ),
              SizedBox(height: 16),
              Text(
                'رفض الفني',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'هل تريد رفض طلب ${tech.name}؟',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildDialogButton(
                      text: 'إلغاء',
                      color: Colors.grey,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildDialogButton(
                      text: 'متابعة الرفض',
                      color: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RejectionReasonScreen(technician: tech),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
