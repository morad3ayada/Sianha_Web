import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../financial/reports_service.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ReportsService _reportsService = ReportsService();
  List<ReportModel> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final reports = await _reportsService.getReports();
      if (!mounted) return;
      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تحميل التقييمات: $e')),
      );
    }
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('تقييمات العملاء', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.yellow[700],
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchReports,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.yellow[700],
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.white, size: 28),
                SizedBox(width: 10),
                Text(
                  'إجمالي التقييمات: ${_reports.length}',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading 
              ? Center(child: CircularProgressIndicator(color: Colors.yellow[700]))
              : _reports.isEmpty
                ? Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.rate_review_outlined, size: 80, color: Colors.grey[300]),
                      SizedBox(height: 10),
                      Text('لا توجد تقييمات حالياً', style: TextStyle(color: Colors.grey[500])),
                    ],
                  ))
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _reports.length,
                    itemBuilder: (context, index) {
                      final report = _reports[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildRatingStars(report.rate ?? 0.0),
                                  Text(
                                    report.customerName ?? 'مستخدم غير معروف',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ],
                              ),
                              if (report.title != null && report.title!.isNotEmpty) ...[
                                SizedBox(height: 8),
                                Text(
                                  report.title!,
                                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.yellow[900]),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                              SizedBox(height: 10),
                              Divider(),
                              if (report.technicianName != null) ...[
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      report.technicianName!,
                                      style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(Icons.person, size: 16, color: Colors.grey),
                                    Text(' :الفني المقيّم', style: TextStyle(color: Colors.grey[600])),
                                  ],
                                ),
                              ],
                              if (report.comment != null && report.comment!.isNotEmpty) ...[
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    report.comment!,
                                    style: TextStyle(color: Colors.black87),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    report.createdAt != null && report.createdAt!.length >= 10 
                                      ? report.createdAt!.substring(0, 10) 
                                      : 'تاريخ غير متوفر',
                                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[400]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
