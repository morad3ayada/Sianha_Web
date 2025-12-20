import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'colors.dart';

class SalaryManagementScreen extends StatefulWidget {
  @override
  _SalaryManagementScreenState createState() => _SalaryManagementScreenState();
}

class _SalaryManagementScreenState extends State<SalaryManagementScreen> {
  DateTime _selectedMonth = DateTime.now();
  List<Map<String, dynamic>> _salaryList = [
    {
      'id': '1',
      'name': 'أحمد محمد',
      'avatar': 'أ',
      'basic': 5000.0,
      'deductions': 200.0,
      'bonuses': 500.0,
      'net': 5300.0,
      'isPaid': true,
      'department': 'محاسبة',
    },
    {
      'id': '2',
      'name': 'سارة علي',
      'avatar': 'س',
      'basic': 4000.0,
      'deductions': 100.0,
      'bonuses': 300.0,
      'net': 4200.0,
      'isPaid': false,
      'department': 'خدمة عملاء',
    },
    {
      'id': '3',
      'name': 'محمد حسن',
      'avatar': 'م',
      'basic': 4500.0,
      'deductions': 150.0,
      'bonuses': 400.0,
      'net': 4750.0,
      'isPaid': false,
      'department': 'تسويق',
    },
    {
      'id': '4',
      'name': 'علي محمود',
      'avatar': 'ع',
      'basic': 6000.0,
      'deductions': 300.0,
      'bonuses': 700.0,
      'net': 6400.0,
      'isPaid': true,
      'department': 'إدارة',
    },
    {
      'id': '5',
      'name': 'فاطمة أحمد',
      'avatar': 'ف',
      'basic': 3800.0,
      'deductions': 80.0,
      'bonuses': 200.0,
      'net': 3920.0,
      'isPaid': false,
      'department': 'خدمة عملاء',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // إصلاح: استخدام double بدلاً من num
    double totalSalaries = _salaryList.fold(
        0.0, (double sum, item) => sum + (item['net'] as double));
    double paidSalaries = _salaryList
        .where((item) => item['isPaid'] == true)
        .fold(0.0, (double sum, item) => sum + (item['net'] as double));
    double pendingSalaries = totalSalaries - paidSalaries;

    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة المرتبات'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: _selectMonth,
            tooltip: 'اختر الشهر',
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _exportReport,
            tooltip: 'تصدير التقرير',
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: (value) => _filterSalaries(value),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'all', child: Text('الكل')),
              PopupMenuItem(value: 'paid', child: Text('المدفوعة فقط')),
              PopupMenuItem(value: 'pending', child: Text('المعلقة فقط')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // رأس الشاشة
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[50]!, Colors.lightBlue[50]!],
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'شهر ${DateFormat('MMMM yyyy', 'ar').format(_selectedMonth)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_salaryList.where((item) => item['isPaid']).length}/${_salaryList.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // الإحصائيات
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'إجمالي المرتبات',
                    value: totalSalaries,
                    icon: Icons.attach_money,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    title: 'المدفوعة',
                    value: paidSalaries,
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    title: 'المعلقة',
                    value: pendingSalaries,
                    icon: Icons.pending,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // شريط التحكم
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _addDeduction,
                        icon: Icon(Icons.remove_circle_outline),
                        label: Text('إضافة خصم'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _addBonus,
                        icon: Icon(Icons.add_circle_outline),
                        label: Text('إضافة حافز'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[400],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // عنوان القائمة
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'قائمة المرتبات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                Text(
                  '${_salaryList.length} موظف',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // قائمة المرتبات
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _salaryList.length,
              itemBuilder: (context, index) {
                final item = _salaryList[index];
                return _buildSalaryCard(item);
              },
            ),
          ),

          // أزرار الإجراءات الجماعية
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _payAllSalaries,
                    icon: Icon(Icons.payment),
                    label: Text('دفع الكل'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generateReport,
                    icon: Icon(Icons.receipt),
                    label: Text('كشف حساب'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required double value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '${value.toInt()} ج',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryCard(Map<String, dynamic> item) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                // صورة الموظف
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    item['avatar'],
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                // معلومات الموظف
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item['department'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // حالة الدفع
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: item['isPaid']
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: item['isPaid'] ? Colors.green : Colors.orange,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    item['isPaid'] ? 'تم الدفع' : 'معلق',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: item['isPaid'] ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // تفاصيل الراتب
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSalaryDetail(
                    'الأساسي', (item['basic'] as double), Colors.blue),
                _buildSalaryDetail(
                    'الخصومات', (item['deductions'] as double), Colors.red),
                _buildSalaryDetail(
                    'الحوافز', (item['bonuses'] as double), Colors.green),
                _buildSalaryDetail(
                    'الصافي', (item['net'] as double), Colors.green[800]!),
              ],
            ),
            SizedBox(height: 12),
            // أزرار الإجراءات
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewSalaryDetails(item),
                    child: Text('تفاصيل'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _togglePaymentStatus(item),
                    child: Text(
                      item['isPaid'] ? 'تم الدفع' : 'دفع الآن',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          item['isPaid'] ? Colors.grey[300] : Colors.green,
                      foregroundColor:
                          item['isPaid'] ? Colors.grey[600] : Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryDetail(String title, double amount, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Text(
          '${amount.toInt()}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _selectMonth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialDatePickerMode: DatePickerMode.year,
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
    if (picked != null) {
      setState(() {
        _selectedMonth = picked;
      });
    }
  }

  void _addDeduction() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إضافة خصم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // هنا يمكن إضافة حقول الإدخال
            Text('سيتم إضافة نافذة إضافة خصم'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إضافة الخصم'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('إضافة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _addBonus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إضافة حافز'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // هنا يمكن إضافة حقول الإدخال
            Text('سيتم إضافة نافذة إضافة حافز'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إضافة الحافز'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('إضافة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _payAllSalaries() {
    // إصلاح: تحويل النتائج إلى double
    double totalPendingAmount = _salaryList
        .where((item) => !item['isPaid'])
        .fold(0.0, (double sum, item) => sum + (item['net'] as double));

    int pendingCount = _salaryList.where((item) => !item['isPaid']).length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.payment, color: Colors.green),
            SizedBox(width: 10),
            Text('دفع جميع المرتبات'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('هل تريد دفع جميع المرتبات المعلقة لهذا الشهر؟'),
            SizedBox(height: 15),
            Text(
              'المبلغ الإجمالي: ${totalPendingAmount.toInt()} ج',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'عدد الموظفين: $pendingCount',
              style: TextStyle(color: Colors.grey[600]),
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
                for (var item in _salaryList) {
                  if (!item['isPaid']) {
                    item['isPaid'] = true;
                  }
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم دفع جميع المرتبات المعلقة بنجاح'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  action: SnackBarAction(
                    label: 'تم',
                    onPressed: () {},
                    textColor: Colors.white,
                  ),
                ),
              );
            },
            child: Text('تأكيد الدفع'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _togglePaymentStatus(Map<String, dynamic> item) {
    if (item['isPaid']) return; // إذا كان مدفوعاً مسبقاً

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('دفع راتب ${item['name']}'),
        content:
            Text('هل تريد دفع راتب ${item['name']} بقيمة ${item['net']} ج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                item['isPaid'] = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم دفع راتب ${item['name']} بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('تأكيد الدفع'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _viewSalaryDetails(Map<String, dynamic> item) {
    // عرض تفاصيل الراتب
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'تفاصيل راتب ${item['name']}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRow('الراتب الأساسي', '${item['basic']} ج'),
            _buildDetailRow('الخصومات', '${item['deductions']} ج',
                isNegative: true),
            _buildDetailRow('الحوافز', '${item['bonuses']} ج',
                isPositive: true),
            Divider(thickness: 2),
            _buildDetailRow('صافي الراتب', '${item['net']} ج', isTotal: true),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إغلاق'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool isNegative = false,
      bool isPositive = false,
      bool isTotal = false}) {
    Color color = Colors.blue;
    if (isNegative) color = Colors.red;
    if (isPositive) color = Colors.green;
    if (isTotal) color = Colors.green[800]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تصدير تقرير المرتبات بنجاح'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _generateReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إنشاء كشف الحساب'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _filterSalaries(String filter) {
    // يمكن تنفيذ الفلترة هنا
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تطبيق الفلتر: $filter'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
