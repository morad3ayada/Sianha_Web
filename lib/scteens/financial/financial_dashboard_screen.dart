import 'package:flutter/material.dart';
import 'package:car_services_management/scteens/models/order_model.dart';
import 'package:car_services_management/scteens/financial/financial_service.dart';
import 'cash_screen.dart';
import 'electronic_screen.dart';
import 'compare_screen.dart';

class FinancialManagementApp extends StatefulWidget {
  @override
  _FinancialManagementAppState createState() => _FinancialManagementAppState();
}

class _FinancialManagementAppState extends State<FinancialManagementApp> {
  final FinancialService _financialService = FinancialService();
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _financialService.getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("النظام المالي"),
        centerTitle: true,
        backgroundColor: Colors.yellow[700], // Changed to match Home
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // ====== الإحصائيات =======
            Expanded(
              child: FutureBuilder<List<OrderModel>>(
                future: _ordersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Colors.yellow[800]));
                  } else if (snapshot.hasError) { // Timeout or other error
                    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.amber),
                            SizedBox(height: 10),
                            Text(
                              'تعذر تحميل البيانات', 
                              style: TextStyle(fontSize: 18, color: Colors.grey[700])
                            ),
                             Text(
                              '${snapshot.error}'.replaceAll("Exception: ", ""), 
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600])
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                    _ordersFuture = _financialService.getAllOrders();
                                });
                              },
                              child: Text("إعادة المحاولة"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[700], foregroundColor: Colors.white),
                            )
                          ],
                        )
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('لا توجد بيانات'));
                  } else {
                    return _buildStatisticsRow(snapshot.data!);
                  }
                },
              ),
            ),

            SizedBox(height: 20),

            // ====== الأزرار =======
            _button(
              context,
              "عمليات الكاش",
              CashScreen(),
              Icons.attach_money,
            ),
            _button(
              context,
              "الدفع الإلكتروني",
              ElectronicPaymentScreen(),
              Icons.payment,
            ),
            _button(
              context,
              "مقارنة الكاش و الإلكتروني",
              CompareScreen(),
              Icons.compare_arrows,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsRow(List<OrderModel> orders) {
    // Calculcate Statistics
    
    // Top Governorate by Operations (Count)
    var governorateOpsCounts = <String, int>{};
    var governorateIncomeCounts = <String, double>{};

    double totalCash = 0;
    double totalElectronic = 0;
    
    for (var order in orders) {
      // 1. Payment Method Stats
      // payWay: 0 -> Cash, 1 -> Electronic
      double p = order.price ?? 0;
      if (order.payWay == 0) {
        totalCash += p;
      } else if (order.payWay == 1) {
        totalElectronic += p;
      }

      // 2. Governorate Stats
      if (order.governorateName != null && order.governorateName!.isNotEmpty) {
        String gov = order.governorateName!;
        
        // Count Operations
        governorateOpsCounts[gov] = (governorateOpsCounts[gov] ?? 0) + 1;
        
        // Sum Income
        governorateIncomeCounts[gov] = (governorateIncomeCounts[gov] ?? 0) + p;
      }
    }

    String topGovByOps = "غير متوفر";
    if (governorateOpsCounts.isNotEmpty) {
       topGovByOps = governorateOpsCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }
    
    String topGovByIncome = "غير متوفر";
    if (governorateIncomeCounts.isNotEmpty) {
       topGovByIncome = governorateIncomeCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statCard("أعلى محافظة دخل", topGovByIncome,
                color: Colors.green.shade50), // Kept logic, customized colors could be added if requested but "Yellow" theme mainly applies to main elements
            _statCard("أعلى محافظة عمليات", topGovByOps,
                color: Colors.blue.shade50),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statCard("إجمالي كاش", "${totalCash.toStringAsFixed(2)}",
                width: 150, color: Colors.orange.shade50),
            _statCard("إجمالي إلكتروني", "${totalElectronic.toStringAsFixed(2)}",
                width: 150, color: Colors.purple.shade50),
          ],
        ),
      ],
    );
  }

  Widget _statCard(String title, String value,
      {double width = 150, Color? color}) {
    return Container(
      width: width,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color ?? Colors.yellow.shade50, // Default to yellow shade
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.yellow[800], // Text color to yellow/amber
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(
      BuildContext context, String title, Widget screen, IconData icon) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 15),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow[700], // Button bg to Yellow
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
        icon: Icon(icon, size: 24),
        label: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
