import 'package:flutter/material.dart';
import '../../../../scteens/technicians/technician_profile.dart';
import '../../../models/order_model.dart';

// شاشة الطلبات المرفوضة حسب المحافظة
class GovernorateRejectedOrdersScreen extends StatefulWidget {
  final String governorate;
  final List<OrderModel> orders;

  GovernorateRejectedOrdersScreen({required this.governorate, required this.orders});

  @override
  _GovernorateRejectedOrdersScreenState createState() =>
      _GovernorateRejectedOrdersScreenState();
}

class _GovernorateRejectedOrdersScreenState
    extends State<GovernorateRejectedOrdersScreen> {
  List<OrderModel> governorateOrders = [];

  @override
  void initState() {
    super.initState();
    _loadGovernorateOrders();
  }

  void _loadGovernorateOrders() {
    governorateOrders = widget.orders;
  }

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
      default:
        icon = Icons.build;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(icon, color: color, size: 20),
    );
  }

  void _navigateToTechnicianProfile(String? technicianId) {
    if (technicianId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ID الفني غير متوفر')),
      );
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TechnicianProfile(
          userId: technicianId,
          technicianId: technicianId,
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
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
                _buildServiceIcon(order.serviceCategoryName ?? ""),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.serviceCategoryName ?? "خدمة غير محددة",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(order.customerName ?? "عميل مجهول"),
                    ],
                  ),
                ),
                Chip(
                  label: Text('مرفوض', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.red,
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Text('الهاتف: ${order.customerPhoneNumber ?? "غير متوفر"}'),
            Text('المركز: ${order.areaName ?? "غير محدد"}'),
            Text('الوصف: ${order.problemDescription ?? "لا يوجد وصف"}'),
            Text('التاريخ: ${order.createdAt ?? "غير محدد"}'),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.person, size: 18),
              label: Text('عرض ملف الفني'),
              onPressed: () => _navigateToTechnicianProfile(null),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[50],
                foregroundColor: Colors.blue,
              ),
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
        title: Text('طلبات ${widget.governorate} المرفوضة',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.red[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: governorateOrders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.thumb_up, size: 60, color: Colors.green),
                    Text('لا توجد طلبات مرفوضة في ${widget.governorate}',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: governorateOrders.length,
                itemBuilder: (context, index) =>
                    _buildOrderCard(governorateOrders[index]),
              ),
      ),
    );
  }
}
