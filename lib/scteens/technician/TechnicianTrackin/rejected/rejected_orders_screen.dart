import 'package:flutter/material.dart';
import '../../../models/order_model.dart';
import 'AllRejectedOrdersScreen.dart';
import 'GovernorateRejectedOrdersScreen.dart';
import 'RejectionAnalyticsScreen.dart';

class RejectedOrdersMainScreen extends StatelessWidget {
  final List<OrderModel> rejectedOrders;

  RejectedOrdersMainScreen({required this.rejectedOrders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('نظام إدارة الطلبات المرفوضة',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.red[700],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatsCard(),
            SizedBox(height: 20),
            _buildNavigationCard(
              context,
              'عرض جميع الطلبات المرفوضة',
              Icons.list_alt,
              Colors.blue,
              () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => AllRejectedOrdersScreen(orders: rejectedOrders))
                  );
              }
            ),
            SizedBox(height: 15),
            _buildNavigationCard(
              context,
              'الطلبات حسب المحافظة',
              Icons.location_on,
              Colors.green,
              () => _showGovernoratesDialog(context),
            ),
            SizedBox(height: 15),
            // Re-adding the analytics button if needed
             _buildNavigationCard(
              context,
              'تحليلات الرفض',
              Icons.analytics,
              Colors.orange,
              () {
                // If RejectionAnalyticsScreen is not ready, we can show a placeholder or just leave it
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    // Unique Governorates
    final govs = rejectedOrders.map((e) => e.governorateName).where((e) => e != null).toSet().length;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.warning, size: 50, color: Colors.red),
            SizedBox(height: 10),
            Text(
              'الطلبات المرفوضة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              '${rejectedOrders.length} طلب - $govs محافظة',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showGovernoratesDialog(BuildContext context) {
      // Extract actual governorates from data
      final governorates = rejectedOrders
        .map((e) => e.governorateName)
        .where((e) => e != null)
        .toSet()
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اختر المحافظة'),
        content: Container(
          width: double.maxFinite,
          child: governorates.isEmpty 
          ? Text("لا توجد بيانات")
          : ListView.builder(
            shrinkWrap: true,
            itemCount: governorates.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(governorates[index]!),
              onTap: () {
                final govOrders = rejectedOrders.where((o) => o.governorateName == governorates[index]).toList();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GovernorateRejectedOrdersScreen(governorate: governorates[index]!, orders: govOrders))
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
