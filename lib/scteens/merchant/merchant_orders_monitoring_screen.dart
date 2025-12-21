import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/api/api_constants.dart';

class MerchantOrdersMonitoringScreen extends StatefulWidget {
  @override
  _MerchantOrdersMonitoringScreenState createState() => _MerchantOrdersMonitoringScreenState();
}

class _MerchantOrdersMonitoringScreenState extends State<MerchantOrdersMonitoringScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<dynamic> _orders = [];
  Map<String, List<dynamic>> _merchantOrders = {};
  
  // Cache merchant names to IDs map
  Map<String, String> _merchantNames = {};

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Using standard http request as user provided specific curl
      // Assuming FinancialService has getToken or similar, but for now lets try to use ApiService methodology or just raw http with standard token if possible.
      // The user provided a specific hardcoded token in the curl, but in the app we should use the logged in user's token.
      // However, the user specifically shared a curl command. I will use the app's standard way of fetching with token.
      
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(ApiConstants.tokenKey);
      
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/Orders/GetAllOrders?Role=3'),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      print('---------------- MERCHANT ORDERS API ----------------');
      print('URL: ${response.request?.url}');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        List<dynamic>? ordersList;
        if (data is List) {
          ordersList = data;
        } else if (data is Map<String, dynamic>) {
           if (data.containsKey('data') && data['data'] is List) {
             ordersList = data['data'];
           } else if (data.containsKey('items') && data['items'] is List) {
             ordersList = data['items'];
           } else if (data.containsKey('value') && data['value'] is List) {
             ordersList = data['value'];
           }
        }

        if (ordersList != null) {
          _processOrders(ordersList);
        } else {
             print("Unexpected JSON format: ${data.runtimeType}");
             setState(() {
               _isLoading = false;
               _errorMessage = "تنسيق البيانات غير متوقع: ${data.runtimeType}";
             });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "فشل تحميل البيانات: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "حدث خطأ: $e";
      });
    }
  }

  void _processOrders(List<dynamic> data) {
    Map<String, List<dynamic>> groupedInfo = {};
    Map<String, String> namesMap = {};

    for (var order in data) {
      // Group by Merchant Shop Name or ID. User said display merchantShopName.
      // We will use merchantShopName as key for display, assume it exists.
      // If merchantId exists, it's better to group by that, but let's stick to name for display requirements.
      // Actually, relying on name is risky if duplicates. Let's try to find a unique ID.
      // Order usually has 'technicianId' (which might be merchantId in this Role=3 context?) or 'merchantId'.
      // Scanning previous order models... order structure typically has 'technicianId' but for Role 3 it might be different.
      // Let's assume grouping by 'merchantShopName' as requested for the cards.
      
      final shopName = order['merchantShopName'] ?? 'متجر غير معروف';
      
      if (!groupedInfo.containsKey(shopName)) {
        groupedInfo[shopName] = [];
      }
      groupedInfo[shopName]!.add(order);
    }

    if (mounted) {
      setState(() {
        _orders = data;
        _merchantOrders = groupedInfo;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: _fetchOrders, child: Text("إعادة المحاولة"))
          ],
        ),
      );
    }

    if (_merchantOrders.isEmpty) {
      return Center(child: Text("لا توجد بيانات متاجر"));
    }

    return Scaffold(
      backgroundColor: Colors.grey[50], // Background matching other screens
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "متابعة المتاجر",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: _merchantOrders.length,
                itemBuilder: (context, index) {
                  String shopName = _merchantOrders.keys.elementAt(index);
                  List<dynamic> orders = _merchantOrders[shopName]!;
                  return _buildMerchantCard(shopName, orders);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantCard(String shopName, List<dynamic> orders) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MerchantStatsDetailScreen(
                merchantName: shopName,
                orders: orders,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.store, size: 50, color: Colors.blue[700]),
              SizedBox(height: 12),
              Text(
                shopName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text(
                "${orders.length} طلبات",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MerchantStatsDetailScreen extends StatelessWidget {
  final String merchantName;
  final List<dynamic> orders;

  const MerchantStatsDetailScreen({
    Key? key,
    required this.merchantName,
    required this.orders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate Stats
    double totalAmount = 0;
    int completedCount = 0;
    int pendingCount = 0;

    for (var order in orders) {
      // 4 = completed
      if (order['orderStatus'] == 4) {
        completedCount++;
      } else {
        pendingCount++;
      }
      
      // Calculate price
      totalAmount += (order['price'] ?? 0);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(merchantName),
        backgroundColor: Colors.yellow[800],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Stats Cards
            Row(
              children: [
                Expanded(child: _buildStatCard("مجموع المبالغ", "$totalAmount ج.م", Colors.green)),
                SizedBox(width: 10),
                Expanded(child: _buildStatCard("إجمالي الطلبات", "${orders.length}", Colors.blue)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildStatCard("منتهية", "$completedCount", Colors.orange)),
                SizedBox(width: 10),
                Expanded(child: _buildStatCard("جاري/معلق", "$pendingCount", Colors.redAccent)),
              ],
            ),
            
            SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "تفاصيل الطلبات",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: orders.length,
              separatorBuilder: (ctx, idx) => SizedBox(height: 10),
              itemBuilder: (ctx, idx) {
                final order = orders[idx];
                return _buildOrderCard(order);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(dynamic order) {
    String status = "غير محدد";
    Color statusColor = Colors.grey;

    switch (order['orderStatus']) {
      case 0: status = "قيد الانتظار"; statusColor = Colors.orange; break;
      case 1: status = "تمت الموافقة"; statusColor = Colors.blue; break;
      case 2: status = "جاري العمل"; statusColor = Colors.indigo; break;
      case 3: status = "قيد التنفيذ"; statusColor = Colors.purple; break;
      case 4: status = "مكتمل"; statusColor = Colors.green; break;
      case 5: status = "ملغي"; statusColor = Colors.red; break;
      case 6: status = "مرفوض"; statusColor = Colors.red[900]!; break;
    }

    // Extract product details from orderedProducts if available
    dynamic product;
    if (order['orderedProducts'] != null && order['orderedProducts'] is List && (order['orderedProducts'] as List).isNotEmpty) {
      product = order['orderedProducts'][0];
    }

    final productName = product != null ? product['productName'] : (order['productName'] ?? 'منتج غير محدد');
    final quantity = product != null ? product['quantity'] : (order['quantity'] ?? 1);
    final productImageUrl = product != null ? product['productImageUrl'] : order['productImageUrl'];
    
    // PayWay might be on order level usually, but check product just in case? No, usually order.
    // User didn't specify payWay is in orderedProducts, only productName. But orderedProducts usually contains the cart items. 
    // Let's assume payWay is on root.
    
    String payWayText = "غير محدد";
    int? payWay = order['payWay']; 
    if (payWay == 0) payWayText = "كاش";
    else if (payWay == 1) payWayText = "اونلاين";

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    productName ?? 'منتج غير محدد',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.5)),
                  ),
                  child: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Divider(),
            if (order['title'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text("العنوان الرئيسي: ${order['title']}", style: TextStyle(fontWeight: FontWeight.w500)),
              ),
            Text("العميل: ${order['customerName'] ?? 'غير محدد'}"),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.payment, size: 16, color: Colors.grey[700]),
                SizedBox(width: 4),
                Text("الدفع: $payWayText", style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(width: 16),
                Icon(Icons.shopping_bag, size: 16, color: Colors.grey[700]),
                SizedBox(width: 4),
                Text("الكمية: $quantity"),
              ],
            ),
            SizedBox(height: 8),
            if (productImageUrl != null && productImageUrl.toString().isNotEmpty)
              InkWell(
                onTap: () async {
                   String urlString = productImageUrl.toString();
                   if (!urlString.startsWith('http')) {
                     if (urlString.startsWith('/')) {
                        urlString = '${ApiConstants.baseUrl}$urlString';
                     } else {
                        urlString = '${ApiConstants.baseUrl}/$urlString';
                     }
                   }
                   
                   final url = Uri.parse(urlString);
                   if (await canLaunchUrl(url)) {
                     await launchUrl(url);
                   } else {
                     print("Could not launch $url");
                   }
                },
                child: Row(
                  children: [
                    Icon(Icons.link, color: Colors.blue, size: 20),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "عرض صورة المنتج",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("التاريخ: ${order['createdAt']?.split('T')[0] ?? ''}", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  "${order['price'] ?? 0} ج.م",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
