import 'package:flutter/material.dart';

class ProcessingComplaintsScreen extends StatelessWidget {
  // قائمة الشكاوي قيد المعالجة
  final List<ProcessingComplaint> processingComplaints = [
    ProcessingComplaint(
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
      status: "قيد الإصلاح",
      timestamp: "2024-01-15 10:30",
      assignedEmployee: "محمود السيد",
      employeePhone: "01001112233",
      elapsedTime: "18 ساعة",
      priority: "عاجلة",
    ),
    ProcessingComplaint(
      id: "COM-2024-004",
      governorate: "الجيزة",
      area: "الدقى",
      street: "شارع الجامعة",
      problem: "تطبيق لا يعمل",
      technicianName: "خالد محمود",
      technicianPhone: "01009876543",
      customerName: "سارة أحمد",
      customerPhone: "01005556677",
      brokenItem: "تثبيت التطبيق",
      status: "بانتظار قطع غيار",
      timestamp: "2024-01-14 15:20",
      assignedEmployee: "أحمد فكري",
      employeePhone: "01208889900",
      elapsedTime: "28 ساعة",
      priority: "متوسطة",
    ),
    ProcessingComplaint(
      id: "COM-2024-005",
      governorate: "الإسكندرية",
      area: "سموحة",
      street: "شارع 45",
      problem: "خدمة الانترنت بطيئة",
      technicianName: "محمود السيد",
      technicianPhone: "01223344556",
      customerName: "علي حسن",
      customerPhone: "01113334455",
      brokenItem: "الراوتر",
      status: "تحت التشخيص",
      timestamp: "2024-01-15 08:00",
      assignedEmployee: "محمد أمين",
      employeePhone: "01002223344",
      elapsedTime: "14 ساعة",
      priority: "عادية",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الشكاوى قيد المعالجة"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // تحديث القائمة
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // إحصائيات سريعة
            _buildQuickStats(),
            SizedBox(height: 16),

            // عنوان القائمة
            Text(
              "الشكاوى تحت المتابعة (${processingComplaints.length})",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "المشاكل التي لم يتم حلها خلال 24 ساعة",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12),

            // قائمة الشكاوي قيد المعالجة
            Expanded(
              child: ListView.builder(
                itemCount: processingComplaints.length,
                itemBuilder: (context, index) {
                  return _buildProcessingComplaintCard(
                      context, processingComplaints[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    int urgentCount =
        processingComplaints.where((c) => c.priority == "عاجلة").length;
    int waitingParts = processingComplaints
        .where((c) => c.status == "بانتظار قطع غيار")
        .length;
    int underDiagnosis =
        processingComplaints.where((c) => c.status == "تحت التشخيص").length;

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
                "قيد المعالجة",
                processingComplaints.length.toString(),
                Icons.schedule,
                Colors.blue),
            _buildStatItem(
                "عاجلة", urgentCount.toString(), Icons.warning, Colors.orange),
            _buildStatItem("بانتظار قطع", waitingParts.toString(), Icons.build,
                Colors.red),
            _buildStatItem("تحت التشخيص", underDiagnosis.toString(),
                Icons.search, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        SizedBox(height: 4),
        Text(value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(title, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildProcessingComplaintCard(
      BuildContext context, ProcessingComplaint complaint) {
    Color statusColor = _getStatusColor(complaint.status);
    Color priorityColor = _getPriorityColor(complaint.priority);

    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس البطاقة - المعلومات الأساسية
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        complaint.id,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "${complaint.governorate} - ${complaint.area}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        complaint.status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        complaint.priority,
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),

            // المتابعة الزمنية
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[100]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "قيد المتابعة منذ:",
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                        Text(
                          "${complaint.elapsedTime}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800]),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.person, size: 16, color: Colors.blue),
                  SizedBox(width: 4),
                  Text(
                    "موظف المتابعة",
                    style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            // معلومات الفريق والمتابعة
            _buildTeamSection(complaint),
            SizedBox(height: 12),

            // المشكلة
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
                  SizedBox(height: 8),
                  Text(
                    "الخربان: ${complaint.brokenItem}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),

            // أزرار التحكم
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showComplaintDetails(context, complaint);
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
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _updateProgress(context, complaint);
                    },
                    icon: Icon(Icons.update, size: 16),
                    label: Text("تحديث"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _completeProcessing(context, complaint);
                    },
                    icon: Icon(Icons.check_circle, size: 16),
                    label: Text("إنهاء"),
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

  Widget _buildTeamSection(ProcessingComplaint complaint) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        children: [
          // موظف المتابعة
          _buildTeamMember(
            "موظف المتابعة",
            complaint.assignedEmployee,
            complaint.employeePhone,
            Icons.supervisor_account,
            Colors.blue,
          ),
          SizedBox(height: 8),
          // الفني
          _buildTeamMember(
            "الفني المنفذ",
            complaint.technicianName,
            complaint.technicianPhone,
            Icons.engineering,
            Colors.green,
          ),
          SizedBox(height: 8),
          // العميل
          _buildTeamMember(
            "العميل",
            complaint.customerName,
            complaint.customerPhone,
            Icons.person,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(
      String role, String name, String phone, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role,
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800]),
              ),
              Text(
                phone,
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "قيد الإصلاح":
        return Colors.blue;
      case "بانتظار قطع غيار":
        return Colors.orange;
      case "تحت التشخيص":
        return Colors.purple;
      case "قيد المراجعة":
        return Colors.yellow[700]!;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case "عاجلة":
        return Colors.red;
      case "متوسطة":
        return Colors.orange;
      case "عادية":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showComplaintDetails(
      BuildContext context, ProcessingComplaint complaint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("تفاصيل المتابعة"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem("رقم الشكوى:", complaint.id),
              _buildDetailItem("الحالة:", complaint.status),
              _buildDetailItem("الأهمية:", complaint.priority),
              _buildDetailItem("المحافظة:", complaint.governorate),
              _buildDetailItem("المنطقة:", complaint.area),
              _buildDetailItem("الشارع:", complaint.street),
              _buildDetailItem("المشكلة:", complaint.problem),
              _buildDetailItem("الخربان:", complaint.brokenItem),
              _buildDetailItem("موظف المتابعة:",
                  "${complaint.assignedEmployee} - ${complaint.employeePhone}"),
              _buildDetailItem("الفني:",
                  "${complaint.technicianName} - ${complaint.technicianPhone}"),
              _buildDetailItem("العميل:",
                  "${complaint.customerName} - ${complaint.customerPhone}"),
              _buildDetailItem("وقت البدء:", complaint.timestamp),
              _buildDetailItem("المدة المنقضية:", complaint.elapsedTime),
            ],
          ),
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

  void _updateProgress(BuildContext context, ProcessingComplaint complaint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("تحديث تقدم المعالجة"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("تحديث حالة الشكوى ${complaint.id}"),
            SizedBox(height: 16),
            // هنا يمكن إضافة حقول لتحديث التقدم
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("تم تحديث تقدم المعالجة"),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: Text("حفظ التحديث"),
          ),
        ],
      ),
    );
  }

  void _completeProcessing(
      BuildContext context, ProcessingComplaint complaint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("إنهاء المعالجة"),
        content: Text("هل تريد إنهاء معالجة الشكوى ${complaint.id}؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("تم إنهاء المعالجة بنجاح"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text("تأكيد الإنتهاء"),
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
            Text("خيارات الفلترة قريباً..."),
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

class ProcessingComplaint {
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
  final String assignedEmployee;
  final String employeePhone;
  final String elapsedTime;
  final String priority;

  ProcessingComplaint({
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
    required this.assignedEmployee,
    required this.employeePhone,
    required this.elapsedTime,
    required this.priority,
  });
}
