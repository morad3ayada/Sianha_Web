import 'package:flutter/material.dart';
import '/scteens/models/order_model.dart';
import '/scteens/financial/financial_service.dart';

// -----------------------------------------------------------------
// 1. شاشة الكاش المحدثة (Real Data)
// -----------------------------------------------------------------

class CashScreen extends StatefulWidget {
  @override
  _CashScreenState createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
  final FinancialService _financialService = FinancialService();
  late Future<List<OrderModel>> _ordersFuture;

  // Filter variables
  String _selectedTimeFilter = 'الكل';
  String? _selectedGovernorate;
  
  // Data lists
  List<OrderModel> _allCashOrders = [];
  List<OrderModel> _filteredOrders = [];
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _ordersFuture = _financialService.getAllOrders().then((orders) {
      // Filter for Cash (payWay == 0)
      final cashOrders = orders.where((o) => o.payWay == 0).toList();
      setState(() {
        _allCashOrders = cashOrders;
        _filterTransactions(); // Initial filter
      });
      return cashOrders;
    });
  }

  // Get governorates from actual data
  List<String> get cashGovernorates {
    return _allCashOrders
        .map((t) => t.governorateName ?? "")
        .where((g) => g.isNotEmpty)
        .toSet()
        .toList();
  }

  void _filterTransactions() {
    setState(() {
      _filteredOrders = _allCashOrders.where((order) {
        // 1. Time Filter (Basic implementation based on simplified date parsing if needed, 
        // for now 'الكل' is default and usually enough if date format isn't standard ISO)
        // Ignoring time filter complexity for now as Date format from API might vary.
        
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
          Icon(icon, size: 18, color: Colors.green.shade700),
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

  // Card widget for Order
  Widget _cashCard(OrderModel order) {
    // Basic commission calc (Example: 20% app commission)
    double amount = order.price ?? 0;
    double commissionRate = 0.20;
    double commissionAmount = amount * commissionRate;
    double netProfit = amount - commissionAmount;

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
                    "#${order.id?.substring(0, 8) ?? 'N/A'}", // Short ID
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.green,
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

            // Location
            _buildDetailRow(
              Icons.location_on,
              "المحافظة",
              order.governorateName ?? "غير محدد",
              valueColor: Colors.green.shade800,
            ),
             Divider(color: Colors.green.shade100, height: 20),

            // Financials
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    Icons.monetization_on,
                    "إجمالي المبلغ",
                    "${amount.toStringAsFixed(2)} جنيه",
                    valueColor: Colors.green.shade700,
                  ),
                   _buildDetailRow(
                    Icons.trending_down,
                    "عمولة التطبيق (20%)",
                    "${commissionAmount.toStringAsFixed(2)} جنيه",
                    valueColor: Colors.red.shade700,
                  ),
                   _buildDetailRow(
                    Icons.wallet,
                    "صافي الربح",
                    "${netProfit.toStringAsFixed(2)} جنيه",
                    valueColor: Colors.blue.shade700,
                  ),
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
              color: Colors.green.shade800,
            ),
          ),
          SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: _selectedGovernorate,
            decoration: InputDecoration(
              labelText: 'اختر المحافظة',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: Icon(Icons.location_city, color: Colors.green),
            ),
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text('كل المحافظات'),
              ),
              ...cashGovernorates.map((governorate) {
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
                  backgroundColor: Colors.green,
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
        title: Text("عمليات الكاش"),
        centerTitle: true,
        backgroundColor: Colors.green,
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
            return Center(child: CircularProgressIndicator(color: Colors.green));
          } else if (snapshot.hasError) {
             return Center(child: Text("حدث خطأ أثناء تحميل البيانات"));
          } else if (!snapshot.hasData || _allCashOrders.isEmpty) {
             return Center(child: Text("لا توجد عمليات كاش"));
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
                           gradient: LinearGradient(colors: [Colors.green, Colors.green.shade700]),
                           borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                             Text("إجمالي الكاش", style: TextStyle(color: Colors.white, fontSize: 16)),
                             Text("${_totalAmount.toStringAsFixed(2)} جنيه", 
                                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
                             ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _filteredOrders.length,
                        itemBuilder: (context, index) {
                          return _cashCard(_filteredOrders[index]);
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
