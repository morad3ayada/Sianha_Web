import 'package:flutter/material.dart';

void main() {
  runApp(ReviewApp());
}

class ReviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مراجعة الحساب',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Tajawal',
      ),
      home: AccountReviewScreen(),
    );
  }
}

class AccountReviewScreen extends StatefulWidget {
  @override
  _AccountReviewScreenState createState() => _AccountReviewScreenState();
}

class _AccountReviewScreenState extends State<AccountReviewScreen> {
  // بيانات التاجر (عادة تأتي من API)
  final Map<String, dynamic> merchantData = {
    'storeName': 'محل الإلكترونيات الحديث',
    'storeImage': 'assets/store_placeholder.jpg', // صورة افتراضية
    'address': 'شارع الجمهورية - بجوار البنك الأهلي',
    'governorate': 'القاهرة',
    'area': 'وسط البلد',
    'street': 'شارع الجمهورية',
    'specialization': 'إلكترونيات',
    'phone': '+201234567890',
    'openingTime': '09:00 ص',
    'closingTime': '11:00 م',
    'status': 'قيد المراجعة', // قيد المراجعة، مقبول، مرفوض
  };

  String? _rejectionReason;
  final List<String> _rejectionReasons = [
    'غير مكتمل الأوراق',
    'مكتمل كل محلات من نفس التخصص',
    'الموقع غير مناسب',
    'معلومات غير صحيحة',
    'سبب آخر'
  ];

  void _showAcceptDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('قبول الحساب'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('هل أنت متأكد من قبول حساب التاجر:'),
              SizedBox(height: 10),
              Text(
                merchantData['storeName'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
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
                Navigator.of(context).pop();
                _showCongratulations();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text('تأكيد القبول'),
            ),
          ],
        );
      },
    );
  }

  void _showCongratulations() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.celebration,
                  size: 60,
                  color: Colors.green,
                ),
                SizedBox(height: 16),
                Text(
                  'مبروك قبول',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'تم قبول حساب التاجر بنجاح',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // العودة للشاشة السابقة أو إجراء آخر
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    'تم',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRejectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.cancel, color: Colors.red, size: 30),
                  SizedBox(width: 10),
                  Text('رفض الحساب'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('اختر سبب الرفض:'),
                    SizedBox(height: 16),
                    ..._rejectionReasons.map((reason) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: reason,
                              groupValue: _rejectionReason,
                              onChanged: (value) {
                                setState(() {
                                  _rejectionReason = value;
                                });
                              },
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                reason,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: _rejectionReason == null
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          _submitRejection();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('تأكيد الرفض'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _submitRejection() {
    // هنا يمكن إضافة منطق إرسال الرفض للخادم
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تم الرفض'),
          content: Text('تم رفض الحساب بسبب: $_rejectionReason'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // العودة للشاشة السابقة
              },
              child: Text('تم'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'مراجعة حساب التاجر',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // بطاقة بيانات التاجر
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // حالة المراجعة
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time,
                              color: Colors.orange, size: 16),
                          SizedBox(width: 6),
                          Text(
                            merchantData['status'],
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // صورة المحل
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                        image: DecorationImage(
                          image: AssetImage('assets/store_placeholder.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(Icons.store,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // معلومات المحل
                    _buildInfoRow(
                        'اسم المحل', merchantData['storeName'], Icons.store),
                    _buildInfoRow('التخصص', merchantData['specialization'],
                        Icons.category),
                    _buildInfoRow(
                        'رقم التليفون', merchantData['phone'], Icons.phone),
                    _buildInfoRow(
                        'مواعيد العمل',
                        '${merchantData['openingTime']} - ${merchantData['closingTime']}',
                        Icons.access_time),

                    // العنوان
                    Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.red, size: 20),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'العنوان',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(merchantData['address']),
                                  SizedBox(height: 4),
                                  Text(
                                    '${merchantData['governorate']} - ${merchantData['area']}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
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
            ),

            SizedBox(height: 24),

            // أزرار القرار
            Row(
              children: [
                // زر القبول
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showAcceptDialog,
                    icon: Icon(Icons.check_circle_outline, size: 24),
                    label: Text(
                      'قبول',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),

                // زر الرفض
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showRejectionDialog,
                    icon: Icon(Icons.cancel_outlined, size: 24),
                    label: Text(
                      'رفض',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue[700], size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
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
