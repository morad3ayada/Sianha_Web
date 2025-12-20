import 'package:flutter/material.dart';

class NewComplaintsScreen extends StatelessWidget {
  // قائمة الشكاوي الوهمية للعرض
  final List<Complaint> complaints = [
    Complaint(
      id: "COM-2024-001",
      governorate: "القاهرة",
      area: "الدقي",
      street: "شارع 6",
      problem: "الشكل وحش معايا",
      technicianName: "أحمد محمد",
      technicianPhone: "01234567890",
      customerName: "محمد علي",
      customerPhone: "01112223344",
      brokenItem: "تصميم واجهة التطبيق",
      status: "جديدة",
      timestamp: "2024-01-15 10:30",
    ),
    Complaint(
      id: "COM-2024-002",
      governorate: "الجيزة",
      area: "المهندسين",
      street: "شارع النصر",
      problem: "تطبيق بيعلق باستمرار",
      technicianName: "خالد محمود",
      technicianPhone: "01009876543",
      customerName: "سعيد عبدالله",
      customerPhone: "01001112233",
      brokenItem: "أداء التطبيق",
      status: "جديدة",
      timestamp: "2024-01-15 09:15",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الشكاوي الجديدة من جميع المحافظات"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickStats(),
            SizedBox(height: 16),
            Text(
              "الشكاوي الجديدة (${complaints.length})",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  return _buildComplaintCard(context, complaints[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem("إجمالي الشكاوي", complaints.length.toString(),
                Icons.report_problem),
            _buildStatItem(
                "القاهرة",
                complaints
                    .where((c) => c.governorate == "القاهرة")
                    .length
                    .toString(),
                Icons.location_city),
            _buildStatItem(
                "الجيزة",
                complaints
                    .where((c) => c.governorate == "الجيزة")
                    .length
                    .toString(),
                Icons.location_city),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 20),
        SizedBox(height: 4),
        Text(value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(title, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildComplaintCard(BuildContext context, Complaint complaint) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  complaint.id,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    complaint.status,
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  "${complaint.governorate} - ${complaint.area} - ${complaint.street}",
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "المشكلة:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    complaint.problem,
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            _buildInfoRow(
              "الفني:",
              "${complaint.technicianName} - ${complaint.technicianPhone}",
              Icons.engineering,
            ),
            _buildInfoRow(
              "الخربان:",
              complaint.brokenItem,
              Icons.build,
            ),
            _buildInfoRow(
              "العميل:",
              "${complaint.customerName} - ${complaint.customerPhone}",
              Icons.person,
            ),
            _buildInfoRow(
              "الوقت:",
              complaint.timestamp,
              Icons.access_time,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showComplaintDetails(context, complaint);
                    },
                    icon: Icon(Icons.remove_red_eye, size: 18),
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
                      _resolveComplaint(context, complaint);
                    },
                    icon: Icon(Icons.check_circle, size: 18),
                    label: Text("حل الشكوى"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon) {
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
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showComplaintDetails(BuildContext context, Complaint complaint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("تفاصيل الشكوى"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem("رقم الشكوى:", complaint.id),
              _buildDetailItem("المحافظة:", complaint.governorate),
              _buildDetailItem("المنطقة:", complaint.area),
              _buildDetailItem("الشارع:", complaint.street),
              _buildDetailItem("المشكلة:", complaint.problem),
              _buildDetailItem("الفني:", complaint.technicianName),
              _buildDetailItem("تليفون الفني:", complaint.technicianPhone),
              _buildDetailItem("العميل:", complaint.customerName),
              _buildDetailItem("تليفون العميل:", complaint.customerPhone),
              _buildDetailItem("الخربان:", complaint.brokenItem),
              _buildDetailItem("الوقت:", complaint.timestamp),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إغلاق"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resolveComplaint(context, complaint);
            },
            child: Text("حل الشكوى"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _resolveComplaint(BuildContext context, Complaint complaint) {
    // متغيرات لتخزين بيانات الموظف
    String employeeName = '';
    String employeePhone = '';
    String solutionNotes = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("حل الشكوى - تسجيل بيانات المعالج"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("الشكوى: ${complaint.id}"),
              SizedBox(height: 16),

              // بيانات الموظف المعالج
              Text("بيانات الموظف المعالج",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 12),

              TextField(
                decoration: InputDecoration(
                  labelText: "اسم الموظف *",
                  border: OutlineInputBorder(),
                  hintText: "أدخل اسمك الكامل",
                ),
                onChanged: (value) {
                  employeeName = value;
                },
              ),
              SizedBox(height: 12),

              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "رقم تليفون الموظف *",
                  border: OutlineInputBorder(),
                  hintText: "أدخل رقم تليفونك",
                ),
                onChanged: (value) {
                  employeePhone = value;
                },
              ),
              SizedBox(height: 16),

              // ملاحظات الحل
              Text("تفاصيل الحل",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 8),

              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "ملاحظات الحل *",
                  border: OutlineInputBorder(),
                  hintText: "اكتب هنا كيف تم حل المشكلة...",
                ),
                onChanged: (value) {
                  solutionNotes = value;
                },
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
              // التحقق من تعبئة جميع الحقول
              if (employeeName.isEmpty ||
                  employeePhone.isEmpty ||
                  solutionNotes.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("يرجى تعبئة جميع الحقول المطلوبة"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // هنا كود الإرسال للباك اند
              _sendToBackend(context, complaint, employeeName, employeePhone,
                  solutionNotes);
            },
            child: Text("تأكيد الحل وإرسال"),
          ),
        ],
      ),
    );
  }

  // دالة محاكاة إرسال البيانات للباك اند
  void _sendToBackend(BuildContext context, Complaint complaint,
      String employeeName, String employeePhone, String solutionNotes) {
    // محاكاة عملية التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("جاري إرسال البيانات..."),
          ],
        ),
      ),
    );

