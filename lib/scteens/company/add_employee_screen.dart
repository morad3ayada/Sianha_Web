import 'package:flutter/material.dart';
import 'employee_model.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _salaryController = TextEditingController();

  String? _selectedJob;
  String? _selectedDepartment;
  String? _selectedStatus;
  String? _selectedWorkSchedule;
  String? _selectedRole;

  List<String> jobTitles = [
    'محاسب',
    'خدمة عملاء',
    'مندوب',
    'مدير قسم',
    'فني',
    'مدير موارد بشرية',
    'مبرمج',
    'مصمم',
  ];

  List<String> departments = [
    'موارد بشرية',
    'خدمة عملاء',
    'صيانة',
    'تسويق',
    'محاسبة',
    'تكنولوجيا المعلومات',
    'إدارة',
  ];

  List<String> statusList = ['شغال', 'أجازة', 'موقوف'];
  List<String> schedules = ['9-5', 'نوبات', 'ساعات مرنة'];
  List<String> roles = ['موظف', 'مدير', 'محاسب', 'مندوب', 'فني'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة موظف جديد'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveEmployee,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // رفع الصورة
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(color: Color(0xffe58e8e)),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'إضغط لإضافة صورة',
                style: TextStyle(color: Colors.grey[600]),
              ),

              SizedBox(height: 30),

              // حقل الاسم
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'اسم الموظف',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم الموظف';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              // حقل الهاتف
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'رقم التليفون',
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم التليفون';
                  }
                  if (value.length < 10) {
                    return 'رقم التليفون غير صالح';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              // حقل البريد الإلكتروني
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال البريد الإلكتروني';
                  }
                  if (!value.contains('@')) {
                    return 'البريد الإلكتروني غير صالح';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              // حقل الراتب
              TextFormField(
                controller: _salaryController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'الراتب الأساسي',
                  prefixIcon: Icon(Icons.attach_money_outlined),
                  suffixText: 'جنية',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الراتب الأساسي';
                  }
                  if (double.tryParse(value) == null) {
                    return 'الرجاء إدخال رقم صالح';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              // اختيار الوظيفة
              DropdownButtonFormField<String>(
                value: _selectedJob,
                decoration: InputDecoration(
                  labelText: 'الوظيفة',
                  prefixIcon: Icon(Icons.work_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: jobTitles.map((job) {
                  return DropdownMenuItem(
                    value: job,
                    child: Text(job),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedJob = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'الرجاء اختيار الوظيفة';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              // اختيار القسم
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                decoration: InputDecoration(
                  labelText: 'القسم',
                  prefixIcon: Icon(Icons.business_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: departments.map((dept) {
                  return DropdownMenuItem(
                    value: dept,
                    child: Text(dept),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'الرجاء اختيار القسم';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              // اختيار مواعيد العمل
              DropdownButtonFormField<String>(
                value: _selectedWorkSchedule,
                decoration: InputDecoration(
                  labelText: 'مواعيد العمل',
                  prefixIcon: Icon(Icons.access_time_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: schedules.map((schedule) {
                  return DropdownMenuItem(
                    value: schedule,
                    child: Text(schedule),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedWorkSchedule = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'الرجاء اختيار مواعيد العمل';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              // اختيار الحالة
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'حالة الموظف',
                  prefixIcon: Icon(Icons.info_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: statusList.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'الرجاء اختيار حالة الموظف';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              // اختيار الصلاحية/الدور
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  labelText: 'الدور والصلاحيات',
                  prefixIcon: Icon(Icons.security_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'الرجاء اختيار الدور';
                  }
                  return null;
                },
              ),

              SizedBox(height: 30),

              // أزرار الحفظ والإلغاء
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveEmployee,
                      child: Text(
                        'حفظ الموظف',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(
                            0xFF2C3E50), // تم التغيير من primary إلى backgroundColor
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'إلغاء',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Colors.grey),
                      ),
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

  void _pickImage() {
    // TODO: تنفيذ اختيار صورة
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('التقاط صورة'),
              onTap: () {
                Navigator.pop(context);
                // تفعيل الكاميرا
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('اختيار من المعرض'),
              onTap: () {
                Navigator.pop(context);
                // فتح المعرض
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      // التحقق من اختيار جميع القوائم المنسدلة
      if (_selectedJob == null ||
          _selectedDepartment == null ||
          _selectedWorkSchedule == null ||
          _selectedStatus == null ||
          _selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('الرجاء اختيار جميع الخيارات المطلوبة'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // إنشاء كائن الموظف
      Employee newEmployee = Employee(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        jobTitle: _selectedJob!,
        department: _selectedDepartment!,
        basicSalary: double.parse(_salaryController.text),
        workSchedule: _selectedWorkSchedule!,
        status: _selectedStatus!,
        hireDate: DateTime.now(),
        password: '123456', // كلمة مرور افتراضية
        role: _selectedRole!,
        imageUrl: null,
      );

      // TODO: حفظ الموظف في قاعدة البيانات
      // يمكنك استدعاء دالة الحفظ من Provider أو Service هنا
      print('تم إنشاء الموظف: ${newEmployee.name}');

      // إظهار رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إضافة الموظف ${_nameController.text} بنجاح'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // العودة للشاشة السابقة بعد تأخير قصير
      Future.delayed(Duration(milliseconds: 1500), () {
        Navigator.pop(context, newEmployee);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الرجاء تصحيح الأخطاء في النموذج'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    // تنظيف المتحكمات عند تدمير الشاشة
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _salaryController.dispose();
    super.dispose();
  }
}
