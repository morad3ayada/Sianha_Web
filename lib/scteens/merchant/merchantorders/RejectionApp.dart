import 'package:flutter/material.dart';

class RejectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام الرفض',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Tajawal',
      ),
      home: RejectionScreen(),
    );
  }
}

class RejectionScreen extends StatefulWidget {
  @override
  _RejectionScreenState createState() => _RejectionScreenState();
}

class _RejectionScreenState extends State<RejectionScreen> {
  // قائمة التجار المرفوضين (بيانات وهمية)
  final List<Map<String, dynamic>> rejectedMerchants = [
    {
      'id': 'REF-001',
      'storeName': 'محل التقنية المتطور',
      'reason': 'الورق غير كامل',
      'date': '2023-12-01',
      'employee': 'أحمد محمد',
      'status': 'مرفوض',
    },
    {
      'id': 'REF-002',
      'storeName': 'متجر الأزياء الحديث',
      'reason': 'مكتفين من هدا المحلات',
      'date': '2023-12-02',
      'employee': 'فاطمة علي',
      'status': 'مرفوض',
    },
    {
      'id': 'REF-003',
      'storeName': 'سوبر ماركت النخبة',
      'reason': 'في وقت لحق',
      'date': '2023-12-03',
      'employee': 'خالد عبدالله',
      'status': 'مرفوض',
    },
    {
      'id': 'REF-004',
      'storeName': 'مكتبة المعرفة',
      'reason': 'معلومات غير كافية',
      'date': '2023-12-04',
      'employee': 'سارة أحمد',
      'status': 'مرفوض',
    },
    {
      'id': 'REF-005',
      'storeName': 'محل الهواتف الذكية',
      'reason': 'الورق غير كامل',
      'date': '2023-12-05',
      'employee': 'محمد حسن',
      'status': 'مرفوض',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'قائمة المرفوضين',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[700],
        elevation: 8,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          // بطاقة الإحصائيات
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red[50],
              border: Border(
                bottom: BorderSide(color: Colors.red[100]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.do_not_disturb_alt,
                    color: Colors.red[700],
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التجار المرفوضين',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'إجمالي ${rejectedMerchants.length} تاجر مرفوض',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    rejectedMerchants.length.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // قائمة المرفوضين
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: rejectedMerchants.length,
              itemBuilder: (context, index) {
                final merchant = rejectedMerchants[index];
                return _buildRejectedMerchantCard(merchant, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedMerchantCard(Map<String, dynamic> merchant, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.red, width: 4),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف العلوي - المعلومات الأساسية
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.store,
                      color: Colors.red[700],
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          merchant['storeName'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          merchant['id'],
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
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Text(
                      merchant['status'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // سبب الرفض
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'سبب الرفض: ${merchant['reason']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              // معلومات إضافية
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.blue, size: 14),
                        SizedBox(width: 6),
                        Text(
                          merchant['employee'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.green, size: 14),
                        SizedBox(width: 6),
                        Text(
                          merchant['date'],
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

              SizedBox(height: 12),

              // زر إزالة الرفض
              Container(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _removeRejection(index);
                  },
                  icon: Icon(Icons.delete_outline, size: 18),
                  label: Text('إزالة الرفض'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
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
    );
  }

  void _removeRejection(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 8),
              Text('إزالة الرفض'),
            ],
          ),
          content: Text(
            'هل أنت متأكد من إزالة الرفض عن ${rejectedMerchants[index]['storeName']}؟',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  rejectedMerchants.removeAt(index);
                });
                Navigator.of(context).pop();

                // عرض رسالة نجاح
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إزالة الرفض بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('تأكيد الإزالة'),
            ),
          ],
        );
      },
    );
  }
}
