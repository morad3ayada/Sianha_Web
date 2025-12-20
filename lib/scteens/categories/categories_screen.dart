import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/service_category_model.dart';
import '../models/report_model.dart';
import '../financial/categories_service.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoriesService _categoriesService = CategoriesService();
  final ImagePicker _picker = ImagePicker();
  
  List<ServiceCategoryModel> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final categories = await _categoriesService.getCategories();
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تحميل الأقسام: $e')),
      );
    }
  }

  Future<void> _showCategoryDialog([ServiceCategoryModel? category]) async {
    final nameController = TextEditingController(text: category?.name);
    final descController = TextEditingController(text: category?.description);
    dynamic selectedImage;
    bool isSaving = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(category == null ? 'إضافة قسم جديد' : 'تعديل القسم', 
            textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(selectedImage.path, height: 120, width: 120, fit: BoxFit.cover),
                  )
                else if (category?.imageUrl != null && category!.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(category.imageUrl!, height: 120, width: 120, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 100, color: Colors.grey)),
                  )
                else
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey[600]),
                  ),
                SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () async {
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setDialogState(() => selectedImage = image);
                    }
                  },
                  icon: Icon(Icons.photo_library),
                  label: Text('اختر صورة'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'اسم القسم',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: descController,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'الوصف',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('إلغاء', style: TextStyle(color: Colors.grey)),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isSaving ? null : () async {
                      if (nameController.text.isEmpty) {
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('برجاء ادخال اسم القسم')));
                         return;
                      }
                      setDialogState(() => isSaving = true);
                      try {
                        if (category == null) {
                          await _categoriesService.createCategory(
                            name: nameController.text,
                            description: descController.text,
                            imageFile: selectedImage,
                          );
                        } else {
                          await _categoriesService.updateCategory(
                            id: category.id!,
                            name: nameController.text,
                            description: descController.text,
                            imageUrl: category.imageUrl,
                            imageFile: selectedImage,
                          );
                        }
                        Navigator.pop(context);
                        _fetchCategories();
                      } catch (e) {
                        setDialogState(() => isSaving = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('خطأ في الحفظ: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: isSaving 
                      ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                      : Text('حفظ'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteCategory(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف', textAlign: TextAlign.center),
        content: Text('هل أنت متأكد من حذف هذا القسم؟', textAlign: TextAlign.center),
        actions: [
          Row(
            children: [
              Expanded(child: TextButton(onPressed: () => Navigator.pop(context, false), child: Text('إلغاء'))),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true), 
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('حذف', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _categoriesService.deleteCategory(id);
        _fetchCategories();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في الحذف: $e')),
        );
      }
    }
  }

  Future<void> _showFeedbackDialog(String categoryId, String categoryName) async {
    showDialog(
      context: context,
      builder: (context) => FutureBuilder(
        future: Future.wait([
          _categoriesService.getCategoryFeedbacks(categoryId),
          _categoriesService.getCategoryFeedbackAvg(categoryId),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.yellow[700]));
          }
          
          final List<ReportModel> feedbacks = snapshot.data?[0] ?? [];
          final double avg = snapshot.data?[1] ?? 0.0;

          return AlertDialog(
            title: Column(
              children: [
                Text('تقييمات: $categoryName', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(avg.toStringAsFixed(1), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber[800])),
                    SizedBox(width: 5),
                    Icon(Icons.star, color: Colors.amber, size: 24),
                  ],
                ),
              ],
            ),
            content: Container(
              width: double.maxFinite,
              height: 400,
              child: feedbacks.isEmpty
                ? Center(child: Text('لا توجد تقييمات بعد'))
                : ListView.builder(
                    itemCount: feedbacks.length,
                    itemBuilder: (context, index) {
                      final fb = feedbacks[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: List.generate(5, (i) => Icon(
                                      i < (fb.rate ?? 0) ? Icons.star : Icons.star_border,
                                      size: 16,
                                      color: Colors.amber,
                                    )),
                                  ),
                                  Text(fb.customerName ?? 'مستخدم', style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              if (fb.title != null && fb.title!.isNotEmpty) ...[
                                SizedBox(height: 5),
                                Text(fb.title!, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              ],
                              SizedBox(height: 5),
                              Text(fb.comment ?? '', textAlign: TextAlign.right),
                              SizedBox(height: 5),
                              Text(
                                fb.createdAt != null && fb.createdAt!.length >= 10 ? fb.createdAt!.substring(0, 10) : '',
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('إغلاق')),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('الأقسام الرئيسية', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.yellow[700],
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchCategories,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.yellow[700],
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showCategoryDialog(),
                  icon: Icon(Icons.add),
                  label: Text('إضافة قسم جديد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.yellow[800],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                Text(
                  'إجمالي الأقسام: ${_categories.length}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading 
              ? Center(child: CircularProgressIndicator(color: Colors.yellow[700]))
              : _categories.isEmpty
                ? Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category_outlined, size: 80, color: Colors.grey[300]),
                      SizedBox(height: 10),
                      Text('لا توجد أقسام حالياً', style: TextStyle(color: Colors.grey[500])),
                    ],
                  ))
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4)),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.yellow[50],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: cat.imageUrl != null && cat.imageUrl!.isNotEmpty
                                ? Image.network(cat.imageUrl!, fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.category, color: Colors.yellow[700]))
                                : Icon(Icons.category, color: Colors.yellow[700]),
                            ),
                          ),
                          title: Text(cat.name ?? 'بدون اسم', 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.right),
                          subtitle: Text(cat.description ?? '', 
                            style: TextStyle(color: Colors.grey[600]), textAlign: TextAlign.right, maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.rate_review_outlined, color: Colors.amber[700]),
                                    tooltip: 'التقييمات',
                                    onPressed: () => _showFeedbackDialog(cat.id!, cat.name ?? ''),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit_outlined, color: Colors.blue[400]),
                                    onPressed: () => _showCategoryDialog(cat),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                                    onPressed: () => _deleteCategory(cat.id!),
                                  ),
                                ],
                              ),
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
