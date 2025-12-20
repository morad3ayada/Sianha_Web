
import 'package:flutter/material.dart';
import '../../financial/financial_service.dart';
import '../../models/order_model.dart';
import 'rejected/rejected_orders_screen.dart';
import 'completed/completed_orders_screen.dart';
import 'orders_list_screen.dart';
import 'pending_order_card.dart';
import '../../models/user_model.dart';

class OrdersMainScreen extends StatefulWidget {
  final String governorate;
  final String center;

  OrdersMainScreen({required this.governorate, required this.center});

  @override
  _OrdersMainScreenState createState() => _OrdersMainScreenState();
}

class _OrdersMainScreenState extends State<OrdersMainScreen> {
  final FinancialService _financialService = FinancialService();
  
  List<OrderModel> _allOrders = [];
  List<OrderModel> _activeOrders = [];
  List<OrderModel> _completedOrders = [];
  List<OrderModel> _rejectedOrders = [];
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final orders = await _financialService.getAllOrders();
      print("Fetched ${orders.length} orders"); // Debug print

      setState(() {
        _allOrders = orders;
        
        // 1. Current Orders (All Existing Orders as per user request)
        // _activeOrders variable now represents "Current" which equals ALL
        _activeOrders = orders; 
        
        // 2. In Progress (Status == 3)
        // Assuming user meant separate logic for this button
         
        _completedOrders = orders.where((o) => o.orderStatus == 4).toList();
        _rejectedOrders = orders.where((o) => o.orderStatus == 6).toList();
        
        _isLoading = false;
      });
    } catch (e) {
      print("Error in _fetchOrders: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(backgroundColor: Colors.yellow[700]),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final inProgressCount = _allOrders.where((o) => o.orderStatus == 3).length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('تتبع الطلبات - ${widget.center}',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.yellow[700],
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSmallScreen = constraints.maxHeight < 700;
          final bool isVerySmallScreen = constraints.maxHeight < 600;

          return Column(
            children: [
              // 🎯 البطاقة الإحصائية العلوية
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.yellow[700]!, Colors.yellow[600]!],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMainStat('${_allOrders.length}', 'إجمالي الطلبات', Icons.assignment, isSmallScreen),
                    _buildMainStat('$inProgressCount', 'قيد التنفيذ', Icons.timelapse, isSmallScreen),
                    _buildMainStat('${_completedOrders.length}', 'مكتملة', Icons.task_alt, isSmallScreen),
                  ],
                ),
              ),

              // 🚀 الأزرار (2 صفوف)
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                       // Row 1: Current & In Progress
                       Row(
                         children: [
                            _buildModernButton(
                              context,
                              'كل الطلبات', // "Current" as "All" per user
                              '${_allOrders.length}',
                              Icons.list,
                              Colors.blue,
                              'الكل',
                              OrdersListScreen(title: "كل الطلبات", orders: _allOrders, themeColor: Colors.blue),
                              isSmallScreen,
                              isVerySmallScreen,
                            ),
                            SizedBox(width: 8),
                            _buildModernButton(
                              context,
                              'قيد التنفيذ',
                              '$inProgressCount',
                              Icons.engineering,
                              Colors.orange,
                              'جار العمل',
                              OrdersListScreen(title: "قيد التنفيذ", orders: _allOrders.where((o) => o.orderStatus == 3).toList(), themeColor: Colors.orange),
                              isSmallScreen,
                              isVerySmallScreen,
                            ),
                         ],
                       ),
                       SizedBox(height: 8),
                       // Row 2: Completed & Rejected
                       Row(
                         children: [
                            _buildModernButton(
                              context,
                              'منتهية',
                              '${_completedOrders.length}',
                              Icons.check_circle,
                              Colors.green,
                              'مكتملة',
                              CompletedOrdersScreen(allOrders: _completedOrders),
                              isSmallScreen,
                              isVerySmallScreen,
                            ),
                            SizedBox(width: 8),
                            _buildModernButton(
                              context,
                              'مرفوضة',
                              '${_rejectedOrders.length}',
                              Icons.cancel,
                              Colors.red,
                              'مرفوضة',
                              RejectedOrdersMainScreen(rejectedOrders: _rejectedOrders),
                              isSmallScreen,
                              isVerySmallScreen,
                            ),
                         ],
                       ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: isSmallScreen ? 8 : 12),
              
              // Pending Orders List (Replaces Map Placeholder)
               Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -2))]
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text("طلبات قيد الانتظار (${_allOrders.where((o) => o.orderStatus == 0).length})", 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      Expanded(
                        child: _allOrders.where((o) => o.orderStatus == 0).isEmpty 
                        ? Center(child: Text("لا توجد طلبات جديدة"))
                        : ListView.builder(
                            itemCount: _allOrders.where((o) => o.orderStatus == 0).length,
                            itemBuilder: (context, index) {
                              final order = _allOrders.where((o) => o.orderStatus == 0).toList()[index];
                              return PendingOrderCard(
                                order: order,
                                onShowTechnicians: () => _showTechniciansDialog(context, order),
                                onAssign: () {
                                  // Assign logic
                                },
                              );
                            },
                          ),
                      ),
                    ],
                  ),
                )
               )

            ],
          );
        },
      ),
    );
  }

  void _showTechniciansDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("اختيار فني"),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: FutureBuilder<List<UserModel>>(
              future: _financialService.getTechnicians(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        SizedBox(height: 8),
                        Text("حدث خطأ في تحميل الفنيين", style: TextStyle(color: Colors.red)),
                        SizedBox(height: 4),
                        Text("${snapshot.error}", style: TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("لا يوجد فنيين متاحين"));
                }

                // Filter Technicians
                final allTechs = snapshot.data!;
                final matchingTechs = allTechs.where((tech) {
                  // Normalize Arabic strings (trim spaces)
                  final techGov = tech.governorateName?.trim();
                  final orderGov = order.governorateName?.trim();
                  
                  final techArea = tech.areaName?.trim();
                  final orderArea = order.areaName?.trim();
                  
                  final orderCategory = order.serviceCategoryName?.trim();
                  final techCategories = tech.categories?.map((c) => c.trim()).toList() ?? [];
                  
                  // Match conditions
                  final isGovMatch = techGov != null && 
                                     orderGov != null && 
                                     techGov == orderGov;
                  
                  final isAreaMatch = techArea != null && 
                                      orderArea != null && 
                                      techArea == orderArea;
                  
                  final isCategoryMatch = orderCategory != null && 
                                          techCategories.contains(orderCategory);
                  
                  return isGovMatch && isAreaMatch && isCategoryMatch;
                }).toList();

                if (matchingTechs.isEmpty) {
                  return Center(
                    child: Text(
                      "لا يوجد فنيين مطابقين لهذا الطلب\n"
                      "(المحافظة: ${order.governorateName ?? 'غير محدد'}, "
                      "المنطقة: ${order.areaName ?? 'غير محدد'}, "
                      "التخصص: ${order.serviceCategoryName ?? 'غير محدد'})",
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: matchingTechs.length,
                  itemBuilder: (context, index) {
                    final tech = matchingTechs[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.yellow[700],
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          tech.fullName ?? "بدون اسم",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text("ID: ${tech.technicianId ?? 'غير متوفر'}"),
                            if (tech.categories != null && tech.categories!.isNotEmpty)
                              Text("التخصصات: ${tech.categories!.join(', ')}"),
                          ],
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text("تعيين"),
                          onPressed: () {
                            Navigator.pop(context); // Close technician list dialog
                            _showAssignmentConfirmationDialog(context, order, tech);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text("إغلاق"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  void _showAssignmentConfirmationDialog(BuildContext context, OrderModel order, UserModel tech) {
    final TextEditingController reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.assignment_ind, color: Colors.yellow[700], size: 28),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "تأكيد تعيين الفني",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Technician Info Card
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.yellow[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.yellow[700]!, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.yellow[700], size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tech.fullName ?? "بدون اسم",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        "ID: ${tech.technicianId ?? 'غير متوفر'}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      if (tech.categories != null && tech.categories!.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          "التخصصات: ${tech.categories!.join(', ')}",
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Reason TextField
                Text(
                  "ملاحظات (اختياري):",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "مثال: يرجى التوجه في أسرع وقت",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.yellow[700]!, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: Text("إلغاء"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text("تأكيد التعيين", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () async {
                if (tech.technicianId == null || order.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("بيانات غير مكتملة (Technician ID مفقود)"))
                  );
                  return;
                }

                try {
                  // Save ScaffoldMessenger reference before closing dialog
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  
                  Navigator.pop(context); // Close confirmation dialog
                  
                  // Show loading
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 16),
                          Text("جاري تعيين الفني..."),
                        ],
                      ),
                      duration: Duration(seconds: 30),
                    ),
                  );
                  
                  // Call reassign API
                  
                  if (tech.technicianId == null) {
                    throw Exception("Technician ID missing");
                  }

                  await _financialService.reassignOrder(
                    order.id!,
                    tech.technicianId!,
                    reason: reasonController.text.trim().isNotEmpty 
                        ? reasonController.text.trim() 
                        : null,
                  );
                  
                  // Hide loading and show success
                  scaffoldMessenger.hideCurrentSnackBar();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text("تم تعيين الفني بنجاح!"),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 3),
                    ),
                  );
                  
                  // Refresh orders
                  _fetchOrders();
                  
                } catch (e) {
                  // Extract error message
                  String errorMessage = "فشل تعيين الفني";
                  if (e.toString().contains("Technician not found")) {
                    errorMessage = "الفني غير موجود في النظام";
                  } else if (e.toString().contains("Order not found")) {
                    errorMessage = "الطلب غير موجود";
                  } else {
                    errorMessage = "فشل تعيين الفني: ${e.toString().replaceAll('Exception: ', '')}";
                  }
                  
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  scaffoldMessenger.hideCurrentSnackBar();
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 5),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // --- Helpers ---

  Widget _buildMainStat(String count, String label, IconData icon, bool isSmallScreen) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: isSmallScreen ? 20 : 28),
        SizedBox(height: 5),
        Text(count, style: TextStyle(fontSize: isSmallScreen ? 18 : 22, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: isSmallScreen ? 10 : 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildModernButton(
    BuildContext context,
    String title,
    String count,
    IconData icon,
    Color color,
    String status,
    Widget targetScreen,
    bool isSmallScreen,
    bool isVerySmallScreen,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => targetScreen));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)],
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Icon(icon, color: color, size: 24),
               SizedBox(height: 5),
               Text(count, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
               Text(title, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
