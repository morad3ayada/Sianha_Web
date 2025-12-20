import 'package:flutter/material.dart';
import 'employee_model.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final Employee employee;

  EmployeeDetailsScreen({required this.employee});

  @override
  _EmployeeDetailsScreenState createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الموظف'),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              _handlePopupMenuSelection(value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('تعديل البيانات'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 10),
                    Text('حذف الموظف'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'status',
                child: Row(
                  children: [
                    Icon(Icons.change_circle, color: Colors.orange),
                    SizedBox(width: 10),
                    Text('تغيير الحالة'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(icon: Icon(Icons.person), text: 'البيانات'),
            Tab(icon: Icon(Icons.access_time), text: 'الحضور'),
            Tab(icon: Icon(Icons.beach_access), text: 'الإجازات'),
            Tab(icon: Icon(Icons.attach_money), text: 'المرتبات'),
            Tab(icon: Icon(Icons.history), text: 'السجل'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBasicInfoTab(),
          _buildAttendanceTab(),
          _buildVacationsTab(),
          _buildSalaryTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // صورة الموظف
          Stack(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.blue[100],
                child: widget.employee.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: Image.network(
                          widget.employee.imageUrl!,
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.blue[800],
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.employee.status),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getStatusIcon(widget.employee.status),
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            widget.employee.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 5),
          Text(
            widget.employee.jobTitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),

          // بطاقة المعلومات
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow(
                    icon: Icons.email,
                    title: 'البريد الإلكتروني',
                    value: widget.employee.email,
                  ),
                  Divider(),
                  _buildInfoRow(
                    icon: Icons.phone,
                    title: 'الهاتف',
                    value: widget.employee.phone,
                  ),
                  Divider(),
                  _buildInfoRow(
                    icon: Icons.business,
                    title: 'القسم',
                    value: widget.employee.department,
                  ),
                  Divider(),
                  _buildInfoRow(
                    icon: Icons.attach_money,
                    title: 'الراتب الأساسي',
                    value: '${widget.employee.basicSalary} جنيه',
                  ),
                  Divider(),
                  _buildInfoRow(
                    icon: Icons.access_time,
                    title: 'مواعيد العمل',
                    value: widget.employee.workSchedule,
                  ),
                  Divider(),
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    title: 'تاريخ التعيين',
                    value:
                        '${widget.employee.hireDate.day}/${widget.employee.hireDate.month}/${widget.employee.hireDate.year}',
                  ),
                  Divider(),
                  _buildInfoRow(
                    icon: Icons.security,
                    title: 'الدور',
                    value: widget.employee.role,
                  ),
                  Divider(),
                  _buildInfoRow(
                    icon: Icons.info,
                    title: 'الحالة',
                    value: widget.employee.status,
                    valueColor: _getStatusColor(widget.employee.status),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // أزرار الإجراءات
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _editEmployee,
                  icon: Icon(Icons.edit),
                  label: Text('تعديل البيانات'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .orange, // تم التغيير من primary إلى backgroundColor
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showDeleteDialog(),
                  icon: Icon(Icons.delete),
                  label: Text('حذف الموظف'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // تم التغيير من primary إلى backgroundColor
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'إحصائيات الحضور',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.bar_chart, color: Colors.blue),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatBox('الحضور', '22 يوم', Colors.green),
                      _buildStatBox('الغياب', '3 أيام', Colors.red),
                      _buildStatBox('التأخير', '5 أيام', Colors.orange),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'نسبة الحضور: 88%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'آخر 5 أيام',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          ...List.generate(5, (index) => _buildAttendanceDayItem(index)),
        ],
      ),
    );
  }

  Widget _buildVacationsTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.beach_access,
              size: 80,
              color: Colors.blue[200],
            ),
            SizedBox(height: 20),
            Text(
              'إجمالي الإجازات المستحقة',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            Text(
              '30 يوم',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.add),
              label: Text('طلب إجازة جديدة'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue, // تم التغيير من primary إلى backgroundColor
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'كشف الراتب الشهري',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildSalaryItem('الراتب الأساسي',
                      widget.employee.basicSalary, Colors.blue),
                  _buildSalaryItem('الخصومات', 200, Colors.red),
                  _buildSalaryItem('الحوافز', 500, Colors.green),
                  Divider(thickness: 2),
                  _buildSalaryItem('صافي الراتب',
                      widget.employee.basicSalary + 300, Colors.green[800]!,
                      isTotal: true),
                  SizedBox(height: 20),
                  Chip(
                    label: Text('تم الدفع'),
                    backgroundColor: Colors.green[100],
                    labelStyle: TextStyle(color: Colors.green[800]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'السجل العملي',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ...List.generate(5, (index) => _buildHistoryItem(index)),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          SizedBox(width: 15),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? Colors.blue[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String title, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        SizedBox(height: 5),
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

  Widget _buildAttendanceDayItem(int index) {
    List<String> days = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'];
    List<String> status = ['حاضر', 'حاضر', 'متأخر', 'حاضر', 'غائب'];
    List<Color> colors = [
      Colors.green,
      Colors.green,
      Colors.orange,
      Colors.green,
      Colors.red
    ];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colors[index].withOpacity(0.1),
          child: Icon(
            status[index] == 'حاضر'
                ? Icons.check
                : status[index] == 'متأخر'
                    ? Icons.access_time
                    : Icons.close,
            color: colors[index],
          ),
        ),
        title: Text('يوم ${days[index]}'),
        subtitle: Text('الحالة: ${status[index]}'),
        trailing: Text('08:00 ص - 04:00 م'),
      ),
    );
  }

  Widget _buildSalaryItem(String title, double amount, Color color,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? color : Colors.blue[800],
            ),
          ),
          Text(
            '${amount.toStringAsFixed(2)} جنيه',
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? color : color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(int index) {
    List<String> actions = [
      'تم إنشاء مهمة جديدة',
      'تم تحديث بيانات الموظف',
      'حصل على ترقية',
      'أخذ إجازة سنوية',
      'حصل على مكافأة'
    ];
    List<String> dates = [
      '2024-03-01',
      '2024-02-15',
      '2024-01-20',
      '2023-12-10',
      '2023-11-05'
    ];

    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(Icons.history, color: Colors.blue),
        ),
        title: Text(actions[index]),
        subtitle: Text(dates[index]),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'شغال':
        return Colors.green;
      case 'أجازة':
        return Colors.orange;
      case 'موقوف':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'شغال':
        return Icons.check_circle;
      case 'أجازة':
        return Icons.beach_access;
      case 'موقوف':
        return Icons.block;
      default:
        return Icons.help;
    }
  }

  void _handlePopupMenuSelection(String value) {
    switch (value) {
      case 'edit':
        _editEmployee();
        break;
      case 'delete':
        _showDeleteDialog();
        break;
      case 'status':
        _changeEmployeeStatus();
        break;
    }
  }

  void _editEmployee() {
    // قم بتنفيذ شاشة تعديل البيانات هنا
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('سيتم فتح شاشة تعديل البيانات'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _changeEmployeeStatus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تغيير حالة الموظف'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('اختر الحالة الجديدة لـ ${widget.employee.name}:'),
            SizedBox(height: 20),
            ...['شغال', 'أجازة', 'موقوف']
                .map((status) => RadioListTile<String>(
                      title: Text(status),
                      value: status,
                      groupValue: widget.employee.status,
                      onChanged: (value) {
                        // تحديث حالة الموظف
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تم تغيير الحالة إلى $status'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ))
                .toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف الموظف'),
        content: Text(
            'هل أنت متأكد من حذف الموظف ${widget.employee.name}؟ هذا الإجراء لا يمكن التراجع عنه.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حذف الموظف ${widget.employee.name}'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text('حذف'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.red, // تم التغيير من primary إلى backgroundColor
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
