import 'package:flutter/material.dart';

class RequestTeamScreen extends StatefulWidget {
  @override
  _RequestTeamScreenState createState() => _RequestTeamScreenState();
}

class _RequestTeamScreenState extends State<RequestTeamScreen> {
  final _formKey = GlobalKey<FormState>();

  // متغيرات النموذج
  String _supervisorName = '';
  String _inspectorName = '';
  String _supervisorPhone = '';
  int _teamMembers = 1;
  String _governorate = '';
  String _district = '';
  String _street = '';
  List<String> _selectedSpecialties = [];

  // قائمة التخصصات المتاحة
  final List<Map<String, dynamic>> _specialties = [
    {
      'id': 'plumbing',
      'name': 'سباك',
      'icon': Icons.plumbing,
      'color': Colors.blue
    },
    {
      'id': 'electrical',
      'name': 'كهرباء',
      'icon': Icons.electrical_services,
      'color': Colors.orange
    },
    {
      'id': 'painting',
      'name': 'دهان',
      'icon': Icons.format_paint,
      'color': Colors.green
    },
    {
      'id': 'carpentry',
      'name': 'نجار',
      'icon': Icons.construction,
      'color': Colors.brown
    },
    {
      'id': 'tiles',
      'name': 'تركيب سيراميك',
      'icon': Icons.square_foot,
      'color': Colors.purple
    },
    {
      'id': 'plaster',
      'name': 'تبييض',
      'icon': Icons.brush,
      'color': Colors.cyan
    },
    {
      'id': 'aluminum',
      'name': 'ألومنيوم',
      'icon': Icons.window,
      'color': Colors.grey
    },
    {
      'id': 'gypsum',
      'name': 'جبس',
      'icon': Icons.account_balance,
      'color': Colors.amber
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('طلب فريق تشطيب'),
        backgroundColor: Color(0xFF2D5A78),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // بطاقة المعلومات
              _buildInfoCard(),
              SizedBox(height: 20),

              // معلومات المشرف والمعاين
              _buildSupervisorSection(),
              SizedBox(height: 20),

              // معلومات الفريق
              _buildTeamSection(),
              SizedBox(height: 20),

              // معلومات العنوان
              _buildAddressSection(),
              SizedBox(height: 20),

              // تخصصات الفريق
              _buildSpecialtiesSection(),
              SizedBox(height: 30),

              // زر الإرسال
              _buildSubmitButton(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF2D5A78), Color(0xFF1E3A5C)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.group_add, color: Colors.white, size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'طلب فريق تشطيب جديد',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'املأ النموذج لطلب فريق متخصص لأعمال التشطيب',
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

  Widget _buildSupervisorSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.supervisor_account, color: Color(0xFF2D5A78)),
              SizedBox(width: 8),
              Text(
                'معلومات المشرفين',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5C),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'اسم المشرف على المشروع',
            hint: 'أدخل اسم المشرف',
            icon: Icons.person,
            onSaved: (value) => _supervisorName = value!,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'اسم المعاين',
            hint: 'أدخل اسم المعاين',
            icon: Icons.engineering,
            onSaved: (value) => _inspectorName = value!,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'رقم تليفون المشرف',
            hint: 'أدخل رقم التليفون',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            onSaved: (value) => _supervisorPhone = value!,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people, color: Color(0xFF2D5A78)),
              SizedBox(width: 8),
              Text(
                'معلومات الفريق',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5C),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'عدد أفراد الفريق',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xff7a4747)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.red),
                  onPressed: () {
                    if (_teamMembers > 1) {
                      setState(() {
                        _teamMembers--;
                      });
                    }
                  },
                ),
                Text(
                  '$_teamMembers فرد',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D5A78),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.green),
                  onPressed: () {
                    setState(() {
                      _teamMembers++;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFF2D5A78)),
              SizedBox(width: 8),
              Text(
                'معلومات العنوان',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5C),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'المحافظة',
            hint: 'أدخل اسم المحافظة',
            icon: Icons.location_city,
            onSaved: (value) => _governorate = value!,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'المركز / الحي / المنطقة',
            hint: 'أدخل اسم المنطقة',
            icon: Icons.place,
            onSaved: (value) => _district = value!,
          ),
          SizedBox(height: 16),
          _buildTextField(
            label: 'الشارع',
            hint: 'أدخل اسم الشارع',
            icon: Icons.streetview,
            onSaved: (value) => _street = value!,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtiesSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.build, color: Color(0xFF2D5A78)),
              SizedBox(width: 8),
              Text(
                'تخصصات الفريق المطلوبة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5C),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'اختر التخصصات المطلوبة للفريق',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _specialties.map((specialty) {
              final isSelected = _selectedSpecialties.contains(specialty['id']);
              return FilterChip(
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedSpecialties.add(specialty['id']);
                    } else {
                      _selectedSpecialties.remove(specialty['id']);
                    }
                  });
                },
                label: Text(
                  specialty['name'],
                  style: TextStyle(
                    color: isSelected ? Colors.white : specialty['color'],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor:
                    isSelected ? specialty['color'] : Colors.grey[50],
                selectedColor: specialty['color'],
                checkmarkColor: Colors.white,
                avatar: Icon(specialty['icon'],
                    color: isSelected ? Colors.white : specialty['color']),
                shape: StadiumBorder(
                  side: BorderSide(
                    color: isSelected ? specialty['color'] : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required FormFieldSetter<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Color(0xFF2D5A78)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF2D5A78), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'هذا الحقل مطلوب';
            }
            return null;
          },
          onSaved: onSaved,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2D5A78),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, size: 20),
            SizedBox(width: 8),
            Text(
              'إرسال طلب الفريق',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedSpecialties.isEmpty) {
        _showErrorDialog('يرجى اختيار تخصص واحد على الأقل');
        return;
      }

      // عرض تأكيد الطلب
      _showConfirmationDialog();
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('تأكيد الطلب'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تم إرسال طلب فريق التشطيب بنجاح'),
            SizedBox(height: 16),
            Text('سيتم مراجعة الطلب وإرسال الفريق المناسب خلال 24 ساعة'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('خطأ'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help, color: Color(0xFF2D5A78)),
            SizedBox(width: 8),
            Text('مساعدة'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تعليمات طلب الفريق:'),
            SizedBox(height: 12),
            _buildHelpItem('املأ جميع الحقول المطلوبة'),
            _buildHelpItem('اختر التخصصات المناسبة للمشروع'),
            _buildHelpItem('سيتم التواصل معك خلال 24 ساعة'),
            _buildHelpItem('تأكد من صحة رقم الهاتف'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 8, color: Color(0xFF2D5A78)),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
