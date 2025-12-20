import 'package:flutter/material.dart';
import 'dart:convert';
import '../../core/api/api_constants.dart';
import '../../core/api/api_service.dart';
import 'governorate_model.dart';

class GovernoratesScreen extends StatefulWidget {
  @override
  _GovernoratesScreenState createState() => _GovernoratesScreenState();
}

class _GovernoratesScreenState extends State<GovernoratesScreen> {
  List<Governorate> governorates = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchGovernorates();
  }

  Future<void> _fetchGovernorates() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService().get(
        ApiConstants.governorates,
        hasToken: true,
      );

      if (response.statusCode == 200) {
        // Log the response to debug structure
        print('Governorates Response: ${response.body}');
        
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          governorates = data.map((json) => Governorate.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "فشل تحميل البيانات: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "حدث خطأ: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _addGovernorate(String name) async {
    try {
      final response = await ApiService().post(
        ApiConstants.governorates,
        body: {'name': name},
        hasToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم إضافة المحافظة بنجاح')),
        );
        _fetchGovernorates();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل الإضافة: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    }
  }

  Future<void> _updateGovernorate(String id, String name) async {
    try {
      // For PUT requests we might need a specific PUT method in ApiService or use http directly if not available.
      // Assuming ApiService has put or we can add it, but for now let's check ApiService.
      // Since ApiService only had get/post in previous view, I'll stick to using the existing pattern or check if I need to add PUT.
      // Wait, the user specifically asked for "curl -X 'PUT'".
      // I should update ApiService to support PUT if it doesn't.
      
      // Let's assume for this step I'll implement it here or update ApiService next.
      // I will add a 'put' method to ApiService in the next step if it's missing.
      // For now I'll use a placeholder or assume it exists to keep this file complete.
      
      final response = await ApiService().put(
        '${ApiConstants.governorates}/$id',
        {'id': id, 'name': name},
        hasToken: true,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تعديل المحافظة بنجاح')),
        );
        _fetchGovernorates();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل التعديل: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    }
  }

  Future<void> _deleteGovernorate(String id) async {
    try {
      final response = await ApiService().delete(
        '${ApiConstants.governorates}/$id',
        hasToken: true,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حذف المحافظة بنجاح')),
        );
        _fetchGovernorates();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل الحذف: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    }
  }

  void _showAddEditDialog({Governorate? governorate}) {
    final TextEditingController nameController = TextEditingController(
      text: governorate?.name ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(governorate == null ? 'إضافة محافظة' : 'تعديل محافظة'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: 'اسم المحافظة'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                if (governorate == null) {
                  _addGovernorate(nameController.text);
                } else {
                  _updateGovernorate(governorate.id, nameController.text);
                }
                Navigator.pop(context);
              }
            },
            child: Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف محافظة "$name"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteGovernorate(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة المحافظات'),
        backgroundColor: Colors.yellow[700],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchGovernorates,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddEditDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchGovernorates,
                        child: Text("إعادة المحاولة"),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: governorates.length,
                  itemBuilder: (context, index) {
                    final gov = governorates[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.yellow[100],
                          child: Icon(Icons.location_city, color: Colors.yellow[800]),
                        ),
                        title: Text(gov.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _showAddEditDialog(governorate: gov),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteConfirmDialog(gov.id, gov.name),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
