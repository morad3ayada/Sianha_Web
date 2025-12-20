// technician_profile.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../core/api/api_constants.dart';
import '../../core/api/api_service.dart';
import '/Total/MessageScreen.dart';
import '/Total/PermanentBanScreen.dart';
import '/Total/TemporaryBanScreen.dart';
import '/Total/Tiypscreen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class TechnicianProfile extends StatefulWidget {
  final String userId;
  final String technicianId;

  TechnicianProfile({
    required this.userId,
    required this.technicianId,
  });

  @override
  _TechnicianProfileState createState() => _TechnicianProfileState();
}

class _TechnicianProfileState extends State<TechnicianProfile> {
  Map<String, dynamic>? technician;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService().get(
        '${ApiConstants.users}/${widget.userId}/profile',
        hasToken: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          technician = data;
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

  Future<void> _toggleApproval(bool newValue) async {
    final currentApproval = technician!['approved'] ?? false;
    
    // Optimistically update UI
    setState(() {
      technician!['approved'] = newValue;
    });

    try {
      final endpoint = newValue 
          ? '${ApiConstants.technicians}/${widget.technicianId}/approve'
          : '${ApiConstants.technicians}/${widget.technicianId}/unapprove';
      
      final response = await ApiService().post(
        endpoint,
        body: {},
        hasToken: true,
      );

      if (response.statusCode != 200) {
        // Revert on failure
        setState(() {
          technician!['approved'] = currentApproval;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل تحديث حالة الموافقة'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newValue ? 'تمت الموافقة بنجاح' : 'تم إلغاء الموافقة'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Revert on error
      setState(() {
        technician!['approved'] = currentApproval;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("ملف الفني"), backgroundColor: Colors.yellow[800]),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text("ملف الفني"), backgroundColor: Colors.yellow[800]),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: _fetchProfile, child: Text("إعادة المحاولة"))
          ],
        )),
      );
    }

    if (technician == null) {
       return Scaffold(
        appBar: AppBar(title: Text("ملف الفني"), backgroundColor: Colors.yellow[800]),
        body: Center(child: Text("لا توجد بيانات")),
      );
    }

    // Prepare data handling nulls
    final String name = technician!['fullName'] ?? 'غير معروف';
    
    // Handle image URL - prepend base URL if relative path
    String imageUrl = technician!['profileImageUrl'] ?? technician!['image'] ?? '';
    if (imageUrl.isNotEmpty && imageUrl.startsWith('/')) {
      imageUrl = '${ApiConstants.baseUrl}$imageUrl';
    }
    final String image = imageUrl.isNotEmpty ? imageUrl : '';
    
    final String specialization = technician!['specialization'] ?? technician!['details'] ?? 'عام';
    final String phone = technician!['phoneNumber'] ?? '';
    final String address = "${technician!['governorateName'] ?? ''} - ${technician!['areaName'] ?? ''}";
    
    // Handle document URLs
    String? nationalIdFront = technician!['nationalIdFrontUrl'];
    if (nationalIdFront != null && nationalIdFront.startsWith('/')) {
      nationalIdFront = '${ApiConstants.baseUrl}$nationalIdFront';
    }
    
    String? nationalIdBack = technician!['nationalIdBackUrl'];
    if (nationalIdBack != null && nationalIdBack.startsWith('/')) {
      nationalIdBack = '${ApiConstants.baseUrl}$nationalIdBack';
    }
    
    String? criminalRecord = technician!['criminalRecordUrl'];
    if (criminalRecord != null && criminalRecord.startsWith('/')) {
      criminalRecord = '${ApiConstants.baseUrl}$criminalRecord';
    }
    
    // New fields from server
    final bool approved = technician!['approved'] ?? false;
    final List<dynamic> categories = technician!['categories'] ?? [];
    final List<dynamic> subCategories = technician!['subCategories'] ?? [];
    final String? workHoursFrom = technician!['workHoursFrom'];
    final String? workHoursTo = technician!['workHoursTo'];
    
    // Validating and parsing other fields if they exist in API or using defaults
    final String rating = (technician!['rating'] ?? 4.5).toString();
    final String completedJobs = (technician!['completedJobs'] ?? 0).toString();
    final String experience = technician!['experience'] ?? '0 سنوات';
    final String hourlyRate = technician!['hourlyRate'] ?? '0';
    
    // Format work hours
    String workHours = 'غير محدد';
    if (workHoursFrom != null && workHoursTo != null) {
      workHours = '$workHoursFrom - $workHoursTo';
    }
    // Handle multiple images from server
    final List<dynamic> imagesFromServer = technician!['shopImages'] ?? technician!['images'] ?? [];
    final List<String> imageUrls = [];
    
