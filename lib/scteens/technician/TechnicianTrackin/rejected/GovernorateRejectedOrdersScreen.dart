import 'package:flutter/material.dart';
import '/scteens/technicians/technician_profile.dart';
import 'rejected_order.dart';

// شاشة الطلبات المرفوضة حسب المحافظة
class GovernorateRejectedOrdersScreen extends StatefulWidget {
  final String governorate;

  GovernorateRejectedOrdersScreen({required this.governorate});

  @override
  _GovernorateRejectedOrdersScreenState createState() =>
      _GovernorateRejectedOrdersScreenState();
}

class _GovernorateRejectedOrdersScreenState
    extends State<GovernorateRejectedOrdersScreen> {
  List<RejectedOrder> governorateOrders = [];

  @override
  void initState() {
    super.initState();
    _loadGovernorateOrders();
  }

  void _loadGovernorateOrders() {
    // محاكاة بيانات المحافظة
    governorateOrders = [
      RejectedOrder(
        id: '1',
        serviceType: 'كهرباء',
        customerName: 'أحمد محمد',
        customerPhone: '01234567891',
        address: 'شارع النصر - حي الزهور',
        governorate: widget.governorate,
        center: 'مركز سوهاج',
        rejectionReason: 'عدم توفر قطع غيار',
        rejectionDate: DateTime.now().subtract(Duration(days: 1)),
        requestDate: DateTime.now().subtract(Duration(days: 3)),
        technicianId: 'tech001',
        technicianName: 'محمد علي',
      ),
      RejectedOrder(
        id: '2',
        serviceType: 'سباكة',
        customerName: 'فاطمة إبراهيم',
        customerPhone: '01234567892',
        address: 'شارع الجمهورية',
        governorate: widget.governorate,
        center: 'مركز جهينة',
        rejectionReason: 'المكان بعيد',
        rejectionDate: DateTime.now().subtract(Duration(days: 2)),
        requestDate: DateTime.now().subtract(Duration(days: 4)),
        technicianId: 'tech002',
        technicianName: 'خالد محمود',
      ),
    ];
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToTechnicianProfile(String technicianId) {
    // جلب بيانات الفني من الطلبات أو من أي مصدر عندك
    RejectedOrder order =
        governorateOrders.firstWhere((o) => o.technicianId == technicianId);

    Map<String, dynamic> technicianData = {
      'id': order.technicianId,
      'name': order.technicianName,
      'serviceType': order.serviceType,
      // ممكن تضيف باقي البيانات لو موجودة
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TechnicianProfile(
          userId: order.technicianId,
          technicianId: order.technicianId,
        ),
      ),
    );
  }

  Widget _buildOrderCard(RejectedOrder order) {
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
                  label: Text('مرفوض', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.red,
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Text('المركز: ${order.center}'),
            Text('سبب الرفض: ${order.rejectionReason}'),
            Text('تاريخ الرفض: ${_formatDate(order.rejectionDate)}'),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.person, size: 18),
              label: Text('عرض ملف الفني'),
              onPressed: () => _navigateToTechnicianProfile(order.technicianId),
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
