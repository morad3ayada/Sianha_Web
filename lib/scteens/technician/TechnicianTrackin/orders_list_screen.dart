
import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import 'package:intl/intl.dart';

class OrdersListScreen extends StatelessWidget {
  final String title;
  final List<OrderModel> orders;
  final Color themeColor;

  OrdersListScreen({required this.title, required this.orders, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: themeColor,
        centerTitle: true,
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.inbox, size: 60, color: Colors.grey[300]),
                   SizedBox(height: 10),
                   Text("لا توجد طلبات في هذه القائمة", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: themeColor.withOpacity(0.1),
                      child: Icon(Icons.receipt, color: themeColor),
                    ),
                    title: Text("طلب #${order.id ?? '---'}", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text("التاريخ: ${order.date ?? 'غير محدد'}"),
                        Text("السعر: ${order.price?.toStringAsFixed(2) ?? '0'} جنيه"),
                        Text("المحافظة: ${order.governorateName ?? 'غير محدد'}"),
                        Text("الحالة: ${_getStatusName(order.orderStatus)}", style: TextStyle(color: themeColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _getStatusName(int? status) {
    switch (status) {
      case 0: return "Pending";
      case 1: return "Assigned";
      case 2: return "Accepted";
      case 3: return "In Progress";
      case 4: return "Completed";
      case 5: return "Cancelled";
      case 6: return "Rejected";
      default: return "Unknown";
    }
  }
}
