import 'package:flutter/material.dart';
import 'completed_order.dart';
import 'completed_orderss_screen.dart';

class CentersScreen extends StatelessWidget {
  final String governorate;
  final List<CompletedOrder> orders;

  CentersScreen({required this.governorate, required this.orders});

  // تجميع الطلبات حسب المركز
  Map<String, List<CompletedOrder>> _groupOrdersByCenter() {
    Map<String, List<CompletedOrder>> centerOrders = {};

    for (var order in orders) {
      if (!centerOrders.containsKey(order.center)) {
        centerOrders[order.center] = [];
      }
      centerOrders[order.center]!.add(order);
    }

    return centerOrders;
  }

  // حساب إحصائيات كل مركز
  Map<String, CenterStats> _calculateCenterStats() {
    final centerOrders = _groupOrdersByCenter();
    Map<String, CenterStats> stats = {};

    centerOrders.forEach((center, orders) {
      int totalOrders = orders.length;
      double totalRevenue =
          orders.fold(0.0, (double sum, order) => sum + order.price);
      double totalRating =
          orders.fold(0.0, (double sum, order) => sum + order.rating);
      double averageRating = totalOrders > 0 ? totalRating / totalOrders : 0.0;

      stats[center] = CenterStats(
        center: center,
        totalOrders: totalOrders,
        totalRevenue: totalRevenue,
        averageRating: averageRating,
      );
    });

    return stats;
  }

  @override
  Widget build(BuildContext context) {
    final centerStats = _calculateCenterStats();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('المراكز - $governorate',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green[700],
      ),
      body: centerStats.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_city, size: 60, color: Colors.grey),
                  Text('لا توجد مراكز',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: centerStats.length,
              itemBuilder: (context, index) {
                final center = centerStats.keys.elementAt(index);
                final stats = centerStats[center]!;

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        stats.totalOrders.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    title: Text(center,
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
                      final centerOrders = _groupOrdersByCenter()[center] ?? [];

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompletedOrdersScreen(
                            governorate: governorate,
                            center: center,
                            orders: centerOrders,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
