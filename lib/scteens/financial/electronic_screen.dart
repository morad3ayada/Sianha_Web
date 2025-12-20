import 'package:flutter/material.dart';
import '/scteens/models/order_model.dart';
import '/scteens/financial/financial_service.dart';

// -----------------------------------------------------------------
// 1. شاشة الدفع الإلكتروني المحدثة (Real Data)
// -----------------------------------------------------------------

class ElectronicPaymentScreen extends StatefulWidget {
  @override
  _ElectronicPaymentScreenState createState() =>
      _ElectronicPaymentScreenState();
}

class _ElectronicPaymentScreenState extends State<ElectronicPaymentScreen> {
  final FinancialService _financialService = FinancialService();
  late Future<List<OrderModel>> _ordersFuture;

  // Filter variables
  String _selectedTimeFilter = 'الكل';
  String? _selectedGovernorate;
  
  // Data lists
  List<OrderModel> _allElectronicOrders = [];
  List<OrderModel> _filteredOrders = [];
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _ordersFuture = _financialService.getAllOrders().then((orders) {
      // Filter for Electronic (payWay == 1)
      final elecOrders = orders.where((o) => o.payWay == 1).toList();
      setState(() {
        _allElectronicOrders = elecOrders;
        _filterTransactions(); // Initial filter
      });
      return elecOrders;
    });
  }

  // Get governorates from actual data
  List<String> get governorates {
    return _allElectronicOrders
        .map((t) => t.governorateName ?? "")
        .where((g) => g.isNotEmpty)
        .toSet()
        .toList();
  }

  void _filterTransactions() {
    setState(() {
      _filteredOrders = _allElectronicOrders.where((order) {
        // 1. Time Filter (Ignoring for now as date format varies)
        
        // 2. Governorate Filter
        bool governorateFilterPassed = _selectedGovernorate == null ||
            order.governorateName == _selectedGovernorate;

        return governorateFilterPassed;
      }).toList();

      _calculateTotal();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedTimeFilter = 'الكل';
      _selectedGovernorate = null;
      _filterTransactions();
    });
  }

  void _calculateTotal() {
    _totalAmount = _filteredOrders.fold(
      0.0,
      (sum, order) => sum + (order.price ?? 0),
    );
  }

  // Helper widget for detail row
  Widget _buildDetailRow(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.purple.shade700),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: ",
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textDirection: TextDirection.rtl,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  // Card widget
  Widget _electronicCard(OrderModel order) {
     double amount = order.price ?? 0;
     double commissionRate = 0.20;
     double commissionAmount = amount * commissionRate;
     // double netProfit = amount - commissionAmount; // For generic 'Net Profit' if needed

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                     "#${order.id?.substring(0, 8) ?? 'N/A'}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.purple,
                ),
                Text(
                   order.date?.split('T')[0] ?? "تاريخ غير متوفر",
                    style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

             // Payment Way
             Row(
               children: [
                 Chip(
                   label: Text(
                     'دفع إلكتروني',
                     style: TextStyle(fontSize: 12, color: Colors.white),
                   ),
                   backgroundColor: Colors.purple,
                 ),
                 SizedBox(width: 8),
                 Chip(
                   label: Text(
                     "مكتمل", // Assuming complete if fetched
                     style: TextStyle(fontSize: 12, color: Colors.white),
                   ),
                   backgroundColor: Colors.green,
                 ),
               ],
             ),
             Divider(color: Colors.purple.shade100, height: 20),

            // Location
            _buildDetailRow(
                Icons.location_on, "المحافظة", order.governorateName ?? "غير محدد",
                valueColor: Colors.purple.shade800),
            Divider(color: Colors.purple.shade100, height: 20),


            // Financials
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.purple.shade100),
              ),
              child: Column(
                children: [
                  _buildDetailRow(Icons.attach_money, "إجمالي المبلغ",
                      "${amount.toStringAsFixed(2)} جنيه",
                      valueColor: Colors.green.shade700),
                  _buildDetailRow(Icons.trending_down, "عمولة التطبيق (20%)",
                      "${commissionAmount.toStringAsFixed(2)} جنيه",
                      valueColor: Colors.red.shade700),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationFilter() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "فلترة حسب الموقع",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade800,
            ),
          ),
          SizedBox(height: 12),

          // Governorate Filter
          DropdownButtonFormField<String>(
            value: _selectedGovernorate,
            decoration: InputDecoration(
              labelText: 'اختر المحافظة',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: Icon(Icons.location_city, color: Colors.purple),
            ),
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text('كل المحافظات'),
              ),
              ...governorates.map((governorate) {
                return DropdownMenuItem<String>(
                  value: governorate,
                  child: Text(governorate),
                );
              }).toList(),
            ],
            onChanged: (value) {
              setState(() {
                _selectedGovernorate = value;
                _filterTransactions();
              });
            },
          ),
          
           if (_selectedGovernorate != null)
             Padding(
               padding: const EdgeInsets.only(top: 10.0),
               child: Chip(
                  label: Text(
                    "${_filteredOrders.length} معاملة",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.purple,
                ),
             ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الدفع الإلكتروني"),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
               setState(() {
                 _loadData();
               });
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_alt_off),
            onPressed: _resetFilters,
          ),
        ],
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return Center(child: CircularProgressIndicator(color: Colors.purple));
          } else if (snapshot.hasError) {
             return Center(child: Text("حدث خطأ أثناء تحميل البيانات"));
          } else if (!snapshot.hasData || _allElectronicOrders.isEmpty) {
             return Center(child: Text("لا توجد عمليات دفع إلكتروني"));
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildLocationFilter(),
                      SizedBox(height: 16),
                       
                       // Total Summary
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                           gradient: LinearGradient(colors: [Colors.purple, Colors.purple.shade700]),
                           borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                             Text("إجمالي الإلكنروني", style: TextStyle(color: Colors.white, fontSize: 16)),
                             Text("${_totalAmount.toStringAsFixed(2)} جنيه", 
                                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
                             ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _filteredOrders.length,
                        itemBuilder: (context, index) {
                          return _electronicCard(_filteredOrders[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------
// 5. الدالة الرئيسية لتشغيل التطبيق
// -----------------------------------------------------------------

void main() {
  runApp(MaterialApp(
    title: 'نظام الدفع الإلكتروني',
    theme: ThemeData(
      primaryColor: Colors.purple,
      fontFamily: 'Cairo',
    ),
    home: ElectronicPaymentScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
