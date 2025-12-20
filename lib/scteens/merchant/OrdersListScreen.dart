import 'package:flutter/material.dart';
import 'profile/merchant_profile_screen.dart';
// 1. استيراد شاشة التتبع الجديدة
import 'profile/merchant_tracking_screen.dart';

class TodayOrdersScreen extends StatelessWidget {
  // بيانات وهمية للفواتير مع customerId
  final List<Map<String, dynamic>> invoices = [
    {
      "id": "INV-2024-001",
      "type": "بيع جملة",
      "storeName": "محل الأمل للأجهزة",
      "storePhone": "01234567890",
      "customerName": "محمد أحمد",
      "customerAddress": "القاهرة - المعادي - شارع 9",
      "rating": 4.5,
      "totalAmount": 12500,
      "itemsCount": 15,
      "date": "2024-01-15",
      "status": "مكتمل",
      "customerId": "CUST-001",
      "items": [
        {"name": "تلفزيون LED 55 بوصة", "quantity": 2, "price": 4000},
        {"name": "غسالة أتوماتيك", "quantity": 1, "price": 3500},
        {"name": "ثلاجة 20 قدم", "quantity": 1, "price": 5000},
      ]
    },
    {
      "id": "INV-2024-002",
      "type": "بيع تجزئة",
      "storeName": "سوق التكنولوجيا",
      "storePhone": "01009876543",
      "customerName": "أحمد محمود",
      "customerAddress": "الجيزة - الدقي - شارع الجامعة",
      "rating": 4.2,
      "totalAmount": 8300,
      "itemsCount": 8,
      "date": "2024-01-15",
      "status": "قيد التجهيز",
      "customerId": "CUST-002",
      "items": [
        {"name": "لابتوب ديل", "quantity": 1, "price": 6000},
        {"name": "ماوس لاسلكي", "quantity": 2, "price": 500},
        {"name": "كيبورد", "quantity": 1, "price": 800},
      ]
    },
  ];

