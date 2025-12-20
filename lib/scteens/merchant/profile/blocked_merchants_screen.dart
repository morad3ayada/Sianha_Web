import 'package:flutter/material.dart';

class BlockedMerchantsScreen extends StatefulWidget {
  @override
  State<BlockedMerchantsScreen> createState() => _BlockedMerchantsScreenState();
}

class _BlockedMerchantsScreenState extends State<BlockedMerchantsScreen> {
  final List<Map<String, dynamic>> blockedMerchants = [
    {
      "id": "MER-001",
      "name": "محل الأمل للأجهزة",
      "phone": "01234567890",
      "address": "القاهرة - المعادي",
      "blockReason": "عدم الالتزام بمواعيد التسليم",
      "blockedBy": "أحمد محمد",
      "employeeId": "EMP-2024",
      "blockDate": "2024-01-15",
      "status": "محظور دائم"
    },
    {
      "id": "MER-002", 
      "name": "سوق التكنولوجيا",
      "phone": "01009876543",
      "address": "الجيزة - الدقي",
      "blockReason": "شكاوى متكررة من العملاء",
      "blockedBy": "محمد علي",
      "employeeId": "EMP-2023",
      "blockDate": "2024-01-10",
      "status": "محظور مؤقت"
    },
    {
      "id": "MER-003",
      "name": "شركة التقنية المتطورة",
      "phone": "01112223344", 
      "address": "الإسكندرية - سموحة",
      "blockReason": "تزويد منتجات مغشوشة",
      "blockedBy": "سارة أحمد",
      "employeeId": "EMP-2024",
      "blockDate": "2024-01-05",
      "status": "محظور دائم"
    }
  ];

  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("التجار المحظورين"),
        backgroundColor: Colors.red,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showBlockMerchantDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // إحصائيات سريعة
          _buildStatsCard(),
          SizedBox(height: 16),
          
          // عنوان القائمة
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.block, color: Colors.red, size: 20),
                SizedBox(width: 8),
                Text(
                  "قائمة التجار المحظورين",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Spacer(),
                Text(
                  "${blockedMerchants.length} تاجر",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          
          // قائمة التجار المحظورين
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: blockedMerchants.length,
              itemBuilder: (context, index) {
                final merchant = blockedMerchants[index];
                return _buildBlockedMerchantCard(merchant, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    int permanentBlocks = blockedMerchants.where((m) => m["status"] == "محظور دائم").length;
    int temporaryBlocks = blockedMerchants.where((m) => m["status"] == "محظور مؤقت").length;

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red[50]!, Colors.red[100]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "إحصائيات الحظر",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[800],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("إجمالي المحظورين", blockedMerchants.length.toString(), Icons.block),
              _buildStatItem("حظر دائم", permanentBlocks.toString(), Icons.do_not_disturb),
              _buildStatItem("حظر مؤقت", temporaryBlocks.toString(), Icons.timer),
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
            color: Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.red, size: 20),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red[800],
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: Colors.red[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBlockedMerchantCard(Map<String, dynamic> merchant, int index) {
    Color statusColor = merchant["status"] == "محظور دائم" ? Colors.red : Colors.orange;
    
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.red.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // رأس البطاقة
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.block, color: Colors.red, size: 20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          merchant["name"],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          merchant["id"],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
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
                      merchant["status"],
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // معلومات التاجر
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildMerchantInfoRow("الهاتف:", merchant["phone"], Icons.phone),
                  _buildMerchantInfoRow("العنوان:", merchant["address"], Icons.location_on),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 8),
                  _buildMerchantInfoRow("سبب الحظر:", merchant["blockReason"], Icons.warning),
                  _buildMerchantInfoRow("تم الحظر بواسطة:", merchant["blockedBy"], Icons.person),
                  _buildMerchantInfoRow("رقم الموظف:", merchant["employeeId"], Icons.badge),
                  _buildMerchantInfoRow("تاريخ الحظر:", merchant["blockDate"], Icons.calendar_today),
                ],
              ),
            ),
            
            // أزرار التحكم
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showMerchantDetails(context, merchant);
                      },
                      icon: Icon(Icons.remove_red_eye, size: 16),
                      label: Text("تفاصيل"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showUnblockDialog(context, merchant);
                      },
                      icon: Icon(Icons.lock_open, size: 16),
                      label: Text("إلغاء الحظر"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantInfoRow(String title, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBlockMerchantDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.block, color: Colors.red),
            SizedBox(width: 8),
            Text("حظر تاجر جديد"),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "اسم التاجر",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: "رقم الهاتف",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "سبب الحظر *",
                  border: OutlineInputBorder(),
                  hintText: "أدخل سبب حظر التاجر...",
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _employeeNameController,
                decoration: InputDecoration(
                  labelText: "اسم الموظف *",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _employeeIdController,
                decoration: InputDecoration(
                  labelText: "رقم الموظف *",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "* الحقول مطلوبة",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_reasonController.text.isEmpty || 
                  _employeeNameController.text.isEmpty || 
                  _employeeIdController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("يرجى تعبئة جميع الحقول المطلوبة"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              // إضافة التاجر المحظور
              setState(() {
                blockedMerchants.insert(0, {
                  "id": "MER-${blockedMerchants.length + 1}",
                  "name": "تاجر جديد",
                  "phone": "01000000000",
                  "address": "عنوان جديد",
                  "blockReason": _reasonController.text,
                  "blockedBy": _employeeNameController.text,
                  "employeeId": _employeeIdController.text,
                  "blockDate": "2024-01-20",
                  "status": "محظور دائم"
                });
              });
              
              // تنظيف الحقول
              _reasonController.clear();
              _employeeNameController.clear();
              _employeeIdController.clear();
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("تم حظر التاجر بنجاح"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text("تأكيد الحظر"),
          ),
        ],
      ),
    );
  }

  void _showMerchantDetails(BuildContext context, Map<String, dynamic> merchant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
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
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "تفاصيل التاجر المحظور",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16),
              _buildDetailItem("اسم التاجر:", merchant["name"]),
              _buildDetailItem("رقم التاجر:", merchant["id"]),
              _buildDetailItem("الهاتف:", merchant["phone"]),
              _buildDetailItem("العنوان:", merchant["address"]),
              _buildDetailItem("سبب الحظر:", merchant["blockReason"]),
              _buildDetailItem("تم الحظر بواسطة:", merchant["blockedBy"]),
              _buildDetailItem("رقم الموظف:", merchant["employeeId"]),
              _buildDetailItem("تاريخ الحظر:", merchant["blockDate"]),
              _buildDetailItem("الحالة:", merchant["status"]),
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
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showUnblockDialog(BuildContext context, Map<String, dynamic> merchant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.lock_open, color: Colors.green),
            SizedBox(width: 8),
            Text("إلغاء حظر التاجر"),
          ],
        ),
        content: Text("هل تريد إلغاء حظر التاجر ${merchant["name"]}؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                blockedMerchants.remove(merchant);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("تم إلغاء حظر التاجر بنجاح"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text("تأكيد الإلغاء"),
          ),
        ],
      ),
    );
  }
}