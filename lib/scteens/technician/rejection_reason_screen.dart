import 'package:flutter/material.dart';
import 'modelstechnician.dart';

class RejectionReasonScreen extends StatefulWidget {
  final Technician technician;

  const RejectionReasonScreen({Key? key, required this.technician})
      : super(key: key);

  @override
  _RejectionReasonScreenState createState() => _RejectionReasonScreenState();
}

class _RejectionReasonScreenState extends State<RejectionReasonScreen> {
  String? selectedReason;
  TextEditingController customReasonController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();

  List<String> rejectionReasons = [
    'بيانات ناقصة',
    'صور غير واضحة',
    'رقم هاتف غير صحيح',
    'تخصص غير مطلوب الآن',
    'خبرة غير كافية',
    'سلوك غير مناسب',
    'سبب آخر'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سبب الرفض'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'رفض طلب: ${widget.technician.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // اسم الموظف
            _buildTextField(
              controller: employeeNameController,
              label: 'اسم الموظف المسؤول',
              icon: Icons.person_outline,
            ),

            // سبب الرفض
            Text(
              'سبب الرفض:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...rejectionReasons
                .map((reason) => RadioListTile<String>(
                      title: Text(reason),
                      value: reason,
                      groupValue: selectedReason,
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value;
                        });
                      },
                    ))
                .toList(),

            // سبب مخصص
            if (selectedReason == 'سبب آخر')
              _buildTextField(
                controller: customReasonController,
                label: 'السبب المخصص',
                icon: Icons.edit,
              ),

            Spacer(),

            // زر الإرسال
            ElevatedButton(
              onPressed: _submitRejection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('إرسال الرفض', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  void _submitRejection() {
    if (selectedReason == null || employeeNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إكمال جميع البيانات')),
      );
      return;
    }

    String finalReason = selectedReason == 'سبب آخر'
        ? customReasonController.text
        : selectedReason!;

    // حفظ بيانات الرفض
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم رفض الفني بنجاح')),
    );
    Navigator.pop(context);
  }
}
