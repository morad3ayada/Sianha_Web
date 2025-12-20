import 'package:flutter/material.dart';
import 'dart:convert';
import 'banned_technicians_screen.dart';
import 'banned_merchants_screen.dart';
import 'banned_customers_screen.dart';
import '../../core/api/api_service.dart';
import '../../core/api/api_constants.dart';

class BannedScreen extends StatefulWidget {
  @override
  _BannedScreenState createState() => _BannedScreenState();
}

class _BannedScreenState extends State<BannedScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _blockedUsers = [];
  int _blockedTechnicians = 0;
  int _blockedMerchants = 0;
  int _blockedCustomers = 0;

  @override
  void initState() {
    super.initState();
    _fetchBlockedUsers();
  }

  Future<void> _fetchBlockedUsers() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await ApiService().get(
        ApiConstants.users,
        hasToken: true,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> users = responseData['items'] ?? [];
        
        // Filter only blocked users
        _blockedUsers = users
            .where((user) => user['isBlocked'] == true)
            .map((user) => user as Map<String, dynamic>)
            .toList();

        // Count by role
        _blockedTechnicians = _blockedUsers.where((u) => u['role'] == 2).length; // Technician
        _blockedMerchants = _blockedUsers.where((u) => u['role'] == 3).length;   // Merchant
        _blockedCustomers = _blockedUsers.where((u) => u['role'] == 1).length;   // Customer

        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching blocked users: $e');
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل تحميل المحظورين: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _unblockUser(String userId, String userName) async {
    try {
      final response = await ApiService().post(
        '${ApiConstants.users}/$userId/unblock',
        hasToken: true,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم فك حظر $userName بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Refresh the list
        _fetchBlockedUsers();
      }
    } catch (e) {
      print('Error unblocking user: $e');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل فك الحظر: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getRoleText(int role) {
    switch (role) {
      case 0:
        return 'مدير';
      case 1:
        return 'عميل';
      case 2:
        return 'فني';
      case 3:
        return 'تاجر';
      case 4:
        return 'موصل';
      default:
        return 'غير معروف';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('المحظورين',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.yellow[700],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchBlockedUsers,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(children: [
              // البطاقات الإحصائية
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(children: [
                  Expanded(
                    child: _buildBannedCard(
                      'فنيين محظورين',
                      _blockedTechnicians.toString(),
                      Icons.engineering,
                      Colors.red,
                      () => _navigateToScreen(context, BannedTechniciansScreen()),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildBannedCard(
                      'تجار محظورين',
                      _blockedMerchants.toString(),
                      Icons.store,
                      Colors.yellow[800]!,
                      () => _navigateToScreen(context, BannedMerchantsScreen()),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildBannedCard(
                      'عملاء محظورين',
                      _blockedCustomers.toString(),
                      Icons.person,
                      Colors.purple,
                      () => _navigateToScreen(context, BannedCustomersScreen()),
                    ),
                  ),
                ]),
              ),

              // قائمة المحظورين
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('المحظورين (${_blockedUsers.length})',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: _blockedUsers.isEmpty
                                ? Center(
                                    child: Text(
                                      'لا يوجد مستخدمين محظورين',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: _blockedUsers.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(height: 1),
                                    itemBuilder: (context, index) {
                                      final user = _blockedUsers[index];
                                      return _buildUserCard(user);
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final String userId = user['id'] ?? '';
    final String fullName = user['fullName'] ?? 'غير معروف';
    final int role = user['role'] ?? -1;
    final String roleText = _getRoleText(role);

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.red[50],
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.block, color: Colors.red, size: 20),
      ),
      title: Text(
        '$fullName - $roleText',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        'محظور',
        style: TextStyle(fontSize: 12, color: Colors.red[600]),
      ),
      trailing: ElevatedButton.icon(
        onPressed: () => _showUnblockDialog(userId, fullName),
        icon: Icon(Icons.lock_open, size: 16),
        label: Text('فك الحظر'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    );
  }

  void _showUnblockDialog(String userId, String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('فك الحظر'),
        content: Text('هل تريد فك حظر $userName؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _unblockUser(userId, userName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text('فك الحظر'),
          ),
        ],
      ),
    );
  }

  Widget _buildBannedCard(String title, String value, IconData icon,
      Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              SizedBox(height: 8),
              Text(value,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.filter_list, size: 14, color: Colors.blue),
          SizedBox(width: 4),
          Text(
            'الكل',
            style: TextStyle(fontSize: 12, color: Colors.blue[700]),
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }

  void _showSecurityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إعدادات الأمان'),
        content: Text('هنا يمكنك تعديل إعدادات الأمان والحظر'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('سجل الحظر'),
        content: Text('عرض السجل الكامل لعمليات الحظر والإلغاء'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
