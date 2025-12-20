import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MerchantApp());
}

class MerchantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام إضافة التجار',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Tajawal',
      ),
      home: AddMerchantScreen(),
    );
  }
}

class AddMerchantScreen extends StatefulWidget {
  @override
  _AddMerchantScreenState createState() => _AddMerchantScreenState();
}

class _AddMerchantScreenState extends State<AddMerchantScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  // متحكمات النصوص
  final _storeNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _areaController = TextEditingController();
  final _specializationController = TextEditingController();
  final _openingTimeController = TextEditingController();
  final _closingTimeController = TextEditingController();

  // المتغيرات
  String? _selectedGovernorate;
  File? _storeImage;
  String? _selectedSpecialization;

  // القوائم المنسدلة
  final List<String> _governorates = [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'الدقهلية',
    'الشرقية',
    'الغربية',
    'القليوبية',
    'المنوفية',
    'كفر الشيخ',
    'الفيوم',
    'بني سويف',
    'مطروح',
    'أسوان',
    'الأقصر',
    'البحر الأحمر',
    'السويس',
    'الإسماعيلية',
    'بورسعيد',
    'دمياط',
    'شمال سيناء',
    'جنوب سيناء'
  ];

  final List<String> _specializations = [
    'ملابس',
    'أجهزة كهربائية',
    'موبايلات',
    'أثاث',
    'سوبر ماركت',
    'مطعم',
    'مقاهي',
    'صيدلية',
    'مكتبة',
    'رياضة',
    'أطفال',
    'مجوهرات',
    'إلكترونيات',
    'ساعات',
    'أحذية',
    'مستلزمات منزلية',
    '其他'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'إضافة تاجر جديد',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 6,
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
                  // عنوان الشاشة
                  Center(
                    child: Text(
                      'نموذج إضافة تاجر جديد',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'يرجى تعبئة جميع البيانات المطلوبة',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  // اسم المحل
                  _buildLabel('اسم المحل *'),
                  TextFormField(
                    controller: _storeNameController,
                    decoration: InputDecoration(
                      hintText: 'أدخل اسم المحل',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      prefixIcon: Icon(Icons.store, color: Colors.blue[700]),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال اسم المحل';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // المحافظة
                  _buildLabel('المحافظة *'),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedGovernorate,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        prefixIcon:
                            Icon(Icons.location_city, color: Colors.blue[700]),
                      ),
                      items: _governorates.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedGovernorate = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'يرجى اختيار المحافظة';
                        }
                        return null;
                      },
                      hint: Text('اختر المحافظة'),
                    ),
                  ),
                  SizedBox(height: 20),

                  // المنطقة أو المركز
                  _buildLabel('المنطقة / المركز *'),
                  TextFormField(
                    controller: _areaController,
                    decoration: InputDecoration(
                      hintText: 'أدخل المنطقة أو المركز',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      prefixIcon: Icon(Icons.place, color: Colors.blue[700]),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال المنطقة';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // العنوان التفصيلي
                  _buildLabel('العنوان التفصيلي'),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'أدخل العنوان التفصيلي',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      prefixIcon: Icon(Icons.home, color: Colors.blue[700]),
                    ),
                  ),
                  SizedBox(height: 20),

                  // التخصص
                  _buildLabel('التخصص *'),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedSpecialization,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        prefixIcon:
                            Icon(Icons.category, color: Colors.blue[700]),
                      ),
                      items: _specializations.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSpecialization = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'يرجى اختيار التخصص';
                        }
                        return null;
                      },
                      hint: Text('اختر تخصص المحل'),
                    ),
                  ),
                  SizedBox(height: 20),

                  // مواعيد العمل
                  _buildLabel('مواعيد العمل *'),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _openingTimeController,
                          decoration: InputDecoration(
                            hintText: 'وقت الفتح',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            prefixIcon:
                                Icon(Icons.access_time, color: Colors.green),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'أدخل وقت الفتح';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('إلى', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _closingTimeController,
                          decoration: InputDecoration(
                            hintText: 'وقت الإغلاق',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            prefixIcon:
                                Icon(Icons.access_time, color: Colors.red),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'أدخل وقت الإغلاق';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // صورة المحل
                  _buildLabel('صورة المحل'),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!, width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[100],
                    ),
                    child: _storeImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt,
                                  size: 40, color: Colors.grey[500]),
                              SizedBox(height: 8),
                              Text('لا توجد صورة',
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_storeImage!, fit: BoxFit.cover),
                          ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickImageFromCamera,
                          icon: Icon(Icons.camera),
                          label: Text('الكاميرا'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue[700],
                            side: BorderSide(color: Colors.blue[700]!),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickImageFromGallery,
                          icon: Icon(Icons.photo_library),
                          label: Text('المعرض'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue[700],
                            side: BorderSide(color: Colors.blue[700]!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // الموقع
                  _buildLabel('الموقع'),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 40, color: Colors.blue[700]),
                        SizedBox(height: 8),
                        Text('خريطة الموقع',
                            style: TextStyle(color: Colors.grey[700])),
                        SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _selectLocation,
                          icon: Icon(Icons.location_on),
                          label: Text('تحديد الموقع'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // أزرار الإجراءات
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'إضافة التاجر',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetForm,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(color: Colors.grey),
                          ),
                          child: Text(
                            'مسح الكل',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _storeImage = File(image.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _storeImage = File(image.path);
      });
    }
  }

  void _selectLocation() {
    // هنا يمكن إضافة منطق اختيار الموقع من الخريطة
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تحديد الموقع'),
          content: Text('سيتم فتح الخريطة لتحديد موقع المحل'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // افتح الخريطة هنا
              },
              child: Text('فتح الخريطة'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // هنا يمكن إضافة منطق حفظ البيانات
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('تمت الإضافة بنجاح'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('اسم المحل: ${_storeNameController.text}'),
                Text('المحافظة: $_selectedGovernorate'),
                Text('المنطقة: ${_areaController.text}'),
                Text('التخصص: $_selectedSpecialization'),
                Text(
                    'مواعيد العمل: ${_openingTimeController.text} - ${_closingTimeController.text}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetForm();
                },
                child: Text('موافق'),
              ),
            ],
          );
        },
      );
    }
  }

  void _resetForm() {
    setState(() {
      _storeNameController.clear();
      _addressController.clear();
      _areaController.clear();
      _specializationController.clear();
      _openingTimeController.clear();
      _closingTimeController.clear();
      _selectedGovernorate = null;
      _selectedSpecialization = null;
      _storeImage = null;
    });
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _specializationController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    super.dispose();
  }
}
