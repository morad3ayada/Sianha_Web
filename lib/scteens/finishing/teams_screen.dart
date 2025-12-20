import 'package:flutter/material.dart';
import 'request_team_screen.dart';

class TeamsScreen extends StatefulWidget {
  @override
  _TeamsScreenState createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  // لتتبع حالة كل فريق (قيد المراجعة، مقبول، مرفوض)
  List<TeamStatus> teamStatuses =
      List.generate(5, (index) => TeamStatus.pending);

  // لتخزين أسباب الرفض لكل فريق
  List<String?> rejectionReasons = List.generate(5, (index) => null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('فرق التشطيب'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس الصفحة
            _buildHeaderSection(),
            SizedBox(height: 20),

            Text(
              'قائمة فرق التشطيب',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildTeamCard(index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.orange[700]!, Colors.orange[500]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.construction, color: Colors.white, size: 30),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'فرق التشطيب',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '5 فرق نشطة - 23 مشروع',
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
    );
  }

  Widget _buildTeamCard(int index) {
    List<Map<String, dynamic>> teamSpecialties = [
      {'name': 'سباك', 'color': Colors.blue},
      {'name': 'كهرباء', 'color': Colors.orange},
      {'name': 'دهان', 'color': Colors.green},
    ];

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.group, color: Colors.orange, size: 24),
            ),
            title: Text(
              'فريق التشطيب ${index + 1}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text('${index + 3} مشاريع نشطة'),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: teamSpecialties.map((specialty) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: specialty['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: specialty['color'].withOpacity(0.3)),
                      ),
                      child: Text(
                        specialty['name'],
                        style: TextStyle(
                          fontSize: 10,
                          color: specialty['color'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            trailing: _buildStatusBadge(index),
          ),
          Divider(height: 1),

          // قسم معلومات الفريق
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      '${index + 4} أعضاء',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    SizedBox(width: 4),
                    Text(
                      '4.${index + 2}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.assignment, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      '${index + 2} مكتمل',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // قسم أزرار القبول والرفض (يظهر فقط إذا كان قيد المراجعة)
          if (teamStatuses[index] == TeamStatus.pending) ...[
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAcceptButton(index),
                  _buildRejectButton(index),
                ],
              ),
            ),
          ],

          // قسم سبب الرفض (يظهر فقط إذا كان مرفوض)
          if (teamStatuses[index] == TeamStatus.rejected &&
              rejectionReasons[index] != null) ...[
            Divider(height: 1),
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.red[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.red, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'سبب الرفض:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    rejectionReasons[index]!,
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(int index) {
    switch (teamStatuses[index]) {
      case TeamStatus.accepted:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.green),
          ),
          child: Text(
            'مقبول',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case TeamStatus.rejected:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.red),
          ),
          child: Text(
            'مرفوض',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case TeamStatus.pending:
      default:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.orange),
          ),
          child: Text(
            'قيد المراجعة',
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }

  Widget _buildAcceptButton(int index) {
    return ElevatedButton.icon(
      onPressed: () {
        _showAcceptConfirmationDialog(index);
      },
      icon: Icon(Icons.check, size: 18),
      label: Text('قبول'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  Widget _buildRejectButton(int index) {
    return ElevatedButton.icon(
      onPressed: () {
        _showRejectionReasonDialog(index);
      },
      icon: Icon(Icons.close, size: 18),
      label: Text('رفض'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  void _showAcceptConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('قبول الفريق'),
        content: Text('هل أنت متأكد من قبول فريق التشطيب ${index + 1}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                teamStatuses[index] = TeamStatus.accepted;
                rejectionReasons[index] = null;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم قبول الفريق ${index + 1} بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('تأكيد القبول'),
          ),
        ],
      ),
    );
  }

  void _showRejectionReasonDialog(int index) {
    String? selectedReason;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('رفض الفريق'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('اختر سبب رفض فريق التشطيب ${index + 1}:'),
                    SizedBox(height: 16),

                    // خيارات سبب الرفض
                    Column(
                      children: [
                        _buildReasonRadioTile(
                          value: 'غير مكتمل',
                          selectedValue: selectedReason,
                          onChanged: (value) {
                            setState(() => selectedReason = value);
                          },
                        ),
                        _buildReasonRadioTile(
                          value: 'يوجد مشاكل في الأعمال السابقة',
                          selectedValue: selectedReason,
                          onChanged: (value) {
                            setState(() => selectedReason = value);
                          },
                        ),
                        _buildReasonRadioTile(
                          value: 'غير منتظم في المواعيد',
                          selectedValue: selectedReason,
                          onChanged: (value) {
                            setState(() => selectedReason = value);
                          },
                        ),
                        _buildReasonRadioTile(
                          value: 'غير مؤهل للعمل',
                          selectedValue: selectedReason,
                          onChanged: (value) {
                            setState(() => selectedReason = value);
                          },
                        ),
                        _buildReasonRadioTile(
                          value: 'آخر',
                          selectedValue: selectedReason,
                          onChanged: (value) {
                            setState(() => selectedReason = value);
                          },
                        ),
                      ],
                    ),

                    // حقل النص إذا تم اختيار "آخر"
                    if (selectedReason == 'آخر')
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'اكتب سبب الرفض',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            selectedReason = value;
                          },
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: selectedReason == null ||
                          (selectedReason == 'آخر' &&
                              (selectedReason?.isEmpty ?? true))
                      ? null
                      : () {
                          setState(() {
                            teamStatuses[index] = TeamStatus.rejected;
                            rejectionReasons[index] = selectedReason;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم رفض الفريق ${index + 1}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('رفض الفريق'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildReasonRadioTile({
    required String value,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return RadioListTile<String>(
      title: Text(value),
      value: value,
      groupValue: selectedValue,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _navigateToRequestTeamScreen(context);
      },
      backgroundColor: Colors.orange,
      elevation: 4,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange, Colors.orange[800]!],
          ),
        ),
        child: Icon(Icons.group_add, color: Colors.white, size: 28),
      ),
    );
  }

  void _navigateToRequestTeamScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestTeamScreen(),
      ),
    );
  }
}

enum TeamStatus {
  pending, // قيد المراجعة
  accepted, // مقبول
  rejected, // مرفوض
}
