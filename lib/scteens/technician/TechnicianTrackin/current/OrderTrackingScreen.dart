import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  final String technicianName;
  final String governorate;
  final String center;
  final String serviceType;
  final String technicianPhone;

  const OrderTrackingScreen({
    Key? key,
    required this.orderId,
    required this.technicianName,
    required this.governorate,
    required this.center,
    required this.serviceType,
    required this.technicianPhone,
  }) : super(key: key);

  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  // حالة الطلب الحالية
  OrderStatus _currentStatus = OrderStatus.orderReceived;

  // قائمة مراحل الطلب
  final List<OrderStage> _orderStages = [
    OrderStage(
      status: OrderStatus.orderReceived,
      title: 'تم استلام الطلب',
      description: 'تم استلام طلبك بنجاح وجاري التجهيز',
      icon: Icons.shopping_cart_checkout,
      time: '10:30 ص',
    ),
    OrderStage(
      status: OrderStatus.technicianOnWay,
      title: 'الفني في الطريق',
      description: 'الفني متجه إلى موقعك حالياً',
      icon: Icons.directions_car,
      time: '11:15 ص',
    ),
    OrderStage(
      status: OrderStatus.technicianArrived,
      title: 'الفني وصل إلى الموقع',
      description: 'الفني وصل إلى موقعك وجاري التحضير',
      icon: Icons.location_on,
      time: '11:45 ص',
    ),
    OrderStage(
      status: OrderStatus.workInProgress,
      title: 'جاري تنفيذ الطلب',
      description: 'جاري العمل على طلبك',
      icon: Icons.build,
      time: '12:00 م',
    ),
    OrderStage(
      status: OrderStatus.priceEstimation,
      title: 'تقدير سعر الصيانة',
      description: 'جاري تحديد السعر النهائي للخدمة',
      icon: Icons.attach_money,
      time: 'قريباً',
    ),
    OrderStage(
      status: OrderStatus.payment,
      title: 'الدفع',
      description: 'اختر طريقة الدفع المناسبة',
      icon: Icons.payment,
      time: 'قريباً',
    ),
    OrderStage(
      status: OrderStatus.completed,
      title: 'تم الانتهاء بنجاح',
      description: 'تم إكمال الطلب بنجاح',
      icon: Icons.check_circle,
      time: 'قريباً',
    ),
  ];

  // طريقة الدفع المختارة
  PaymentMethod? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'متابعة الطلب #${widget.orderId}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: _shareOrderDetails,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎯 بطاقة معلومات الفني
            _buildTechnicianCard(),

            SizedBox(height: 20),

            // 📊 شريط تقدم الطلب
            _buildProgressIndicator(),

            SizedBox(height: 20),

            // 📋 مراحل الطلب
            _buildOrderStages(),

            SizedBox(height: 20),

            // 💰 قسم الدفع (يظهر فقط في المرحلة المناسبة)
            if (_currentStatus == OrderStatus.priceEstimation ||
                _currentStatus == OrderStatus.payment)
              _buildPaymentSection(),

            // 🎉 رسالة الإكمال (تظهر عند الانتهاء)
            if (_currentStatus == OrderStatus.completed) _buildCompletionCard(),
          ],
        ),
      ),

      // 🎛️ أزرار التحكم (تظهر حسب حالة الطلب)
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildTechnicianCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // صورة الفني
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[100],
                    // يمكن استبدالها بصورة حقيقية
                    image: DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/60'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12),

                // معلومات الفني
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.technicianName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${widget.serviceType} • ${widget.center}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        widget.governorate,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // زر الاتصال
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.phone, color: Colors.green),
                    onPressed: () => _callTechnician(),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // رقم الهاتف
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_android, size: 16, color: Colors.blue[700]),
                  SizedBox(width: 8),
                  Text(
                    widget.technicianPhone,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

  Widget _buildProgressIndicator() {
    final currentIndex =
        _orderStages.indexWhere((stage) => stage.status == _currentStatus);
    final progress = (currentIndex + 1) / _orderStages.length;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تقدم الطلب',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
              minHeight: 8,
            ),
            SizedBox(height: 8),
            Text(
              _getStatusText(_currentStatus),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStages() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مراحل الطلب',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            ..._orderStages.asMap().entries.map((entry) {
              final index = entry.key;
              final stage = entry.value;
              final isCompleted = index <=
                  _orderStages.indexWhere((s) => s.status == _currentStatus);
              final isCurrent = stage.status == _currentStatus;

              return _buildStageItem(stage, isCompleted, isCurrent);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStageItem(OrderStage stage, bool isCompleted, bool isCurrent) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // دائرة الحالة
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? Colors.blue[700] : Colors.grey[300],
              border: isCurrent
                  ? Border.all(color: Colors.blue[700]!, width: 2)
                  : null,
            ),
            child: Icon(
              stage.icon,
              color: isCompleted ? Colors.white : Colors.grey[500],
              size: 20,
            ),
          ),
          SizedBox(width: 12),

          // تفاصيل المرحلة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stage.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted ? Colors.grey[800] : Colors.grey[500],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  stage.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isCompleted ? Colors.grey[600] : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),

          // الوقت
          Text(
            stage.time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'طريقة الدفع',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),

            // خيارات الدفع
            _buildPaymentOption(
              'الدفع نقداً',
              'ادفع نقداً للفني عند الانتهاء',
              Icons.money,
              PaymentMethod.cash,
            ),
            SizedBox(height: 8),
            _buildPaymentOption(
              'الدفع الإلكتروني',
              'ادفع باستخدام البطاقة الإئتمانية',
              Icons.credit_card,
              PaymentMethod.electronic,
            ),

            SizedBox(height: 16),

            // السعر المقدر
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'السعر المقدر',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    '٢٥٠ جنيه',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
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

  Widget _buildPaymentOption(
      String title, String subtitle, IconData icon, PaymentMethod method) {
    final isSelected = _selectedPaymentMethod == method;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.blue[700] : Colors.grey[600]),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue[700] : Colors.grey[800],
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: Colors.blue[700]),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.green[50],
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.celebration, size: 60, color: Colors.green),
            SizedBox(height: 12),
            Text(
              'تم الانتهاء بنجاح! 🎉',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'شكراً لاستخدامك خدماتنا. نأمل أن نكون عند حسن ظنك',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
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
          // زر المساعدة
          Expanded(
            child: OutlinedButton.icon(
              icon: Icon(Icons.help_outline),
              label: Text('المساعدة'),
              onPressed: _showHelpOptions,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue[700],
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          SizedBox(width: 12),

          // الزر الرئيسي (يتغير حسب الحالة)
          Expanded(
            child: ElevatedButton(
              onPressed: _handleMainAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getActionButtonIcon()),
                  SizedBox(width: 8),
                  Text(_getActionButtonText()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دوال مساعدة - تم إصلاح الخطأ هنا
  IconData _getActionButtonIcon() {
    switch (_currentStatus) {
      case OrderStatus.payment:
        return Icons.payment;
      case OrderStatus.completed:
        return Icons.star;
      default:
        return Icons.refresh;
    }
  }

  String _getActionButtonText() {
    switch (_currentStatus) {
      case OrderStatus.payment:
        return 'تأكيد الدفع';
      case OrderStatus.completed:
        return 'تقييم الخدمة';
      default:
        return 'تحديث الحالة';
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.orderReceived:
        return 'جاري تجهيز طلبك';
      case OrderStatus.technicianOnWay:
        return 'الفني في الطريق إليك';
      case OrderStatus.technicianArrived:
        return 'الفني وصل إلى موقعك';
      case OrderStatus.workInProgress:
        return 'جاري العمل على طلبك';
      case OrderStatus.priceEstimation:
        return 'جاري تحديد السعر';
      case OrderStatus.payment:
        return 'بانتظار تأكيد الدفع';
      case OrderStatus.completed:
        return 'تم إكمال الطلب بنجاح';
    }
  }

  // معالجة الأحداث
  void _handleMainAction() {
    switch (_currentStatus) {
      case OrderStatus.payment:
        if (_selectedPaymentMethod != null) {
          setState(() {
            _currentStatus = OrderStatus.completed;
          });
          _showSuccessDialog();
        } else {
          _showError('يرجى اختيار طريقة الدفع');
        }
        break;
      case OrderStatus.completed:
        _rateService();
        break;
      default:
        _simulateNextStage();
    }
  }

  void _simulateNextStage() {
    final currentIndex =
        _orderStages.indexWhere((stage) => stage.status == _currentStatus);
    if (currentIndex < _orderStages.length - 1) {
      setState(() {
        _currentStatus = _orderStages[currentIndex + 1].status;
      });
    }
  }

  void _callTechnician() {
    // تنفيذ الاتصال بالفني
    print('Calling technician: ${widget.technicianPhone}');
  }

  void _shareOrderDetails() {
    // مشاركة تفاصيل الطلب
    print('Sharing order details');
  }

  void _showHelpOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.chat, color: Colors.blue),
              title: Text('الدعم الفني'),
              onTap: () {
                Navigator.pop(context);
                // فتح شات الدعم
              },
            ),
            ListTile(
              leading: Icon(Icons.report_problem, color: Colors.orange),
              title: Text('الإبلاغ عن مشكلة'),
              onTap: () {
                Navigator.pop(context);
                // فتح نموذج الإبلاغ
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: Colors.red),
              title: Text('إلغاء الطلب'),
              onTap: () {
                Navigator.pop(context);
                _cancelOrder();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _cancelOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إلغاء الطلب'),
        content: Text('هل أنت متأكد من إلغاء هذا الطلب؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('تراجع'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // العودة للشاشة السابقة
            },
            child: Text('تأكيد الإلغاء', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تم الدفع بنجاح'),
        content: Text('شكراً لك! تم تأكيد الدفع بنجاح.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _rateService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تقييم الخدمة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('كيف كانت تجربتك مع الفني؟'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [1, 2, 3, 4, 5]
                  .map((star) => IconButton(
                        icon: Icon(Icons.star, color: Colors.amber),
                        onPressed: () {
                          Navigator.pop(context);
                          _showThankYouMessage();
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showThankYouMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('شكراً لتقييمك!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

// الأنواع والتعدادات
enum OrderStatus {
  orderReceived,
  technicianOnWay,
  technicianArrived,
  workInProgress,
  priceEstimation,
  payment,
  completed,
}

enum PaymentMethod {
  cash,
  electronic,
}

class OrderStage {
  final OrderStatus status;
  final String title;
  final String description;
  final IconData icon;
  final String time;

  OrderStage({
    required this.status,
    required this.title,
    required this.description,
    required this.icon,
    required this.time,
  });
}