    // Add main image if exists
    if (image.isNotEmpty) {
      imageUrls.add(image);
    }
    
    // Add additional images from array
    for (var img in imagesFromServer) {
      String imgUrl = img is String ? img : (img['url'] ?? img['image'] ?? '');
      // Prepend base URL if relative path
      if (imgUrl.isNotEmpty && imgUrl.startsWith('/')) {
        imgUrl = '${ApiConstants.baseUrl}$imgUrl';
      }
      if (imgUrl.isNotEmpty && !imageUrls.contains(imgUrl)) {
        imageUrls.add(imgUrl);
      }
    }
    
    // If no images, add a default placeholder
    // Don't add placeholder - just show empty state if no images


    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "ملف الفني",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.yellow[800],
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 🖼️ Image Gallery
            if (imageUrls.isEmpty)
              // No images - show placeholder
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[400]!, width: 2),
                ),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.grey[400],
                ),
              )
            else if (imageUrls.length == 1)
              // Single image - show as circle
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  border: Border.all(
                    color: Colors.yellow[200]!,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              )
            else
              // Multiple images - show as horizontal gallery
              Column(
                children: [
                  Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 150,
                          margin: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(imageUrls[index]),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: Colors.yellow[200]!,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${imageUrls.length} صور",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 20),

            // 👤 معلومات الفني
            Text(
              name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.yellow[900],
              ),
            ),
            SizedBox(height: 8),
            Text(
              specialization,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),

            // 📊 بطاقة المعلومات
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInfoRow(
                        Icons.star, "التقييم", "$rating ⭐"),
                    _buildInfoRow(Icons.work, "المهام المكتملة",
                        "$completedJobs مهمة"),
                    _buildInfoRow(Icons.schedule, "سنوات الخبرة",
                        experience),
                    _buildInfoRow(Icons.attach_money, "سعر الساعة",
                        hourlyRate),
                    _buildInfoRow(
                        Icons.phone, "رقم الهاتف", phone),
                    _buildInfoRow(
                        Icons.location_on, "العنوان", address),
                    _buildInfoRow(
                        Icons.access_time, "ساعات العمل", workHours),
                    _buildInfoRow(
                      Icons.circle,
                      "الحالة",
                      (technician!["isActive"] == true) ? "نشط" : "غير نشط",
                      color:
                          (technician!["isActive"] == true) ? Colors.green : Colors.grey,
                    ),
                    _buildApprovalToggle(approved),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // 🏷️ Categories Section
            if (categories.isNotEmpty || subCategories.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (categories.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.category, color: Colors.yellow[700], size: 20),
                            SizedBox(width: 8),
                            Text(
                              "الفئات الرئيسية:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: categories.map((category) {
                            final categoryName = category is Map ? (category['name'] ?? category.toString()) : category.toString();
                            return Chip(
                              label: Text(
                                categoryName,
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              backgroundColor: Colors.yellow[700],
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            );
                          }).toList(),
                        ),
                      ],
                      if (categories.isNotEmpty && subCategories.isNotEmpty)
                        SizedBox(height: 16),
                      if (subCategories.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.subdirectory_arrow_right, color: Colors.yellow[600], size: 20),
                            SizedBox(width: 8),
                            Text(
                              "الفئات الفرعية:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: subCategories.map((subCategory) {
                            final subCategoryName = subCategory is Map ? (subCategory['name'] ?? subCategory.toString()) : subCategory.toString();
                            return Chip(
                              label: Text(
                                subCategoryName,
                                style: TextStyle(color: Colors.yellow[900], fontSize: 12),
                              ),
                              backgroundColor: Colors.yellow[100],
                              side: BorderSide(color: Colors.yellow[700]!),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),

            // 📄 Documents Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.folder_open, color: Colors.yellow[700], size: 20),
                        SizedBox(width: 8),
                        Text(
                          "المستندات:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow[900],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Display documents as clickable buttons
                    Column(
                      children: [
                        if (nationalIdFront != null && nationalIdFront.isNotEmpty)
                          _buildDocumentLinkButton(
                            "البطاقة الشخصية (الأمامية)",
                            nationalIdFront,
                            Icons.credit_card,
                          ),
                        if (nationalIdBack != null && nationalIdBack.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: _buildDocumentLinkButton(
                              "البطاقة الشخصية (الخلفية)",
                              nationalIdBack,
                              Icons.credit_card,
                            ),
                          ),
                        if (criminalRecord != null && criminalRecord.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: _buildDocumentLinkButton(
                              "السجل الجنائي",
                              criminalRecord,
                              Icons.description,
                            ),
                          ),
                      ],
                    ),
                    // Show message if no documents
                    if ((nationalIdFront == null || nationalIdFront.isEmpty) &&
                        (nationalIdBack == null || nationalIdBack.isEmpty) &&
                        (criminalRecord == null || criminalRecord.isEmpty))
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "لا توجد مستندات متاحة",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),

            // 📞 أزرار الاتصال الأساسية
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.phone, size: 20),
                    label: Text("اتصال"),
                    onPressed: () {
                      _makePhoneCall(phone);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.message, size: 20),
                    label: Text("رسالة"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MessageScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // ✏️ أزرار التعديل والإدارة
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.edit, size: 20),
                    label: Text("تعديل"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShopDetails(technician: technician ?? {}),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.assignment, size: 20),
                    label: Text("المهام"),
                    onPressed: () {
                      _showPreviousTasks(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // 🚫 أزرار الحظر
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.pause_circle_outline, size: 20),
                    label: Text("حظر مؤقت"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TemporaryBanScreen(technician: technician ?? {}),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.block, size: 20),
                    label: Text("حظر نهائي"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PermanentBanScreen(technician: technician ?? {}),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[800],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // 📋 أزرار إضافية
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.report, size: 18),
                    label: Text("تقرير"),
                    onPressed: () {
                      _generateReport(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[400]!),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.share, size: 18),
                    label: Text("مشاركة"),
                    onPressed: () {
                      _shareTechnicianProfile(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.yellow[700],
                      side: BorderSide(color: Colors.yellow[400]!),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value,
      {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color ?? Colors.yellow[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color ?? Colors.yellow[700],
              size: 18,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "$title:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.yellow[900],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalToggle(bool approved) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: approved ? Colors.green[100] : Colors.orange[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              approved ? Icons.verified : Icons.pending,
              color: approved ? Colors.green[700] : Colors.orange[700],
              size: 18,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "حالة الموافقة:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.yellow[900],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  approved ? "موافق عليه" : "قيد المراجعة",
                  style: TextStyle(
                    color: approved ? Colors.green[700] : Colors.orange[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 8),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: approved,
                    onChanged: _toggleApproval,
                    activeColor: Colors.green,
                    activeTrackColor: Colors.green[200],
                    inactiveThumbColor: Colors.orange,
                    inactiveTrackColor: Colors.orange[200],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) {
    print("الاتصال بالرقم: $phoneNumber");
  }

  void _showPreviousTasks(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("المهام السابقة"),
          content:
              Text("عرض قائمة المهام المنفذة من قبل ${technician?["fullName"] ?? ""}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إغلاق"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDocumentImageCard(String title, String url, IconData icon) {
    return InkWell(
      onTap: () => _showImagePreview(url),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.yellow[300]!, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image preview
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading document: $url');
                    return Container(
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, size: 40, color: Colors.grey[400]),
                          SizedBox(height: 8),
                          Text(
                            'فشل التحميل',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Label
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(icon, size: 16, color: Colors.yellow[700]),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentLinkButton(String title, String url, IconData icon) {
    return InkWell(
      onTap: () {
        // Open URL in new tab using dart:html for web
        if (kIsWeb) {
          // For web, use window.open
          html.window.open(url, '_blank');
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.yellow[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.yellow[300]!, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.yellow[700],
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.open_in_new,
              color: Colors.yellow[700],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(String title, String? url, IconData icon) {
    final bool hasDocument = url != null && url.isNotEmpty;
    
    return InkWell(
      onTap: hasDocument ? () => _showImagePreview(url) : null,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: hasDocument ? Colors.yellow[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasDocument ? Colors.yellow[300]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: hasDocument ? Colors.yellow[100] : Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: hasDocument ? Colors.yellow[700] : Colors.grey[500],
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: hasDocument ? Colors.black87 : Colors.grey[600],
                ),
              ),
            ),
            if (hasDocument)
              Icon(Icons.visibility, color: Colors.yellow[700], size: 20)
            else
              Text(
                "غير متوفر",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline, size: 60, color: Colors.red),
                            SizedBox(height: 16),
                            Text(
                              "فشل تحميل الصورة",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
                label: Text("إغلاق"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _generateReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("تقرير الفني"),
          content: Text("إنشاء تقرير مفصل عن أداء ${technician?["fullName"] ?? ""}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("تم إنشاء التقرير بنجاح")),
                );
              },
              child: Text("إنشاء التقرير"),
            ),
          ],
        );
      },
    );
  }

  void _shareTechnicianProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("مشاركة الملف"),
          content: Text("مشاركة ملف الفني ${technician?["fullName"] ?? ""}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("تم مشاركة الملف بنجاح")),
                );
              },
              child: Text("مشاركة"),
            ),
          ],
        );
      },
    );
  }
}