    // محاكاة انتظار الإرسال
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // إغلاق dialog التحميل
      Navigator.pop(context); // إغلاق dialog الحل

      // عرض رسالة النجاح
      _showSuccessMessage(context, complaint, employeeName, employeePhone);
    });
  }

  void _showSuccessMessage(BuildContext context, Complaint complaint,
      String employeeName, String employeePhone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("تم حل الشكوى ${complaint.id} بنجاح"),
            SizedBox(height: 4),
            Text("المعالج: $employeeName - $employeePhone",
                style: TextStyle(fontSize: 12)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: "عرض",
          onPressed: () {
            _showResolutionDetails(
                context, complaint, employeeName, employeePhone);
          },
        ),
      ),
    );
  }

  void _showResolutionDetails(BuildContext context, Complaint complaint,
      String employeeName, String employeePhone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("تفاصيل حل الشكوى"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem("رقم الشكوى:", complaint.id),
              _buildDetailItem("المحافظة:", complaint.governorate),
              _buildDetailItem("المنطقة:", complaint.area),
              _buildDetailItem("المشكلة:", complaint.problem),
              _buildDetailItem("الموظف المعالج:", employeeName),
              _buildDetailItem("تليفون الموظف:", employeePhone),
              _buildDetailItem("وقت الحل:", "${DateTime.now()}"),
              _buildDetailItem("الحالة:", "تم الحل"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("تم"),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("فلترة الشكاوي"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("اختر المحافظة:"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إغلاق"),
          ),
        ],
      ),
    );
  }
}

class Complaint {
  final String id;
  final String governorate;
  final String area;
  final String street;
  final String problem;
  final String technicianName;
  final String technicianPhone;
  final String customerName;
  final String customerPhone;
  final String brokenItem;
  final String status;
  final String timestamp;

  Complaint({
    required this.id,
    required this.governorate,
    required this.area,
    required this.street,
    required this.problem,
    required this.technicianName,
    required this.technicianPhone,
    required this.customerName,
    required this.customerPhone,
    required this.brokenItem,
    required this.status,
    required this.timestamp,
  });
}
