import 'package:flutter/material.dart';
import '../../../../scteens/technicians/technician_profile.dart';
import '../../../models/order_model.dart';
import 'rejected_order.dart'; // Keep for now if used elsewhere, but we might remove it

class AllRejectedOrdersScreen extends StatefulWidget {
  final List<OrderModel> orders;

  AllRejectedOrdersScreen({required this.orders});

  @override
  _AllRejectedOrdersScreenState createState() =>
      _AllRejectedOrdersScreenState();
}

class _AllRejectedOrdersScreenState extends State<AllRejectedOrdersScreen> {
  List<OrderModel> rejectedOrders = [];
  List<OrderModel> filteredOrders = [];
  String? selectedServiceType;
  String? selectedGovernorate;

  final List<String> serviceTypes = [
    'كهرباء',
    'سباكة',
    'صيانة موبايل',
    'إلكترونيات',
    'ميكانيكا',
    'ونش',
    'تكييف وتبريد',
    'نجارة',
    'حدادة',
    'دهانات'
  ];

  @override
  void initState() {
    super.initState();
    _loadRejectedOrders();
  }

  void _loadRejectedOrders() {
    rejectedOrders = widget.orders;
    filteredOrders = rejectedOrders;
  }

  void _applyFilters() {
    setState(() {
      filteredOrders = rejectedOrders.where((order) {
        bool serviceMatch = selectedServiceType == null ||
            order.serviceCategoryName == selectedServiceType;
        bool governorateMatch = selectedGovernorate == null ||
            order.governorateName == selectedGovernorate;
        return serviceMatch && governorateMatch;
      }).toList();
    });
  }

  Widget _buildFilterSection() {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('فلاتر البحث',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedServiceType,
                    decoration: InputDecoration(
                      labelText: 'نوع الخدمة',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text('جميع الخدمات'))
                    ]..addAll(serviceTypes.map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))),
                    onChanged: (value) {
                      setState(() => selectedServiceType = value);
                      _applyFilters();
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedGovernorate,
                    decoration: InputDecoration(
                      labelText: 'المحافظة',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                          value: null, child: Text('جميع المحافظات'))
                    ]..addAll(_getUniqueGovernorates().map((gov) =>
                        DropdownMenuItem(value: gov, child: Text(gov)))),
                    onChanged: (value) {
                      setState(() => selectedGovernorate = value);
                      _applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getUniqueGovernorates() {
    return rejectedOrders.map((order) => order.governorateName ?? "N/A").toSet().toList();
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

  void _showLocationDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('موقع الخدمة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المحافظة: ${order.governorateName ?? "N/A"}'),
            Text('المركز: ${order.areaName ?? "N/A"}'),
            Text('العنوان: ${order.address ?? "N/A"}'),
            SizedBox(height: 20),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 50, color: Colors.grey),
                    Text('خريطة الموقع', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
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
            _buildInfoRow('الهاتف', order.customerPhoneNumber ?? "غير متوفر"),
            _buildInfoRow('العنوان', '${order.governorateName ?? ""} - ${order.areaName ?? ""}'),
            _buildInfoRow('الوصف', order.problemDescription ?? "لا يوجد وصف"),
            _buildInfoRow('تاريخ الطلب', order.createdAt ?? "غير محدد"),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.person, size: 18),
                    label: Text('ملف الفني'),
                    onPressed: () =>
                        _navigateToTechnicianProfile(null), // Need technicianId in OrderModel if mapping
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[50],
                      foregroundColor: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.location_on, size: 18),
                    label: Text('الموقع'),
                    onPressed: () => _showLocationDialog(order),
                  ),
                ),
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
        title: Text('جميع الطلبات المرفوضة',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.red[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFilterSection(),
            Expanded(
              child: filteredOrders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 60, color: Colors.grey),
                          Text('لا توجد طلبات مرفوضة',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) =>
                          _buildOrderCard(filteredOrders[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
