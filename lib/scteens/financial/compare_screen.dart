
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';
import 'financial_service.dart';

class CompareScreen extends StatefulWidget {
  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  // Service
  final FinancialService _financialService = FinancialService();
  
  // Data
  Future<List<OrderModel>>? _ordersFuture;
  List<OrderModel> _allOrders = [];
  
  // Filters
  String _selectedPeriod = 'الكل'; // الكل, اليوم, الأسبوع, الشهر
  String _selectedGovernorate = 'الكل';
  
  // Lists for Filter Dropdowns
  List<String> _governorates = ['الكل'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _ordersFuture = _financialService.getAllOrders().then((orders) {
        _allOrders = orders;
        _extractFilterOptions();
        return orders;
      });
    });
  }

  void _extractFilterOptions() {
    final govs = _allOrders
        .map((e) => e.governorateName)
        .where((e) => e != null && e.isNotEmpty)
        .toSet()
        .toList();
    
    setState(() {
      _governorates = ['الكل', ...govs.cast<String>()];
    });
  }

  // Filtering Logic
  List<OrderModel> _getFilteredOrders() {
    return _allOrders.where((order) {
      // 1. Time Filter
      bool timeMatch = true;
      if (order.date != null) {
        try {
          final orderDate = DateTime.parse(order.date!);
          final now = DateTime.now();
          if (_selectedPeriod == 'اليوم') {
             timeMatch = orderDate.year == now.year && orderDate.month == now.month && orderDate.day == now.day;
          } else if (_selectedPeriod == 'الأسبوع') {
             // Simple "last 7 days" check
             final difference = now.difference(orderDate).inDays;
             timeMatch = difference >= 0 && difference < 7;
          } else if (_selectedPeriod == 'الشهر') {
             timeMatch = orderDate.year == now.year && orderDate.month == now.month;
          }
        } catch (e) {
          // Ignore parse errors, include by default or handle otherwise
        }
      }

      // 2. Governorate Filter
      bool govMatch = true;
      if (_selectedGovernorate != 'الكل') {
        govMatch = order.governorateName == _selectedGovernorate;
      }

      return timeMatch && govMatch;
    }).toList();
  }

  // Statistics Calculation
  double _calculateTotal(List<OrderModel> orders, {int? payWay}) {
    double total = 0;
    for (var order in orders) {
      if (payWay == null || order.payWay == payWay) {
        total += (order.price ?? 0);
      }
    }
    return total;
  }
  
  int _calculateCount(List<OrderModel> orders, {int? payWay}) {
    if (payWay == null) return orders.length;
    return orders.where((o) => o.payWay == payWay).length;
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _getFilteredOrders();
    final totalCash = _calculateTotal(filteredOrders, payWay: 0);
    final totalElectronic = _calculateTotal(filteredOrders, payWay: 1);
    final totalAmount = totalCash + totalElectronic;
    
    final countCash = _calculateCount(filteredOrders, payWay: 0);
    final countElectronic = _calculateCount(filteredOrders, payWay: 1);
    
    // Estimated Commission (Assuming 20% for now as specific per-order type is not in OrderModel)
    final totalCommission = totalAmount * 0.20; 
    final totalNet = totalAmount - totalCommission;

    return Scaffold(
      appBar: AppBar(
        title: Text("مقارنة الأداء المالي", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
             return Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Icon(Icons.error_outline, color: Colors.red, size: 50),
                   SizedBox(height: 10),
                   Text("حدث خطأ أثناء تحميل البيانات", style: TextStyle(fontSize: 16)),
                   TextButton(onPressed: _loadData, child: Text("إعادة المحاولة"))
                 ],
               ),
             );
          } else if (!snapshot.hasData || _allOrders.isEmpty) {
             return Center(child: Text("لا توجد بيانات متاحة"));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // ================== Filters ==================
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("🔍 خيارات الفلترة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _buildFilterDropdown("الفترة", ['الكل', 'اليوم', 'الأسبوع', 'الشهر'], _selectedPeriod, (val) => setState(() => _selectedPeriod = val!))),
                            SizedBox(width: 10),
                            Expanded(child: _buildFilterDropdown("المحافظة", _governorates, _selectedGovernorate, (val) => setState(() => _selectedGovernorate = val!))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // ================== Top Stats Cards ==================
                Row(
                  children: [
                    _statCard("إجمالي المبلغ", "${totalAmount.toStringAsFixed(2)} جنيه", Icons.account_balance_wallet, Colors.teal),
                    SizedBox(width: 10),
                    _statCard("إجمالي العمليات", "${filteredOrders.length}", Icons.receipt_long, Colors.blue),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    _statCard("عمولة مقدرة (20%)", "${totalCommission.toStringAsFixed(2)} جنيه", Icons.handshake, Colors.red),
                    SizedBox(width: 10),
                    _statCard("صافي تقريبي", "${totalNet.toStringAsFixed(2)} جنيه", Icons.attach_money, Colors.green),
                  ],
                ),
                SizedBox(height: 20),

                // ================== Comparison Section ==================
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("⚖️ مقارنة: كاش vs إلكتروني",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                        
                        // Detailed Rows
                        _detailRow("💵 كاش", "${totalCash.toStringAsFixed(2)} جنيه (${countCash} عملية)", Icons.money_off, Colors.orange),
                        _detailRow("💳 إلكتروني", "${totalElectronic.toStringAsFixed(2)} جنيه (${countElectronic} عملية)", Icons.credit_card, Colors.purple),

                        SizedBox(height: 20),
                        // Simple Visual Bar
                       Container(
                         height: 20,
                         child: Row(
                           children: [
                             Expanded(
                               flex: (totalCash * 100).toInt(),
                               child: Container(
                                 decoration: BoxDecoration(
                                   color: Colors.orange,
                                   borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                                 ),
                               ),
                             ),
                             Expanded(
                               flex: (totalElectronic * 100).toInt(),
                               child: Container(
                                 decoration: BoxDecoration(
                                   color: Colors.purple,
                                   borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                       SizedBox(height: 5),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("${((totalAmount > 0 ? totalCash/totalAmount : 0)*100).toStringAsFixed(1)}%", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                           Text("${((totalAmount > 0 ? totalElectronic/totalAmount : 0)*100).toStringAsFixed(1)}%", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                         ],
                       )

                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
                
                // Notes
                Card(
                   color: Colors.grey.shade50,
                   child: Padding(
                     padding: const EdgeInsets.all(12.0),
                     child: Text("ملاحظة: البيانات المعروضة تعتمد على السجلات التي تم تحميلها من الخادم. لا تتوفر تفاصيل الفنيين حالياً.", style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                   ),
                )

              ],
            ),
          );
        },
      ),
    );
  }

  // --- Helpers ---

  Widget _buildFilterDropdown(String label, List<String> items, String selectedValue, Function(String?) onChanged) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
         SizedBox(height: 5),
         Container(
           padding: EdgeInsets.symmetric(horizontal: 10),
           decoration: BoxDecoration(
             border: Border.all(color: Colors.grey.shade300),
             borderRadius: BorderRadius.circular(8),
           ),
           child: DropdownButtonHideUnderline(
             child: DropdownButton<String>(
               value: items.contains(selectedValue) ? selectedValue : items.first,
               isExpanded: true,
               items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
               onChanged: onChanged,
             ),
           ),
         )
       ],
     );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color), textAlign: TextAlign.center),
            SizedBox(height: 5),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700]), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 10),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Spacer(),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
