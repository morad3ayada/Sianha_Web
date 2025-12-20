import 'package:flutter/material.dart';
import '../../../models/order_model.dart';
import 'centers_screen.dart';
import 'advanced_stats_screen.dart';

// Helper class for stats
class GovernorateStats {
  final String governorate;
  final int totalOrders;
  final double totalRevenue;
  final double averageRating;
  final Map<String, int> serviceTypeDistribution;

  GovernorateStats({
    required this.governorate,
    required this.totalOrders,
    required this.totalRevenue,
    required this.averageRating,
    required this.serviceTypeDistribution,
  });
}

class CompletedOrdersScreen extends StatelessWidget {
  final List<OrderModel> allOrders;

  CompletedOrdersScreen({required this.allOrders});

  // Calculate stats per governorate
  Map<String, GovernorateStats> _calculateGovernorateStats() {
    Map<String, GovernorateStats> stats = {};
    
    // Group by governorate
    Map<String, List<OrderModel>> ordersByGov = {};
    for (var order in allOrders) {
      if (order.governorateName != null) {
        if (!ordersByGov.containsKey(order.governorateName)) {
           ordersByGov[order.governorateName!] = [];
        }
        ordersByGov[order.governorateName!]!.add(order);
      }
    }

    ordersByGov.forEach((governorate, orders) {
      int totalOrders = orders.length;
      double totalRevenue =
          orders.fold(0.0, (double sum, order) => sum + (order.price ?? 0));
      
      // Note: Rating is usually not in OrderModel, providing default or check if available
      double averageRating = 5.0; 

      Map<String, int> serviceDistribution = {};
      for (var order in orders) {
        String service = order.serviceCategoryName ?? 'Unknown';
        serviceDistribution[service] = (serviceDistribution[service] ?? 0) + 1;
      }

      stats[governorate] = GovernorateStats(
        governorate: governorate,
        totalOrders: totalOrders,
        totalRevenue: totalRevenue,
        averageRating: averageRating,
        serviceTypeDistribution: serviceDistribution,
      );
    });

    return stats;
  }

  @override
  Widget build(BuildContext context) {
    final governorateStats = _calculateGovernorateStats();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('العمليات المنجزة - المحافظات',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green[700],
      ),
      body: governorateStats.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work_outline, size: 60, color: Colors.grey),
                  Text('لا توجد عمليات منجزة',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: governorateStats.length,
                    itemBuilder: (context, index) {
                      final governorate =
                          governorateStats.keys.elementAt(index);
                      final stats = governorateStats[governorate]!;

                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green[100],
                            child: Text(
                              stats.totalOrders.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                          title: Text(governorate,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                  'الإيرادات: ${stats.totalRevenue.toStringAsFixed(0)} جنيه'),
                              Text(
                                  'التقييم: ${stats.averageRating.toStringAsFixed(1)} ⭐'),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Filter orders for this governorate
                            final govOrders = allOrders.where((o) => o.governorateName == governorate).toList();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CentersScreen(
                                  governorate: governorate,
                                  orders: govOrders,
                                ),
                              ),
                            );
                          },
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
