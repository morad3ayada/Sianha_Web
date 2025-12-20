import 'package:flutter/material.dart';

class TemporaryBlockScreen extends StatefulWidget {
  @override
  _TemporaryBlockScreenState createState() => _TemporaryBlockScreenState();
}

class _TemporaryBlockScreenState extends State<TemporaryBlockScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _employeeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Map<String, String>? _currentBlock;
  bool _isBlocked = false;

  void _applyBlock() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentBlock = {
          "merchant": "التاجر الحالي", // يمكن تغيير هذا ليكون اسم التاجر الفعلي
          "duration": _durationController.text,
          "employee": _employeeController.text,
          "phone": _phoneController.text,
          "date": DateTime.now().toString(),
        };
        _isBlocked = true;

        // إظهار رسالة النجاح
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "تم تطبيق الحظر المؤقت بنجاح",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // تنظيف الحقول
        _durationController.clear();
        _employeeController.clear();
        _phoneController.clear();
      });
    }
  }

  void _removeBlock() {
    setState(() {
      _currentBlock = null;
      _isBlocked = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم إلغاء الحظر المؤقت"),
          backgroundColor: Colors.orange,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الحظر المؤقت للتاجر"),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // معلومات التاجر
            _buildMerchantInfoCard(),
            SizedBox(height: 20),

            // حالة الحظر الحالية
            if (_isBlocked && _currentBlock != null) _buildCurrentBlockCard(),

            // نموذج الحظر
            if (!_isBlocked) _buildBlockForm(),

            // زر إلغاء الحظر
            if (_isBlocked) _buildRemoveBlockButton(),
          ],
        ),
      ),
    );
  }

  // بطاقة معلومات التاجر
  Widget _buildMerchantInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.store, color: Colors.deepOrange, size: 30),
                SizedBox(width: 12),
                Text(
                  "معلومات التاجر",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow("اسم التاجر:", "التاجر الحالي"),
            _buildInfoRow("الحالة:", _isBlocked ? "محظور مؤقتاً" : "نشط"),
            _buildInfoRow("تاريخ التسجيل:", "١ يناير ٢٠٢٤"),
          ],
        ),
      ),
    );
  }

  // نموذج تطبيق الحظر
  Widget _buildBlockForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تطبيق حظر مؤقت",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              SizedBox(height: 20),

              // مدة الحظر
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: "مدة الحظر (بالأيام)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                  prefixIcon: Icon(Icons.timer, color: Colors.deepOrange),
                  hintText: "مثال: 7 أيام",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال مدة الحظر';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // اسم الموظف
              TextFormField(
                controller: _employeeController,
                decoration: InputDecoration(
                  labelText: "اسم الموظف المسؤول",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                  prefixIcon: Icon(Icons.badge, color: Colors.deepOrange),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم الموظف';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // رقم التليفون
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "رقم التليفون للتواصل",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                  prefixIcon: Icon(Icons.phone, color: Colors.deepOrange),
                  hintText: "01XXXXXXXXX",
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم التليفون';
                  }
                  if (value.length < 10) {
                    return 'رقم التليفون يجب أن يكون 10 أرقام على الأقل';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // زر تطبيق الحظر
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _applyBlock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    "تطبيق الحظر المؤقت",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // بطاقة الحظر الحالي
  Widget _buildCurrentBlockCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.block, color: Colors.red, size: 30),
                    SizedBox(width: 8),
                    Text(
                      "حظر مؤقت مفعل",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    "محظور",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow("مدة الحظر:", _currentBlock!["duration"]!),
            _buildInfoRow("اسم الموظف:", _currentBlock!["employee"]!),
            _buildInfoRow("رقم التليفون:", _currentBlock!["phone"]!),
            _buildInfoRow(
                "تاريخ التطبيق:", _formatDate(_currentBlock!["date"]!)),
          ],
        ),
      ),
    );
  }

  // زر إلغاء الحظر
  Widget _buildRemoveBlockButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: _removeBlock,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "إلغاء الحظر المؤقت",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // صف معلومات
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // تنسيق التاريخ
  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  @override
  void dispose() {
    _durationController.dispose();
    _employeeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
