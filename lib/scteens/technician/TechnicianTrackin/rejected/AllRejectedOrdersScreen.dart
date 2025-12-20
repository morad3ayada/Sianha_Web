import 'package:flutter/material.dart';
import '/scteens/technicians/technician_profile.dart';
import 'rejected_order.dart';

class AllRejectedOrdersScreen extends StatefulWidget {
  @override
  _AllRejectedOrdersScreenState createState() =>
      _AllRejectedOrdersScreenState();
}

class _AllRejectedOrdersScreenState extends State<AllRejectedOrdersScreen> {
  List<RejectedOrder> rejectedOrders = [];
  List<RejectedOrder> filteredOrders = [];
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
    rejectedOrders = [
      RejectedOrder(
        id: '1',
        serviceType: 'كهرباء',
        customerName: 'أحمد محمد',
        customerPhone: '01234567891',
        address: 'شارع النصر - حي الزهور',
        governorate: 'سوهاج',
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
        governorate: 'سوهاج',
        center: 'مركز جهينة',
        rejectionReason: 'المكان بعيد',
        rejectionDate: DateTime.now().subtract(Duration(days: 2)),
        requestDate: DateTime.now().subtract(Duration(days: 4)),
        technicianId: 'tech002',
        technicianName: 'خالد محمود',
      ),
      RejectedOrder(
        id: '3',
        serviceType: 'صيانة موبايل',
        customerName: 'محمود عبدالله',
        customerPhone: '01234567893',
        address: 'حي الكوثر',
        governorate: 'القاهرة',
        center: 'مركز مصر الجديدة',
        rejectionReason: 'التكلفة مرتفعة',
        rejectionDate: DateTime.now().subtract(Duration(days: 3)),
        requestDate: DateTime.now().subtract(Duration(days: 5)),
        technicianId: 'tech003',
        technicianName: 'ياسر محمد',
      ),
    ];
    filteredOrders = rejectedOrders;
  }

  void _applyFilters() {
    setState(() {
      filteredOrders = rejectedOrders.where((order) {
        bool serviceMatch = selectedServiceType == null ||
            order.serviceType == selectedServiceType;
        bool governorateMatch = selectedGovernorate == null ||
            order.governorate == selectedGovernorate;
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
    return rejectedOrders.map((order) => order.governorate).toSet().toList();
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

  void _navigateToTechnicianProfile(String technicianId) {
    try {
      // البحث عن الطلب المطابق لـ technicianId
      RejectedOrder? order = rejectedOrders.cast<RejectedOrder?>().firstWhere(
            (o) => o!.technicianId == technicianId,
            orElse: () => null, // إرجاع null إذا لم يتم العثور على طلب مطابق
          );

      if (order == null) {
        // إذا لم يتم العثور على طلب، اعرض رسالة خطأ مناسبة
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('لا يمكن العثور على تفاصيل الطلب للفني المطلوب.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // إنشاء بيانات الفني بناءً على تفاصيل الطلب الموجودة
      Map<String, dynamic> technicianData = {
        'id': order.technicianId,
        'name': order.technicianName,
        'phone': '01012345678', // بيانات افتراضية
        'email':
            '${order.technicianName.replaceAll(' ', '.').toLowerCase()}@example.com',
        'specialization': order.serviceType,
        'governorate': order.governorate,
        'center': order.center,
        'experience': '5 سنوات', // بيانات افتراضية
        'rating': '4.5', // بيانات افتراضية
        'completedOrders': '120', // بيانات افتراضية
        'rejectedOrders': '8', // بيانات افتراضية
        'joinDate': '2020-03-15', // بيانات افتراضية
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
    } catch (e) {
      // في حالة وجود خطأ آخر غير متوقع، نعرض رسالة
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ في تحميل بيانات الفني: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showLocationDialog(RejectedOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('موقع الخدمة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المحافظة: ${order.governorate}'),
            Text('المركز: ${order.center}'),
            Text('العنوان: ${order.address}'),
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
            _buildInfoRow('الهاتف', order.customerPhone),
            _buildInfoRow('العنوان', '${order.governorate} - ${order.center}'),
            _buildInfoRow('سبب الرفض', order.rejectionReason),
            _buildInfoRow('تاريخ الطلب', _formatDate(order.requestDate)),
            _buildInfoRow('تاريخ الرفض', _formatDate(order.rejectionDate)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.person, size: 18),
                    label: Text('ملف الفني'),
                    onPressed: () =>
                        _navigateToTechnicianProfile(order.technicianId),
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
