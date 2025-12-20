import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import '../../core/api/api_constants.dart';
import '../../core/api/api_service.dart';

class MerchantProfileScreen extends StatefulWidget {
  final String userId;
  final String? merchantId;

  const MerchantProfileScreen({Key? key, required this.userId, this.merchantId}) : super(key: key);

  @override
  _MerchantProfileScreenState createState() => _MerchantProfileScreenState();
}

class _MerchantProfileScreenState extends State<MerchantProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _merchantData;
  String? _errorMessage;
  bool _isTogglingApproval = false;

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
        setState(() {
          _merchantData = json.decode(response.body);
          print("---------------- MERCHANT PROFILE DATA ----------------");
          print(_merchantData);
          print("-----------------------------------------------------");
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

  Future<void> _toggleApproval() async {
    print("Button Clicked: _toggleApproval");
    
    // Use merchantId from widget or profile data
    String? merchantId = widget.merchantId ?? _merchantData?['merchantId'];
    
    // Check fallback if still null
    if (merchantId == null && _merchantData != null) {
      print("Warning: 'merchantId' not found in params or profile. Trying 'id' from profile...");
      merchantId = _merchantData?['id'];
    }
    
    print("Merchant ID to use: $merchantId");
    
    if (merchantId == null) {
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لا يوجد معرف تاجر (id or merchantId)'),
          backgroundColor: Colors.red,
        ),
      );
      }
      return;
    }
    
    if (_isTogglingApproval) {
       return;
    }
    if (merchantId == null) {
      print("Warning: 'merchantId' not found. Trying 'id'...");
      merchantId = _merchantData?['id'];
    }
    
    print("Merchant ID to use: $merchantId");
    
    if (merchantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لا يوجد معرف تاجر (id or merchantId)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    bool currentApprovalStatus = _merchantData?['approved'] ?? false;
    String action = currentApprovalStatus ? 'unapprove' : 'approve';
    
    setState(() {
      _isTogglingApproval = true;
    });

    try {
      final response = await ApiService().post(
        '${ApiConstants.merchants}/$merchantId/$action',
        hasToken: true,
      );

      if (response.statusCode == 200) {
        // Refresh profile data
        await _fetchProfile();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(currentApprovalStatus ? 'تم إلغاء الموافقة بنجاح' : 'تمت الموافقة بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل تحديث حالة الموافقة: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTogglingApproval = false;
        });
      }
    }
  }

  String? _getFullUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    
    String base = ApiConstants.baseUrl;
    if (base.endsWith('/')) base = base.substring(0, base.length - 1);
    if (path.startsWith('/')) path = path.substring(1);
    
    return '$base/$path';
  }

  Future<void> _openInNewTab(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Error launching URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ملف التاجر"),
        backgroundColor: Colors.yellow[800],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
              : _merchantData == null
                  ? Center(child: Text("لا توجد بيانات"))
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildProfileHeader(),
                          SizedBox(height: 20),
                          _buildStatusCard(),
                          SizedBox(height: 20),
                          _buildInfoSection(),
                          SizedBox(height: 20),
                          _buildWorkHoursSection(),
                          SizedBox(height: 20),
                          _buildDocumentsSection(),
                          SizedBox(height: 20),
                          _buildShopImagesSection(),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildProfileHeader() {
    final String name = _merchantData?['fullName'] ?? 'غير معروف';
    final String shopName = _merchantData?['shopName'] ?? '';
    final String? profileImageUrl = _getFullUrl(_merchantData?['profileImageUrl']);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
                onTap: profileImageUrl != null ? () => _openInNewTab(profileImageUrl) : null,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.yellow[100],
                  backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl) : null,
                  child: profileImageUrl == null 
                      ? Icon(Icons.store, size: 50, color: Colors.yellow[800]) 
                      : null,
                ),
            ),
            SizedBox(height: 15),
            Text(
              name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (shopName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  shopName,
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ),
              // Rating
              if (_merchantData?['rating'] != null)
              Padding(
                 padding: const EdgeInsets.only(top: 8.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.star, color: Colors.amber, size: 20),
                     SizedBox(width: 4),
                     Text("${_merchantData?['rating'] ?? 0.0}", style: TextStyle(fontSize: 16)),
                     Text(" (${_merchantData?['reviewCount'] ?? 0} تقييم)", style: TextStyle(color: Colors.grey)),
                   ],
                 ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusCard() {
      bool isBlocked = _merchantData?['isBlocked'] ?? false;
      bool approved = _merchantData?['approved'] ?? false;
      
      return Card(
        color: isBlocked ? Colors.red[50] : (approved ? Colors.green[50] : Colors.orange[50]),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatusItem("الحالة", isBlocked ? "محظور" : "نشط", isBlocked ? Colors.red : Colors.green),
                  _buildStatusItem("الموافقة", approved ? "تمت الموافقة" : "قيد المراجعة", approved ? Colors.green : Colors.orange),
                ],
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isTogglingApproval ? null : _toggleApproval,
                  icon: _isTogglingApproval 
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(approved ? Icons.cancel : Icons.check_circle, size: 20),
                  label: Text(
                    _isTogglingApproval 
                        ? "جاري التحديث..."
                        : (approved ? "إلغاء الموافقة" : "الموافقة على التاجر"),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: approved ? Colors.orange[700] : Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
  
  Widget _buildStatusItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.phone, "رقم الهاتف", _merchantData?['phoneNumber'] ?? 'غير متوفر'),
            Divider(),
            _buildInfoRow(Icons.email, "البريد الإلكتروني", _merchantData?['email'] ?? 'غير متوفر'),
            Divider(),
            _buildInfoRow(Icons.location_on, "العنوان", 
              "${_merchantData?['governorateName'] ?? ''} - ${_merchantData?['areaName'] ?? ''}"),
             Divider(),
            _buildInfoRow(Icons.category, "نوع المتجر", _merchantData?['shopType'] ?? 'عام'),
             Divider(),
             
             // Categories
             if (_merchantData?['categories'] != null)
               _buildListRow(Icons.grid_view, "التصنيفات", List<String>.from(_merchantData?['categories'])),
               
             if (_merchantData?['subCategories'] != null && (_merchantData?['subCategories'] as List).isNotEmpty)
                Divider(),
             if (_merchantData?['subCategories'] != null && (_merchantData?['subCategories'] as List).isNotEmpty)
                _buildListRow(Icons.subdirectory_arrow_right, "الفئات الفرعية", List<String>.from(_merchantData?['subCategories'])),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWorkHoursSection() {
      String? from = _merchantData?['workHoursFrom'];
      String? to = _merchantData?['workHoursTo'];
      if (from == null && to == null) return SizedBox.shrink();

      return Card(
          child: ListTile(
              leading: Icon(Icons.access_time, color: Colors.blue),
              title: Text("ساعات العمل"),
              subtitle: Text("من: ${from ?? '-'}  إلى: ${to ?? '-'}"),
          ),
      );
  }

  Widget _buildDocumentsSection() {
      final String? idFront = _getFullUrl(_merchantData?['nationalIdFrontUrl']);
      final String? idBack = _getFullUrl(_merchantData?['nationalIdBackUrl']);
      final String? criminalRecord = _getFullUrl(_merchantData?['criminalRecordUrl']);
      final String? license = _getFullUrl(_merchantData?['commercialRegisterUrl']);

      if (idFront == null && idBack == null && criminalRecord == null && license == null) return SizedBox.shrink();

      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("المستندات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                      if (idFront != null) _buildDocButton("بطاقة (أمام)", idFront, Icons.credit_card),
                      if (idBack != null) _buildDocButton("بطاقة (خلف)", idBack, Icons.credit_card),
                      if (criminalRecord != null) _buildDocButton("فيش جنائي", criminalRecord, Icons.gavel),
                      if (license != null) _buildDocButton("سجل تجاري", license, Icons.assignment),
                  ],
              )
          ],
      );
  }
  
  Widget _buildDocButton(String label, String url, IconData icon) {
      return ElevatedButton.icon(
          onPressed: () => _openInNewTab(url),
          icon: Icon(icon, size: 18),
          label: Text(label),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue[800],
              elevation: 2,
          ),
      );
  }

  Widget _buildShopImagesSection() {
      List<dynamic> images = _merchantData?['shopImages'] ?? [];
      
      if (images.isEmpty) return SizedBox.shrink();

      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
               Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("صور المتجر", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Container(
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                          String url = _getFullUrl(images[index]) ?? '';
                          return Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                  onTap: () => _openInNewTab(url),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                          url, 
                                          width: 120, 
                                          height: 120, 
                                          fit: BoxFit.cover,
                                          errorBuilder: (c, e, s) => Container(
                                              width: 120, 
                                              color: Colors.grey[200], 
                                              child: Icon(Icons.broken_image)
                                          ),
                                      ),
                                  ),
                              ),
                          );
                      }
                  ),
              )
          ],
      );
  }


  Widget _buildListRow(IconData icon, String label, List<String> items) {
       return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.yellow[800]),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                Wrap(
                    spacing: 5,
                    children: items.map((i) => Chip(
                        label: Text(i, style: TextStyle(fontSize: 12)),
                        backgroundColor: Colors.yellow[50], 
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.yellow[800]),
          SizedBox(width: 15),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          )),
        ],
      ),
    );
  }
}