  // دالة للانتقال إلى شاشة الملف الشخصي
  void _navigateToProfile(BuildContext context, String customerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MerchantProfileScreen(),
      ),
    );
  }

  // 2. دالة للانتقال إلى شاشة التتبع
  void _navigateToTracking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // تأكد أن اسم الكلاس داخل ملف merchant_tracking_screen.dart هو MerchantTrackingScreen
        builder: (_) => MerchantTrackingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("فواتير البضاعة"),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildQuickStats(),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.receipt_long, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text(
                  "الفواتير الحديثة",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Spacer(),
                Text(
                  "${invoices.length} فاتورة",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoices[index];
                return _buildInvoiceCard(context, invoice);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    double totalRevenue = invoices.fold(
        0, (sum, invoice) => sum + (invoice["totalAmount"] as int).toDouble());
    int completedInvoices =
        invoices.where((inv) => inv["status"] == "مكتمل").length;
    int totalItems = invoices.fold(
        0, (sum, invoice) => sum + (invoice["itemsCount"] as int));

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[100]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "إحصائيات الفواتير",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("إجمالي المبيعات", "${totalRevenue.toInt()} ج",
                  Icons.attach_money),
              _buildStatItem(
                  "فواتير مكتملة", "$completedInvoices", Icons.check_circle),
              _buildStatItem("المنتجات", "$totalItems", Icons.inventory_2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue, size: 20),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: Colors.blue[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceCard(BuildContext context, Map<String, dynamic> invoice) {
    Color statusColor = _getStatusColor(invoice["status"]);

    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          _showInvoiceDetails(context, invoice);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.withOpacity(0.1), width: 1),
          ),
          child: Column(
            children: [
              // رأس الفاتورة
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.receipt, color: Colors.blue, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invoice["id"],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          invoice["type"],
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      invoice["status"],
                      style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                  "المحل:",
                  "${invoice["storeName"]} - ${invoice["storePhone"]}",
                  Icons.store),
              SizedBox(height: 8),
              _buildInfoRow("العميل:", invoice["customerName"], Icons.person),
              SizedBox(height: 4),
              _buildInfoRow(
                  "العنوان:", invoice["customerAddress"], Icons.location_on),
              SizedBox(height: 8),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(invoice["rating"].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700])),
                    ],
                  ),
                  Spacer(),
                  Text("${invoice["totalAmount"]} ج",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700])),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text("${invoice["itemsCount"]} منتج",
                        style: TextStyle(fontSize: 12, color: Colors.blue)),
                  ),
                ],
              ),
              SizedBox(height: 12), // زودت المسافة شوية عشان الزراير

              // ---------------------------------------------
              // 3. هنا ضفنا زر التتبع مع باقي الزراير
              // ---------------------------------------------
              SingleChildScrollView(
                // ضفت ده عشان لو الشاشة صغيرة الزراير متعملش مشكلة
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // زر الملف الشخصي (صغرته شوية)
                    ElevatedButton(
                      onPressed: () {
                        _navigateToProfile(
                            context, invoice["customerId"] ?? "CUST-000");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: Size(0, 36),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 16),
                          SizedBox(width: 4),
                          Text("العميل", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),

                    SizedBox(width: 8),

                    // >>> زر التتبع الجديد <<<
                    ElevatedButton(
                      onPressed: () {
                        _navigateToTracking(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700], // لون مميز للتتبع
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: Size(0, 36),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, size: 16),
                          SizedBox(width: 4),
                          Text("تتبع", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),

                    SizedBox(width: 8),

                    // زر المنتجات
                    OutlinedButton(
                      onPressed: () {
                        _showInvoiceItems(context, invoice);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: BorderSide(color: Colors.blue),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: Size(0, 36),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.list_alt, size: 16),
                          SizedBox(width: 4),
                          Text("المنتجات", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold)),
              Text(value,
                  style: TextStyle(fontSize: 14, color: Colors.grey[800])),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "مكتمل":
        return Colors.green;
      case "قيد التجهيز":
        return Colors.orange;
      case "ملغي":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showInvoiceDetails(BuildContext context, Map<String, dynamic> invoice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2))),
              ),
              SizedBox(height: 20),
              Text("تفاصيل الفاتورة",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800])),
              SizedBox(height: 16),
              _buildDetailItem("رقم الفاتورة:", invoice["id"]),
              _buildDetailItem("نوع الفاتورة:", invoice["type"]),
              _buildDetailItem("المحل:", invoice["storeName"]),
              _buildDetailItem("تليفون المحل:", invoice["storePhone"]),
              _buildDetailItem("العميل:", invoice["customerName"]),
              _buildDetailItem("العنوان:", invoice["customerAddress"]),
              _buildDetailItem("التقييم:", invoice["rating"].toString()),
              _buildDetailItem(
                  "إجمالي المبلغ:", "${invoice["totalAmount"]} جنيه"),
              _buildDetailItem(
                  "عدد المنتجات:", "${invoice["itemsCount"]} منتج"),
              _buildDetailItem("التاريخ:", invoice["date"]),
              _buildDetailItem("الحالة:", invoice["status"]),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 120,
              child: Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey[700]))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showInvoiceItems(BuildContext context, Map<String, dynamic> invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("منتجات الفاتورة"),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...invoice["items"]
                  .map<Widget>((item) => Card(
                        child: ListTile(
                          leading: Icon(Icons.inventory, color: Colors.blue),
                          title: Text(item["name"]),
                          subtitle: Text("الكمية: ${item["quantity"]}"),
                          trailing: Text("${item["price"]} ج"),
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("إغلاق")),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("فلترة الفواتير"),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
              leading: Icon(Icons.all_inclusive, color: Colors.blue),
              title: Text("الكل"),
              onTap: () => Navigator.pop(context)),
          ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text("مكتمل"),
              onTap: () => Navigator.pop(context)),
          ListTile(
              leading: Icon(Icons.schedule, color: Colors.orange),
              title: Text("قيد التجهيز"),
              onTap: () => Navigator.pop(context)),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("إغلاق"))
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("بحث في الفواتير"),
        content: TextField(
            decoration: InputDecoration(
                hintText: "ابحث برقم الفاتورة أو اسم العميل...",
                prefixIcon: Icon(Icons.search))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("إلغاء")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: Text("بحث")),
        ],
      ),
    );
  }
}
