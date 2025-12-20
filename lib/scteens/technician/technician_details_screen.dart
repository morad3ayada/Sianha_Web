import 'package:flutter/material.dart';
import 'modelstechnician.dart';

class AccountRecoveryDetailsScreen extends StatefulWidget {
  final Technician technician;

  AccountRecoveryDetailsScreen({required this.technician});

  @override
  _AccountRecoveryDetailsScreenState createState() =>
      _AccountRecoveryDetailsScreenState();
}

class _AccountRecoveryDetailsScreenState
    extends State<AccountRecoveryDetailsScreen> {
  // Rejection controllers
  TextEditingController _rejectionReasonController = TextEditingController();
  TextEditingController _employeeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "مراجعة البيانات - تفاصيل الفني",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF7C3AED),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),
            SizedBox(height: 24),

            // Missing Data Warning
            if (widget.technician.missingData != null &&
                widget.technician.missingData!.isNotEmpty)
              _buildMissingDataWarning(),

            // Personal Information
            _buildSection(
              title: 'المعلومات الشخصية',
              icon: Icons.person,
              children: _buildPersonalInfo(),
            ),

            // Work Information
            _buildSection(
              title: 'معلومات العمل',
              icon: Icons.work,
              children: _buildWorkInfo(),
            ),

            // Additional Information
            _buildSection(
              title: 'معلومات إضافية',
              icon: Icons.info,
              children: _buildAdditionalInfo(),
            ),

            // Documents Section - بطاقة الشخصية (دائماً تظهر)
            _buildSection(
              title: 'البطاقة الشخصية',
              icon: Icons.credit_card,
              children: _buildIdCardsSection(),
            ),

            // Documents Section - مستندات الونش (تظهر فقط لو فني ونش)
            if (widget.technician.isCraneOperator)
              _buildSection(
                title: 'مستندات الونش',
                icon: Icons.local_shipping,
                children: _buildCraneDocumentsSection(),
              ),

            // Action Buttons - Approval & Rejection
            _buildApprovalButtons(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.technician.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.technician.specialty,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'مراجعة البيانات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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

  Widget _buildMissingDataWarning() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.orange, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بيانات ناقصة تحتاج للمراجعة',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.technician.missingData!,
                  style: TextStyle(
                    color: Colors.orange.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF7C3AED).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Color(0xFF7C3AED), size: 20),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  List<Widget> _buildPersonalInfo() {
    return [
      _buildInfoItem('الاسم الثلاثي', widget.technician.name),
      _buildInfoItem('رقم الهاتف', widget.technician.phone),
      _buildInfoItem('المحافظة', widget.technician.governorate),
      _buildInfoItem('المركز', widget.technician.center),
      _buildInfoItem('العنوان', widget.technician.address),
    ];
  }

  List<Widget> _buildWorkInfo() {
    return [
      _buildInfoItem('التخصص', widget.technician.specialty),
      _buildInfoItem('مواعيد العمل', widget.technician.workSchedule),
      _buildInfoItem('ساعات العمل', widget.technician.workHours ?? ''),
    ];
  }

  List<Widget> _buildAdditionalInfo() {
    return [
      _buildInfoItem('سنوات الخبرة', widget.technician.experience ?? ''),
      _buildInfoItem('وسيلة التنقل', widget.technician.transportation ?? ''),
      _buildInfoItem('نوع الفني',
          widget.technician.isCraneOperator ? 'فني ونش' : 'فني عادي'),
    ];
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Color(0xFF374151),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? 'غير محدد' : value,
              style: TextStyle(
                color: value.isEmpty ? Colors.grey[600] : Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildIdCardsSection() {
    return [
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          // صورة البطاقة الوجه - تظهر دائماً
          _buildDocumentCard(
            'صورة البطاقة (الوجه)',
            widget.technician.frontIdImage,
            isRequired: true,
          ),
          // صورة البطاقة الظهر - تظهر دائماً
          _buildDocumentCard(
            'صورة البطاقة (الظهر)',
            widget.technician.backIdImage,
            isRequired: true,
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildCraneDocumentsSection() {
    return [
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          // اللوحة المعدنية - تظهر فقط للونش
          _buildDocumentCard(
            'اللوحة المعدنية',
            widget.technician.licensePlate,
            isRequired: true,
          ),
          // رخصة القيادة - تظهر فقط للونش
          _buildDocumentCard(
            'رخصة القيادة',
            widget.technician.driverLicense,
            isRequired: true,
          ),
          // رخصة السيارة - تظهر فقط للونش
          _buildDocumentCard(
            'رخصة السيارة',
            widget.technician.vehicleLicense,
            isRequired: true,
          ),
          // رخصة تشغيل الونش - تظهر فقط للونش
          _buildDocumentCard(
            'رخصة تشغيل الونش',
            widget.technician.craneLicense,
            isRequired: true,
          ),
        ],
      ),
    ];
  }

  Widget _buildDocumentCard(String title, String? imagePath,
      {bool isRequired = false}) {
    bool hasDocument = imagePath != null && imagePath.isNotEmpty;

    return GestureDetector(
      onTap: hasDocument ? () => _viewDocument(title, imagePath!) : null,
      child: Container(
        width: 150,
        height: 140,
        decoration: BoxDecoration(
          color: hasDocument ? Colors.white : Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasDocument ? Colors.green : Colors.grey.withOpacity(0.3),
            width: hasDocument ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة أو صورة مصغرة
            if (hasDocument)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: Icon(
                  Icons.image,
                  color: Colors.grey[600],
                  size: 30,
                ),
                // في التطبيق الحقيقي، استخدم:
                // Image.network(imagePath) للصور من السيرفر
              )
            else
              Icon(
                Icons.error_outline,
                color: Colors.orange,
                size: 40,
              ),

            SizedBox(height: 8),

            // عنوان المستند
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: hasDocument ? Color(0xFF1E293B) : Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 4),

            // حالة المستند
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  hasDocument ? Icons.check_circle : Icons.error,
                  color: hasDocument ? Colors.green : Colors.orange,
                  size: 14,
                ),
                SizedBox(width: 4),
                Text(
                  hasDocument ? 'مكتمل' : 'ناقص',
                  style: TextStyle(
                    color: hasDocument ? Colors.green : Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalButtons() {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          'اتخاذ قرار المراجعة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            // زر القبول - يظهر دائماً
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.green.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: _showAcceptConfirmation,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'قبول البيانات',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            // زر الرفض - يظهر دائماً
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.red.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: _showRejectionDialog,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cancel, color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'رفض البيانات',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _viewDocument(String title, String imagePath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 50, color: Colors.grey[500]),
                      SizedBox(height: 8),
                      Text(
                        'صورة $title',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // في التطبيق الحقيقي:
                // Image.network(imagePath, fit: BoxFit.contain)
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('إغلاق'),
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

  void _showAcceptConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text(
              'قبول البيانات',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'هل أنت متأكد من قبول بيانات الفني ${widget.technician.name}؟',
          style: TextStyle(color: Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _acceptData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text('نعم، قبول', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showRejectionDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cancel, color: Colors.red, size: 28),
                    SizedBox(width: 8),
                    Text(
                      'رفض البيانات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'سبب الرفض:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _rejectionReasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'أدخل سبب رفض البيانات...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'اسم الموظف المسؤول:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _employeeNameController,
                  decoration: InputDecoration(
                    hintText: 'أدخل اسمك...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child:
                            Text('إلغاء', style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_rejectionReasonController.text.isEmpty ||
                              _employeeNameController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('يرجى ملء جميع الحقول'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          Navigator.pop(context);
                          _rejectData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child:
                            Text('رفض', style: TextStyle(color: Colors.white)),
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

  void _acceptData() {
    // منطق قبول البيانات
    print('تم قبول بيانات الفني: ${widget.technician.name}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم قبول البيانات بنجاح ✅'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  void _rejectData() {
    // منطق رفض البيانات
    print('تم رفض بيانات الفني: ${widget.technician.name}');
    print('سبب الرفض: ${_rejectionReasonController.text}');
    print('الموظف المسؤول: ${_employeeNameController.text}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم رفض البيانات ❌'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}
