import 'package:flutter/material.dart';
import 'dart:convert';
import '../../core/api/api_constants.dart';
import '../../core/api/api_service.dart';
import 'area_model.dart';
import '../governorates/governorate_model.dart';

class AreasScreen extends StatefulWidget {
  @override
  _AreasScreenState createState() => _AreasScreenState();
}

class _AreasScreenState extends State<AreasScreen> {
  List<Area> areas = [];
  List<Governorate> governorates = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Fetch Areas and Governorates in parallel
      final results = await Future.wait([
        ApiService().get(ApiConstants.areas, hasToken: true),
        ApiService().get(ApiConstants.governorates, hasToken: true),
      ]);

      final areasResponse = results[0];
      final governoratesResponse = results[1];

      if (areasResponse.statusCode == 200 && governoratesResponse.statusCode == 200) {
        final List<dynamic> areasData = jsonDecode(areasResponse.body);
        final List<dynamic> govData = jsonDecode(governoratesResponse.body);

        setState(() {
          areas = areasData.map((json) => Area.fromJson(json)).toList();
          governorates = govData.map((json) => Governorate.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "فشل تحميل البيانات. المناطق: ${areasResponse.statusCode}, المحافظات: ${governoratesResponse.statusCode}";
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

  Future<void> _addArea(String name, String governorateId) async {
    try {
      final response = await ApiService().post(
        ApiConstants.areas,
        body: {
          'name': name,
          'governorateId': governorateId
        },
        hasToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم إضافة المنطقة بنجاح')),
        );
        _fetchData(); // Refresh list
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

  Future<void> _updateArea(String id, String name, String governorateId) async {
    try {
      final response = await ApiService().put(
        '${ApiConstants.areas}/$id',
        {
          'id': id,
          'name': name,
          'governorateId': governorateId
        },
        hasToken: true,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تعديل المنطقة بنجاح')),
        );
        _fetchData();
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

  Future<void> _deleteArea(String id) async {
    try {
      final response = await ApiService().delete(
        '${ApiConstants.areas}/$id',
        hasToken: true,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حذف المنطقة بنجاح')),
        );
        _fetchData();
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

  void _showAddEditDialog({Area? area}) {
    final TextEditingController nameController = TextEditingController(
      text: area?.name ?? '',
    );
    String? selectedGovernorateId = area?.governorateId;

    // Validation: make sure selected governorate still exists
    if (selectedGovernorateId != null && !governorates.any((g) => g.id == selectedGovernorateId)) {
      selectedGovernorateId = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Needed to update dropdown state inside dialog
          builder: (context, setState) {
            return AlertDialog(
              title: Text(area == null ? 'إضافة منطقة' : 'تعديل منطقة'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: 'اسم المنطقة'),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedGovernorateId,
                    decoration: InputDecoration(
                      labelText: 'المحافظة',
                      border: OutlineInputBorder(),
                    ),
                    items: governorates.map((gov) {
                      return DropdownMenuItem(
                        value: gov.id,
                        child: Text(gov.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGovernorateId = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && selectedGovernorateId != null) {
                      if (area == null) {
                        _addArea(nameController.text, selectedGovernorateId!);
                      } else {
                        _updateArea(area.id, nameController.text, selectedGovernorateId!);
                      }
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('يرجى ملء جميع الحقول')),
                      );
                    }
                  },
                  child: Text('حفظ'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _showDeleteConfirmDialog(String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف منطقة "$name"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteArea(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _getGovernorateName(String govId) {
    final gov = governorates.firstWhere((g) => g.id == govId, orElse: () => Governorate(id: '', name: 'غير معروف'));
    return gov.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة المناطق'),
        backgroundColor: Colors.yellow[800],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchData,
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
                        onPressed: _fetchData,
                        child: Text("إعادة المحاولة"),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: areas.length,
                  itemBuilder: (context, index) {
                    final area = areas[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.yellow[100],
                          child: Icon(Icons.map, color: Colors.yellow[800]),
                        ),
                        title: Text(area.name),
                        subtitle: Text('المحافظة: ${_getGovernorateName(area.governorateId)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showAddEditDialog(area: area),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteConfirmDialog(area.id, area.name),
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
