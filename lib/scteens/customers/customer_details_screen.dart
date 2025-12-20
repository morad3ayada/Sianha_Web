import 'package:flutter/material.dart';
import 'edit_customer_screen.dart';
import 'customer_model.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final Customer customer;
  final Function(Customer) onCustomerUpdated;
  final Function(String) onCustomerDeleted;

  CustomerDetailsScreen({
    required this.customer,
    required this.onCustomerUpdated,
    required this.onCustomerDeleted,
  });

  @override
  _CustomerDetailsScreenState createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل العميل'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editCustomer,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteCustomer,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة معلومات العميل
            _buildCustomerInfoCard(),
            SizedBox(height: 24),

            // إحصائيات العميل
            _buildCustomerStats(),
            SizedBox(height: 24),

            // طلبات العميل
            _buildCustomerOrders(),
            SizedBox(height: 24),

            // سجل النشاط
            _buildActivityLog(),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildCustomerInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue[100],
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.customer.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildInfoRow(Icons.phone, widget.customer.phone),
                      _buildInfoRow(Icons.email, widget.customer.email),
                      _buildInfoRow(Icons.location_on, widget.customer.address),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem('تاريخ التسجيل',
                    '${widget.customer.registrationDate.day}/${widget.customer.registrationDate.month}/${widget.customer.registrationDate.year}'),
                _buildInfoItem(
                    'عدد الطلبات', '${widget.customer.orders.length}'),
                _buildInfoItem('الحالة', widget.customer.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إحصائيات العميل',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 3,
              children: [
                _buildStatItem('إجمالي المشتريات', '2,500 جنيه'),
                _buildStatItem('متوسط الطلب', '500 جنيه'),
                _buildStatItem('آخر طلب', 'قبل 3 أيام'),
                _buildStatItem('معدل التكرار', 'كل أسبوعين'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerOrders() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طلبات العميل',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                TextButton.icon(
                  onPressed: _viewAllOrders,
                  icon: Icon(Icons.list),
                  label: Text('عرض الكل'),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (widget.customer.orders.isEmpty)
              Center(
                child: Text(
                  'لا توجد طلبات سابقة',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              Column(
                children: widget.customer.orders
                    .take(3)
                    .map((order) => _buildOrderItem(order))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(String orderId) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green[100],
        child: Icon(Icons.shopping_cart, color: Colors.green),
      ),
      title: Text('طلب #$orderId'),
      subtitle: Text('500 جنيه - قبل 3 أيام'),
      trailing: Chip(
        label: Text('مكتمل', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildActivityLog() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'سجل النشاط',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 16),
            _buildActivityItem('تم تسجيل العميل', 'قبل شهر'),
            _buildActivityItem('تم إنشاء الطلب ORD-001', 'قبل 3 أسابيع'),
            _buildActivityItem('تم تحديث العنوان', 'قبل أسبوعين'),
            _buildActivityItem('تم إنشاء الطلب ORD-002', 'قبل 3 أيام'),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(child: Text(activity)),
          Text(time, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _contactCustomer,
              icon: Icon(Icons.phone),
              label: Text('اتصال'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _sendMessage,
              icon: Icon(Icons.message),
              label: Text('رسالة'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editCustomer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCustomerScreen(
          customer: widget.customer,
          onCustomerUpdated: (updatedCustomer) {
            widget.onCustomerUpdated(updatedCustomer);
            setState(() {
              // التحديث المحلي
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _deleteCustomer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف العميل'),
        content: Text('هل أنت متأكد من حذف العميل ${widget.customer.name}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onCustomerDeleted(widget.customer.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _viewAllOrders() {
    // الانتقال إلى شاشة طلبات العميل
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('طلبات العميل'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.customer.orders.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('طلب #${widget.customer.orders[index]}'),
                subtitle: Text('500 جنيه'),
                trailing: Chip(
                  label: Text('مكتمل'),
                  backgroundColor: Colors.green[100],
                ),
              );
            },
          ),
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

  void _contactCustomer() {
    // تنفيذ الاتصال
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اتصال بالعميل'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('اتصال بـ ${widget.customer.name}'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.phone, color: Colors.green),
                  onPressed: () {},
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.message, color: Colors.blue),
                  onPressed: () {},
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.chat, color: Colors.green),
                  onPressed: () {},
                  iconSize: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    // إرسال رسالة
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إرسال رسالة'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'اكتب رسالتك هنا...',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم إرسال الرسالة')),
              );
            },
            child: Text('إرسال'),
          ),
        ],
      ),
    );
  }
}
