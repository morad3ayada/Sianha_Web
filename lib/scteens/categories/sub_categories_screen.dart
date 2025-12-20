import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/service_category_model.dart';
import '../models/service_sub_category_model.dart';
import '../models/report_model.dart';
import '../financial/categories_service.dart';

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  final CategoriesService _categoriesService = CategoriesService();
  final ImagePicker _picker = ImagePicker();
  
  List<ServiceSubCategoryModel> _subCategories = [];
  List<ServiceCategoryModel> _mainCategories = []; // For dropdown
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final subCats = await _categoriesService.getSubCategories();
      final mainCats = await _categoriesService.getCategories();
      if (!mounted) return;
      setState(() {
        _subCategories = subCats;
        _mainCategories = mainCats;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تحميل البيانات: $e')),
      );
    }
  }

  Future<void> _showSubCategoryDialog([ServiceSubCategoryModel? subCategory]) async {
    final nameController = TextEditingController(text: subCategory?.name);
    final priceController = TextEditingController(text: subCategory?.price?.toString());
    final costController = TextEditingController(text: subCategory?.cost?.toString());
    final costRateController = TextEditingController(text: subCategory?.costRate?.toString());
    
    String? selectedCategoryId = subCategory?.serviceCategoryId;
    if (selectedCategoryId == null && _mainCategories.isNotEmpty) {
      // Don't auto-select if adding new, user must pick
    }

    dynamic selectedImage;
    bool isSaving = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(subCategory == null ? 'إضافة قسم فرعي جديد' : 'تعديل القسم الفرعي', 
            textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(selectedImage.path, height: 100, width: 100, fit: BoxFit.cover),
                  )
                else if (subCategory?.imageUrl != null && subCategory!.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(subCategory.imageUrl!, height: 100, width: 100, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 80, color: Colors.grey)),
                  )
                else
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.add_a_photo, size: 30, color: Colors.grey[600]),
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
                SizedBox(height: 15),
                // Main Category Dropdown
                DropdownButtonFormField<String>(
                  initialValue: selectedCategoryId,
                  hint: Text('اختر القسم الرئيسي'),
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  items: _mainCategories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat.id,
                      child: Text(cat.name ?? 'بدون اسم', textAlign: TextAlign.right),
                    );
                  }).toList(),
                  onChanged: (val) => setDialogState(() => selectedCategoryId = val),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: nameController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'اسم القسم الفرعي',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'السعر',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: costController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'التكلفة',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                TextField(
                  controller: costRateController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cost Rate',
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
                      if (nameController.text.isEmpty || selectedCategoryId == null) {
                         if (context.mounted) {
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('برجاء إكمال البيانات المطلوبة')));
                         }
                         return;
                      }
                      setDialogState(() => isSaving = true);
                      try {
                        final price = double.tryParse(priceController.text) ?? 0;
                        final cost = double.tryParse(costController.text) ?? 0;
                        final costRate = double.tryParse(costRateController.text) ?? 0;
                        
                        if (subCategory == null) {
                          await _categoriesService.createSubCategory(
                            name: nameController.text,
                            serviceCategoryId: selectedCategoryId!,
                            price: price,
                            cost: cost,
                            costRate: costRate,
                            imageFile: selectedImage,
                          );
                        } else {
                          await _categoriesService.updateSubCategory(
                            id: subCategory.id!,
                            name: nameController.text,
                            serviceCategoryId: selectedCategoryId!,
                            price: price,
                            cost: cost,
                            costRate: costRate,
                            imageUrl: subCategory.imageUrl,
                            imageFile: selectedImage,
                          );
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                          _fetchData();
                        }
                      } catch (e) {
                        setDialogState(() => isSaving = false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('خطأ في الحفظ: $e')),
                          );
                        }
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

  Future<void> _deleteSubCategory(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تأكيد الحذف', textAlign: TextAlign.center),
        content: Text('هل أنت متأكد من حذف هذا القسم الفرعي؟', textAlign: TextAlign.center),
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
        await _categoriesService.deleteSubCategory(id);
        _fetchData();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطأ في الحذف: $e')),
          );
        }
      }
    }
  }

  Future<void> _showFeedbackDialog(String subCategoryId, String subCategoryName) async {
    showDialog(
      context: context,
      builder: (context) => FutureBuilder(
        future: Future.wait([
          _categoriesService.getSubCategoryFeedbacks(subCategoryId),
          _categoriesService.getSubCategoryFeedbackAvg(subCategoryId),
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
                Text('تقييمات: $subCategoryName', style: TextStyle(fontWeight: FontWeight.bold)),
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
        title: Text('الأقسام الفرعية', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.yellow[700],
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchData,
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
                  onPressed: () => _showSubCategoryDialog(),
                  icon: Icon(Icons.add),
                  label: Text('إضافة قسم فرعي جديد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.yellow[800],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                Text(
                  'إجمالي الأقسام الفرعية: ${_subCategories.length}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading 
              ? Center(child: CircularProgressIndicator(color: Colors.yellow[700]))
              : _subCategories.isEmpty
                ? Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.subdirectory_arrow_right, size: 80, color: Colors.grey[300]),
                      SizedBox(height: 10),
                      Text('لا توجد أقسام فرعية حالياً', style: TextStyle(color: Colors.grey[500])),
                    ],
                  ))
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _subCategories.length,
                    itemBuilder: (context, index) {
                      final subCat = _subCategories[index];
                      // Find main category name
                      final mainCatName = _mainCategories.firstWhere(
                        (c) => c.id == subCat.serviceCategoryId,
                        orElse: () => ServiceCategoryModel(name: 'قسم غير معروف'),
                      ).name;

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
                              child: subCat.imageUrl != null && subCat.imageUrl!.isNotEmpty
                                ? Image.network(subCat.imageUrl!, fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.subdirectory_arrow_right, color: Colors.yellow[700]))
                                : Icon(Icons.subdirectory_arrow_right, color: Colors.yellow[700]),
                            ),
                          ),
                          title: Text(subCat.name ?? 'بدون اسم', 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.right),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('القسم: $mainCatName', style: TextStyle(color: Colors.blue[800], fontSize: 13)),
                              Text('السعر: ${subCat.price} | التكلفة: ${subCat.cost}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.rate_review_outlined, color: Colors.amber[700]),
                                    tooltip: 'التقييمات',
                                    onPressed: () => _showFeedbackDialog(subCat.id!, subCat.name ?? ''),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit_outlined, color: Colors.blue[400]),
                                    onPressed: () => _showSubCategoryDialog(subCat),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                                    onPressed: () => _deleteSubCategory(subCat.id!),
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
