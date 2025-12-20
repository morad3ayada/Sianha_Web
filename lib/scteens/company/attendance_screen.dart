import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  Map<String, Map<String, dynamic>> _attendanceData = {};
  
  bool _hasCheckedIn = false;
  TimeOfDay _checkInTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay? _checkOutTime;
  
  // بيانات تجريبية لحضور الموظفين
  List<Map<String, dynamic>> _employeeAttendance = [
    {
      'name': 'أحمد محمد',
      'position': 'محاسب',
      'status': 'حاضر',
      'checkIn': '08:00 ص',
      'checkOut': '04:00 م',
      'avatar': 'أ',
      'color': Colors.blue,
    },
    {
      'name': 'سارة علي',
      'position': 'خدمة عملاء',
      'status': 'متأخر',
      'checkIn': '08:45 ص',
      'checkOut': '--:--',
      'avatar': 'س',
      'color': Colors.purple,
    },
    {
      'name': 'محمد حسن',
      'position': 'مندوب',
      'status': 'غائب',
      'checkIn': '--:--',
      'checkOut': '--:--',
      'avatar': 'م',
      'color': Colors.yellow[800],
    },
    {
      'name': 'فاطمة أحمد',
      'position': 'مديرة قسم',
      'status': 'حاضر',
      'checkIn': '07:55 ص',
      'checkOut': '03:58 م',
      'avatar': 'ف',
      'color': Colors.green,
    },
    {
      'name': 'خالد سعيد',
      'position': 'فني',
      'status': 'حاضر',
      'checkIn': '08:05 ص',
      'checkOut': '--:--',
      'avatar': 'خ',
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الحضور والانصراف'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: _showMonthlyReport,
          ),
        ],
      ),
      body: Column(
        children: [
          // تاريخ اليوم
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[50]!, Colors.lightBlue[50]!],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue[800]),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE, d MMMM y', 'ar').format(_selectedDate),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        Text(
                          'اليوم: ${_getDayName(_selectedDate.weekday)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_employeeAttendance.where((e) => e['status'] == 'حاضر').length}/${_employeeAttendance.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // بطاقة تسجيل الحضور للموظف الحالي
          Card(
            margin: EdgeInsets.all(15),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.fingerprint, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        'تسجيل الحضور والانصراف',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTimeCard(
                        icon: Icons.login,
                        title: 'الحضور',
                        time: _hasCheckedIn 
                            ? '${_checkInTime.hour.toString().padLeft(2, '0')}:${_checkInTime.minute.toString().padLeft(2, '0')}'
                            : '--:--',
                        color: _hasCheckedIn ? Colors.green : Colors.grey,
                        isDone: _hasCheckedIn,
                      ),
                      _buildTimeCard(
                        icon: Icons.logout,
                        title: 'الانصراف',
                        time: _checkOutTime != null
                            ? '${_checkOutTime!.hour.toString().padLeft(2, '0')}:${_checkOutTime!.minute.toString().padLeft(2, '0')}'
                            : '--:--',
                        color: _checkOutTime != null ? Colors.red : Colors.grey,
                        isDone: _checkOutTime != null,
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  _hasCheckedIn && _checkOutTime == null
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _recordCheckOut,
                            icon: Icon(Icons.logout),
                            label: Text('تسجيل الانصراف'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400], // تم التغيير من primary إلى backgroundColor
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _hasCheckedIn ? null : _recordAttendance,
                            icon: Icon(Icons.fingerprint),
                            label: Text(
                              _hasCheckedIn ? 'تم تسجيل الحضور' : 'تسجيل الحضور',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _hasCheckedIn ? Colors.grey : Colors.green, // تم التغيير من primary إلى backgroundColor
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),

          // عنوان قائمة الموظفين
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'حضور الموظفين',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list, color: Colors.blue),
                  onSelected: (value) {
                    // فلترة القائمة
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'all', child: Text('الكل')),
                    PopupMenuItem(value: 'present', child: Text('الحاضرون فقط')),
                    PopupMenuItem(value: 'absent', child: Text('الغائبون فقط')),
                    PopupMenuItem(value: 'late', child: Text('المتأخرون فقط')),
                  ],
                ),
              ],
            ),
          ),

          // قائمة حضور الموظفين
          Expanded(
            child: ListView.separated(
              itemCount: _employeeAttendance.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final employee = _employeeAttendance[index];
                return _buildEmployeeAttendanceItem(employee);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard({
    required IconData icon,
    required String title,
    required String time,
    required Color color,
    required bool isDone,
  }) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(
            icon,
            size: 35,
            color: color,
          ),
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 5),
        Text(
          time,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        if (isDone)
          Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'تم',
              style: TextStyle(
                fontSize: 10,
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmployeeAttendanceItem(Map<String, dynamic> employee) {
    Color statusColor;
    switch (employee['status']) {
      case 'حاضر':
        statusColor = Colors.green;
        break;
      case 'متأخر':
        statusColor = Colors.orange;
        break;
      case 'غائب':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: (employee['color'] as Color).withOpacity(0.2),
        foregroundColor: employee['color'] as Color,
        child: Text(
          employee['avatar'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        employee['name'],
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employee['position']),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.login, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                employee['checkIn'],
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(width: 15),
              Icon(Icons.logout, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                employee['checkOut'],
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: statusColor, width: 1),
        ),
        child: Text(
          employee['status'],
          style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      onTap: () {
        // تفاصيل حضور الموظف
      },
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'الاثنين';
      case 2: return 'الثلاثاء';
      case 3: return 'الأربعاء';
      case 4: return 'الخميس';
      case 5: return 'الجمعة';
      case 6: return 'السبت';
      case 7: return 'الأحد';
      default: return '';
    }
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _recordAttendance() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.fingerprint, color: Colors.blue),
            SizedBox(width: 10),
            Text('تسجيل الحضور'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('هل تريد تسجيل حضورك الآن؟'),
            SizedBox(height: 15),
            Text(
              'وقت التسجيل: ${DateFormat('hh:mm a', 'ar').format(DateTime.now())}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _hasCheckedIn = true;
                _checkInTime = TimeOfDay.now();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تسجيل الحضور بنجاح'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Text('تأكيد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _recordCheckOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 10),
            Text('تسجيل الانصراف'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('هل تريد تسجيل انصرافك الآن؟'),
            SizedBox(height: 15),
            Text(
              'وقت التسجيل: ${DateFormat('hh:mm a', 'ar').format(DateTime.now())}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'مدة العمل: ${_calculateWorkHours()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _checkOutTime = TimeOfDay.now();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تسجيل الانصراف بنجاح'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Text('تأكيد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateWorkHours() {
    if (!_hasCheckedIn) return '0 ساعة';
    
    final now = DateTime.now();
    final checkInDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _checkInTime.hour,
      _checkInTime.minute,
    );
    
    final difference = now.difference(checkInDateTime);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    
    return '$hours ساعة و $minutes دقيقة';
  }

  void _showMonthlyReport() {
    // عرض تقرير شهري
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        height: 300,
        child: Column(
          children: [
            Text(
              'تقرير الحضور الشهري',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // إضافة رسوم بيانية أو إحصائيات هنا
            Expanded(
              child: Center(
                child: Text('سيتم إضافة التقرير الشهري قريباً'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}