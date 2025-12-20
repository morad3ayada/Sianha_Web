import 'package:flutter/material.dart';

class AddTechnicianScreen extends StatefulWidget {
  @override
  _AddTechnicianScreenState createState() => _AddTechnicianScreenState();
}

class _AddTechnicianScreenState extends State<AddTechnicianScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? selectedGovernorate;
  String? selectedSpecialty;
  String? selectedWorkSchedule;
  bool isCraneOperator = false;

  List<String> governorates = ['القاهرة', 'الجيزة', 'الإسكندرية', 'المنوفية'];
  List<String> specialties = [
    'صيانة مكيفات',
    'فني تكييف',
    'فني تبريد',
    'فني تكييف مركزي'
  ];
  List<String> workSchedules = [
    'صباح (12 ساعة)',
    'مساء (12 ساعة)',
    'طواري (14 ساعة)'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة فني جديد'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // الاسم
              _buildTextField(
                controller: nameController,
                label: 'الاسم الثلاثي',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'يرجى إدخال الاسم';
                  return null;
                },
              ),

              // رقم التليفون
              _buildTextField(
                controller: phoneController,
                label: 'رقم التليفون',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'يرجى إدخال رقم التليفون';
                  if (value.length != 11)
                    return 'رقم التليفون يجب أن يكون 11 رقم';
                  return null;
                },
              ),

              // المحافظة
              _buildDropdown(
                value: selectedGovernorate,
                items: governorates,
                label: 'المحافظة',
                icon: Icons.location_city,
                onChanged: (value) {
                  setState(() => selectedGovernorate = value);
                },
              ),

              // المنطقة/المركز
              _buildTextField(
                controller: addressController,
                label: 'المنطقة / المركز',
                icon: Icons.location_on,
              ),

              // التخصص
              _buildDropdown(
                value: selectedSpecialty,
                items: specialties,
                label: 'التخصص',
                icon: Icons.work,
                onChanged: (value) {
                  setState(() => selectedSpecialty = value);
                },
              ),

              // مواعيد العمل
              _buildDropdown(
                value: selectedWorkSchedule,
                items: workSchedules,
                label: 'مواعيد العمل',
                icon: Icons.schedule,
                onChanged: (value) {
                  setState(() => selectedWorkSchedule = value);
                },
              ),

              // هل هو مشغل ونش؟
              SwitchListTile(
                title: Text('مشغل ونش؟'),
                value: isCraneOperator,
                onChanged: (value) => setState(() => isCraneOperator = value),
                secondary: Icon(Icons.local_shipping),
              ),

              // رفع الصور
              _buildImageUploadSection(),

              // زر الحفظ
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم إضافة الفني بنجاح')));
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text('حفظ البيانات', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String label,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => value == null ? 'يرجى اختيار $label' : null,
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('رفع المستندات والصور',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _buildImageUploadItem('صورة البطاقة (الوجه)'),
            _buildImageUploadItem('صورة البطاقة (الظهر)'),
            if (isCraneOperator) ...[
              _buildImageUploadItem('صورة اللوحة المعدنية'),
              _buildImageUploadItem('رخصة السائق'),
              _buildImageUploadItem('رخصة الونش'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadItem(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.photo_camera, color: Colors.blue),
          SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 14)),
          Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[50],
              foregroundColor: Colors.blue,
            ),
            child: Text('رفع صورة'),
          ),
        ],
      ),
    );
  }
}
