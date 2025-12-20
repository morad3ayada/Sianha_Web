import 'package:flutter/material.dart';
import '../../models/order_model.dart';

class PendingOrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onShowTechnicians;
  final VoidCallback onDetails;

  const PendingOrderCard({
    Key? key,
    required this.order,
    required this.onShowTechnicians,
    required this.onDetails,
  }) : super(key: key);

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(dateStr);
      String year = dt.year.toString();
      String month = dt.month.toString().padLeft(2, '0');
      String day = dt.day.toString().padLeft(2, '0');
      
      int hour = dt.hour;
      int minute = dt.minute;
      String amPm = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      
      String hourStr = hour.toString().padLeft(2, '0');
      String minuteStr = minute.toString().padLeft(2, '0');
      
      return "$year-$month-$day $hourStr:$minuteStr $amPm";
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.title ?? "طلب بدون عنوان",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "قيد الانتظار",
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Updated Date Display
            _buildRow(Icons.calendar_today, "${_formatDate(order.createdAt)}"),
            _buildRow(Icons.monetization_on, " ${order.price?.toStringAsFixed(0) ?? '0'} جنيه"),
            _buildRow(Icons.location_on, " ${order.governorateName ?? 'N/A'}"),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onShowTechnicians,
                    icon: Icon(Icons.people, size: 16),
                    label: Text("الفنيين"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onDetails,
                    icon: Icon(Icons.info_outline, size: 16),
                    label: Text("تفاصيل"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700], // Changed color to distinguish
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          SizedBox(width: 6),
          Expanded(child: Text(text, style: TextStyle(color: Colors.grey[700], fontSize: 14), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
