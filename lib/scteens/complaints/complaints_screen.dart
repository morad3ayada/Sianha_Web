import 'package:flutter/material.dart';
import '../financial/financial_service.dart';
import '../models/order_model.dart';

class ComplaintsScreen extends StatefulWidget {
  @override
  _ComplaintsScreenState createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final FinancialService _financialService = FinancialService();
  List<OrderModel> _complaints = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchComplaints();
  }

  Future<void> _fetchComplaints() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    List<OrderModel> complaintsFromOrders = [];
    List<OrderModel> allReports = [];
    String? ordersError;
    String? reportsError;

    // Fetch from Orders endpoint
    try {
      print("=== Fetching from Orders API ===");
      final allOrders = await _financialService.getAllOrders();
      complaintsFromOrders = allOrders.where((order) => order.address == "شكوي من الخدمة").toList();
      print("✓ Orders fetched successfully: ${complaintsFromOrders.length} complaints found");
    } catch (e) {
      ordersError = "خطأ في Orders: $e";
      print("✗ Error fetching orders: $e");
    }

    // Fetch from Reports endpoint
    try {
      print("=== Fetching from Reports API ===");
      allReports = await _financialService.getReports();
      print("✓ Reports fetched successfully: ${allReports.length} reports found");
    } catch (e) {
      reportsError = "خطأ في Reports: $e";
      print("✗ Error fetching reports: $e");
    }

    // Combine both lists
    final combinedComplaints = [...complaintsFromOrders, ...allReports];
    
    setState(() {
      _complaints = combinedComplaints;
      _isLoading = false;
      
      // Set error message only if both failed
      if (ordersError != null && reportsError != null) {
        _errorMessage = "فشل تحميل البيانات من كلا المصدرين:\n$ordersError\n$reportsError";
      } else if (ordersError != null || reportsError != null) {
        // Partial error - show warning but still display available data
        _errorMessage = null; // Don't block the UI
        print("⚠ Partial data loaded: ${ordersError ?? reportsError}");
      }
    });

    // Log summary
    print("=== COMPLAINTS SUMMARY ===");
    print("From Orders: ${complaintsFromOrders.length}");
    print("From Reports: ${allReports.length}");
    print("Total Combined: ${combinedComplaints.length}");
    print("========================");
    
    // Log individual complaints
    for (var complaint in combinedComplaints) {
      print("Complaint ID: ${complaint.id}");
      print("Customer: ${complaint.customerName}");
      print("Phone: ${complaint.customerPhoneNumber ?? 'NULL'}");
      print("Service: ${complaint.serviceCategoryName}");
      print("Description: ${complaint.problemDescription}");
      print("------------------------------------------");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('شاشة الشكاوي', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.yellow[700], // Red color to indicate complaints/alerts
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text("حدث خطأ أثناء تحميل البيانات", style: TextStyle(fontSize: 16)),
                      Text(_errorMessage!, style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchComplaints,
                        child: Text("إعادة المحاولة"),
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Summary Card
                    Container(
                      margin: EdgeInsets.all(16),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.report_problem, size: 30, color: Colors.red),
                          SizedBox(width: 12),
                          Column(
                            children: [
                              Text(
                                "${_complaints.length}",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[800],
                                ),
                              ),
                              Text(
                                "عدد الشكاوي النشطة",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Complaints List
                    Expanded(
                      child: _complaints.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_outline, size: 64, color: Colors.green[300]),
                                  SizedBox(height: 16),
                                  Text("لا توجد شكاوي حالياً", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: _complaints.length,
                              itemBuilder: (context, index) {
                                final complaint = _complaints[index];
                                return _buildComplaintCard(complaint);
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildComplaintCard(OrderModel complaint) {
    // Detect if this is from Reports API (has userName) or Orders API (has customerName)
    final bool isFromReports = complaint.userName != null;
    
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Name and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.person, size: 18, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        isFromReports 
                            ? (complaint.userName ?? "مستخدم غير معروف")
                            : (complaint.customerName ?? "عميل غير معروف"),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDate(complaint.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            Divider(height: 24),
            
            // Title (for Reports) or "نص الشكوى" (for Orders)
            if (isFromReports && complaint.title != null) ...[
              Text(
                "العنوان:",
                style: TextStyle(fontSize: 12, color: Colors.red[300], fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                complaint.title!,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
            ],
            
            // Description/Problem Description
            Text(
              isFromReports ? "الوصف:" : "نص الشكوى:",
              style: TextStyle(fontSize: 12, color: Colors.red[300], fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              isFromReports 
                  ? (complaint.description ?? "لا يوجد وصف")
                  : (complaint.problemDescription ?? "لا يوجد وصف للشكوى"),
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            
            SizedBox(height: 16),
            
            // Footer Details - Only show for Orders (not Reports)
            if (!isFromReports)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildMiniDetailRow(Icons.category, "الخدمة:", complaint.serviceCategoryName),
                    SizedBox(height: 6),
                    _buildMiniDetailRow(Icons.location_on, "الموقع:", "${complaint.governorateName ?? '-'} / ${complaint.areaName ?? '-'}"),
                    SizedBox(height: 6),
                    _buildMiniDetailRow(Icons.phone, "الهاتف:", complaint.customerPhoneNumber),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniDetailRow(IconData icon, String label, String? value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(width: 4),
        Expanded( // Added Expanded to prevent overflow
          child: Text(
            value ?? "غير محدد",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      final DateTime date = DateTime.parse(dateStr);
      // Format: 2023-10-25 02:30 PM (Simple manual format or just date)
      String hourStr = (date.hour % 12 == 0 ? 12 : date.hour % 12).toString().padLeft(2, '0');
      String minuteStr = date.minute.toString().padLeft(2, '0');
      String period = date.hour >= 12 ? 'PM' : 'AM';
      return "${date.year}-${date.month}-${date.day} $hourStr:$minuteStr $period";
    } catch (e) {
      return dateStr;
    }
  }
}
