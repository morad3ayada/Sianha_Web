import 'package:flutter/material.dart';
import 'completed_order.dart';

class CompletedOrdersScreen extends StatelessWidget {
  final String governorate;
  final String center;
  final List<CompletedOrder> orders;

  CompletedOrdersScreen({
    required this.governorate,
    required this.center,
    required this.orders,
  });

  Widget _buildServiceIcon(String serviceType) {
    IconData icon;
    Color color;

    switch (serviceType) {
      case 'كهرباء':
        icon = Icons.electrical_services;
        color = Colors.amber;
        break;
      case 'سباكة':
        icon = Icons.plumbing;
        color = Colors.blue;
        break;
      case 'صيانة موبايل':
        icon = Icons.smartphone;
        color = Colors.green;
        break;
      case 'ونش':
        icon = Icons.local_shipping;
        color = Colors.orange;
        break;
      case 'تكييف وتبريد':
        icon = Icons.ac_unit;
        color = Colors.cyan;
        break;
      default:
        icon = Icons.build;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(icon, color: color, size: 20),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildOrderCard(CompletedOrder order) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildServiceIcon(order.serviceType),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.serviceType,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(order.customerName),
                    ],
                  ),
                ),
                Chip(
                  label: Text('${order.rating}',
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.amber,
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.grey),
                SizedBox(width: 5),
                Text(order.customerPhone),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 5),
                Expanded(child: Text(order.address)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.attach_money, size: 16, color: Colors.green),
                SizedBox(width: 5),
                Text('${order.price.toStringAsFixed(0)} جنيه'),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 5),
                Text('تم الانتهاء: ${_formatDate(order.completionDate)}'),
              ],
            ),
            if (order.notes != null && order.notes!.isNotEmpty) ...[
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note, size: 16, color: Colors.grey),
                  SizedBox(width: 5),
                  Expanded(child: Text('ملاحظات: ${order.notes!}')),
                ],
              ),
            ],
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.blue),
                SizedBox(width: 5),
                Text('الفني: ${order.technicianName}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('الشغل المنتهي - $center',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.green[700],
      ),
      body: orders.isEmpty
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
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) => _buildOrderCard(orders[index]),
            ),
    );
  }
}
