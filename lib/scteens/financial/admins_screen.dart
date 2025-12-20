import 'package:flutter/material.dart';
import '../../core/api/api_constants.dart';
import '../../core/api/api_service.dart';
import '../models/admin_model.dart';
import '../financial/admins_service.dart';
import '../governorates/governorate_model.dart';
import '../areas/area_model.dart';
import 'dart:convert';

class AdminsScreen extends StatefulWidget {
  @override
  _AdminsScreenState createState() => _AdminsScreenState();
}

class _AdminsScreenState extends State<AdminsScreen> {
  final AdminsService _adminsService = AdminsService();
  final ApiService _apiService = ApiService();
  
  List<AdminModel> _admins = [];
  List<Governorate> _governorates = [];
  List<Area> _areas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _adminsService.getAdmins(),
        _fetchGovernorates(),
      ]);
      setState(() {
        _admins = results[0] as List<AdminModel>;
        _governorates = results[1] as List<Governorate>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في تحميل البيانات: $e')));
    }
  }

  Future<List<Governorate>> _fetchGovernorates() async {
    final response = await _apiService.get(ApiConstants.governorates);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Governorate.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> _fetchAreas(String governorateId) async {
    final response = await _apiService.get('${ApiConstants.areas}?governorateId=$governorateId');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _areas = data.map((json) => Area.fromJson(json)).toList();
      });
    }
  }

  Future<void> _showAddEditDialog([AdminModel? admin]) async {
    final fullNameController = TextEditingController(text: admin?.fullName);
    final phoneController = TextEditingController(text: admin?.phoneNumber);
    final emailController = TextEditingController(text: admin?.email);
    final addressController = TextEditingController(text: admin?.address);
    final passwordController = TextEditingController();
    
    String? selectedGovId = admin?.governorateId;
    String? selectedAreaId = admin?.areaId;
    bool isSaving = false;

    if (selectedGovId != null) {
      await _fetchAreas(selectedGovId);
    } else {
      _areas = [];
    }

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(admin == null ? 'إضافة مسؤول جديد' : 'تعديل بيانات المسؤول', 
            textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(fullNameController, 'الاسم بالكامل', Icons.person),
                _buildTextField(phoneController, 'رقم الهاتف', Icons.phone),
                _buildTextField(emailController, 'البريد الإلكتروني', Icons.email),
                if (admin == null) _buildTextField(passwordController, 'كلمة المرور', Icons.lock, obscure: true),
                _buildTextField(addressController, 'العنوان بالتفصيل', Icons.location_on),
                
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: selectedGovId,
                  decoration: InputDecoration(labelText: 'المحافظة', border: OutlineInputBorder()),
                  items: _governorates.map((g) => DropdownMenuItem(value: g.id, child: Text(g.name, textAlign: TextAlign.right))).toList(),
                  onChanged: (val) async {
                    if (val != null) {
                      setDialogState(() {
                        selectedGovId = val;
                        selectedAreaId = null;
                        _areas = [];
                      });
                      await _fetchAreas(val);
                      setDialogState(() {});
                    }
                  },
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: selectedAreaId,
                  decoration: InputDecoration(labelText: 'المنطقة', border: OutlineInputBorder()),
                  items: _areas.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name ?? '', textAlign: TextAlign.right))).toList(),
                  onChanged: (val) => setDialogState(() => selectedAreaId = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
            ElevatedButton(
              onPressed: isSaving ? null : () async {
                if (fullNameController.text.isEmpty || phoneController.text.isEmpty || (admin == null && passwordController.text.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('برجاء ملء البيانات الأساسية')));
                  return;
                }
                setDialogState(() => isSaving = true);
                try {
                  final data = {
                    if (admin != null) "id": admin.id,
                    "fullName": fullNameController.text,
                    "phoneNumber": phoneController.text,
                    "email": emailController.text,
                    if (admin == null) "password": passwordController.text,
                    "governorateId": selectedGovId,
                    "areaId": selectedAreaId,
                    "address": addressController.text,
                    if (admin != null) "isActive": admin.isActive,
                    if (admin != null) "isBlocked": admin.isBlocked,
                  };

                  if (admin == null) {
                    await _adminsService.createAdmin(data);
                  } else {
                    await _adminsService.updateAdmin(admin.id!, data);
                  }
                  Navigator.pop(context);
                  _fetchInitialData();
                } catch (e) {
                  setDialogState(() => isSaving = false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في الحفظ: $e')));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[700], foregroundColor: Colors.white),
              child: isSaving ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Future<void> _toggleStatus(AdminModel admin, {bool? active, bool? blocked}) async {
    try {
      final data = admin.toJson();
      if (active != null) data['isActive'] = active;
      if (blocked != null) data['isBlocked'] = blocked;
      
      await _adminsService.updateAdmin(admin.id!, data);
      _fetchInitialData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في التحديث: $e')));
    }
  }

  Future<void> _deleteAdmin(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف هذا المسؤول؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('إلغاء')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('حذف'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white)),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _adminsService.deleteAdmin(id);
        _fetchInitialData();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في الحذف: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('إدارة المسؤولين', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.yellow[700],
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.refresh, color: Colors.white), onPressed: _fetchInitialData),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.yellow[700], borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showAddEditDialog(),
                  icon: Icon(Icons.add),
                  label: Text('إضافة مسؤول'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.yellow[800]),
                ),
                Text('إجمالي المسؤولين: ${_admins.length}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: _isLoading 
              ? Center(child: CircularProgressIndicator(color: Colors.yellow[700]))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _admins.length,
                  itemBuilder: (context, index) {
                    final admin = _admins[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: CircleAvatar(backgroundColor: Colors.yellow[50], child: Icon(Icons.person, color: Colors.yellow[800])),
                        title: Text(admin.fullName ?? 'بدون اسم', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(admin.phoneNumber ?? ''),
                            Text(admin.email ?? '', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Wrap(
                              spacing: 8,
                              children: [
                                Chip(
                                  label: Text(admin.isActive ? 'نشط' : 'غير نشط', style: TextStyle(fontSize: 10, color: Colors.white)),
                                  backgroundColor: admin.isActive ? Colors.green : Colors.grey,
                                  padding: EdgeInsets.zero,
                                ),
                                Chip(
                                  label: Text(admin.isBlocked ? 'محظور' : 'غير محظور', style: TextStyle(fontSize: 10, color: Colors.white)),
                                  backgroundColor: admin.isBlocked ? Colors.red : Colors.blue,
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(admin.isActive ? Icons.toggle_on : Icons.toggle_off, color: admin.isActive ? Colors.green : Colors.grey),
                              tooltip: admin.isActive ? 'تعطيل' : 'تفعيل',
                              onPressed: () => _toggleStatus(admin, active: !admin.isActive),
                            ),
                            IconButton(
                              icon: Icon(admin.isBlocked ? Icons.lock : Icons.lock_open, color: admin.isBlocked ? Colors.red : Colors.blue),
                              tooltip: admin.isBlocked ? 'إلغاء الحظر' : 'حظر',
                              onPressed: () => _toggleStatus(admin, blocked: !admin.isBlocked),
                            ),
                            IconButton(icon: Icon(Icons.edit, color: Colors.orange), onPressed: () => _showAddEditDialog(admin)),
                            IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteAdmin(admin.id!)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
