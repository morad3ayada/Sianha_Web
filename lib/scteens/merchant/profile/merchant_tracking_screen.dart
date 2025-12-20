import 'package:flutter/material.dart';

class MerchantTrackingScreen extends StatefulWidget {
  final Map<String, dynamic>? merchantData;
  final Map<String, dynamic>? orderData;

  const MerchantTrackingScreen({
    Key? key,
    this.merchantData,
    this.orderData,
  }) : super(key: key);

  @override
  _MerchantTrackingScreenState createState() => _MerchantTrackingScreenState();
}

// إضافة SingleTickerProviderStateMixin للتحكم في الأنيميشن
class _MerchantTrackingScreenState extends State<MerchantTrackingScreen>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  List<TrackingStep> steps = [];
  String _selectedLanguage = 'العربية';
  bool _isDarkMode = false;

  // متحكم لحركة "النبض" للخطوة الحالية
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeSteps();

    // إعداد حركة النبض (Pulse)
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _initializeSteps() {
    // نفس البيانات مع الحفاظ على التواريخ
    steps = [
      TrackingStep(
        title: _translateText('تم استلام الطلب'),
        description: _translateText('تم تأكيد استلام الطلب من التاجر'),
        icon: Icons.shopping_bag_outlined,
        isCompleted: true,
        isActive: false, // تم الانتهاء منها
        time: DateTime.now().subtract(Duration(minutes: 60)),
      ),
      TrackingStep(
        title: _translateText('تجهيز الطلب'),
        description: _translateText('جارٍ تحضير وتغليف المنتجات'),
        icon: Icons.inventory_2_outlined,
        isCompleted: true,
        isActive: false,
        time: DateTime.now().subtract(Duration(minutes: 45)),
      ),
      TrackingStep(
        title: _translateText('خرج للتوصيل'),
        description: _translateText('المندوب استلم الطلب وهو في الطريق'),
        icon: Icons.local_shipping_outlined,
        isCompleted: false,
        isActive: true, // هذه الخطوة الحالية (تتحرك)
        time: null,
      ),
      TrackingStep(
        title: _translateText('تم التوصيل'),
        description: _translateText('وصل الطلب للعميل بنجاح'),
        icon: Icons.check_circle_outline,
        isCompleted: false,
        isActive: false,
        time: null,
      ),
    ];
    // تحديث مؤشر الخطوة الحالية بناءً على البيانات
    _currentStep = steps.indexWhere((step) => step.isActive);
    if (_currentStep == -1)
      _currentStep = steps.where((s) => s.isCompleted).length;
  }

  String _translateText(String text) {
    // (نفس دالة الترجمة السابقة - اختصرتها هنا للتركيز على التصميم)
    return text;
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = _isDarkMode ? Color(0xFF1A1A2E) : Color(0xFFF5F7FA);
    Color textColor = _isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          _translateText('تتبع الطلب'),
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        leading: BackButton(color: textColor),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: textColor),
            onPressed: _refreshTracking,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMerchantHeader(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: _isDarkMode ? Color(0xFF16213E) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  )
                ],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 30, bottom: 20),
                child: Column(
                  children: [
                    // بناء الـ Timeline
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: steps.length,
                      itemBuilder: (context, index) {
                        return _buildTimelineStep(index);
                      },
                    ),
                    SizedBox(height: 30),
                    _buildOrderSummaryCard(),
                    SizedBox(height: 20),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[200],
              backgroundImage:
                  AssetImage('assets/merchant_logo.png'), // ضع صورة افتراضية
              child: Icon(Icons.store, color: Colors.blue[800]),
            ),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.merchantData?['name'] ?? 'متجر الإلكترونيات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(
                    " 4.8",
                    style: TextStyle(
                        color:
                            _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "موثوق",
                      style: TextStyle(color: Colors.green, fontSize: 10),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(int index) {
    final step = steps[index];
    bool isLast = index == steps.length - 1;
    bool isPast = index < _currentStep; // خطوات سابقة
    bool isCurrent = index == _currentStep; // الخطوة الحالية

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. التوقيت (العمود الأيمن)
          Container(
            width: 50,
            padding: EdgeInsets.only(top: 4),
            child: step.time != null
                ? Column(
                    children: [
                      Text(
                        "${step.time!.hour}:${step.time!.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      Text(
                        step.time!.hour >= 12 ? "PM" : "AM",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  )
                : SizedBox(),
          ),

          // 2. خط الزمن والأيقونة (العمود الأوسط)
          Column(
            children: [
              // الأيقونة الدائرية مع الأنيميشن
              ScaleTransition(
                scale:
                    isCurrent ? _pulseAnimation : AlwaysStoppedAnimation(1.0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isPast || isCurrent
                        ? Colors.blue
                        : (_isDarkMode ? Colors.grey[800] : Colors.grey[200]),
                    shape: BoxShape.circle,
                    boxShadow: (isCurrent)
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 2,
                            )
                          ]
                        : [],
                    border: Border.all(
                      color:
                          isPast || isCurrent ? Colors.blue : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    step.icon,
                    size: 20,
                    color:
                        isPast || isCurrent ? Colors.white : Colors.grey[400],
                  ),
                ),
              ),

              // الخط الواصل بين النقاط
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 3,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isPast ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(width: 15),

          // 3. تفاصيل البطاقة (العمود الأيسر)
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(bottom: 25),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCurrent
                    ? Colors.blue.withOpacity(0.05)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: isCurrent
                    ? Border.all(color: Colors.blue.withOpacity(0.3))
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    step.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "تكلفة الطلب",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                "500 ج.م",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(color: Colors.white30, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "رقم الطلب #8932",
                style: TextStyle(color: Colors.white70),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "الدفع عند الاستلام",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _updateStatus,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 5,
            ),
            child: Text(
              "تحديث الحالة",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
        SizedBox(width: 15),
        Container(
          decoration: BoxDecoration(
            color: _isDarkMode ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconButton(
            icon: Icon(Icons.call, color: Colors.green),
            onPressed: () {}, // اتصال بالمندوب
          ),
        ),
      ],
    );
  }

  void _updateStatus() {
    if (_currentStep < steps.length - 1) {
      setState(() {
        // الخطوة الحالية تصبح مكتملة وغير نشطة
        steps[_currentStep].isCompleted = true;
        steps[_currentStep].isActive = false;
        steps[_currentStep].time = DateTime.now();

        // الانتقال للخطوة التالية
        _currentStep++;
        steps[_currentStep].isActive = true; // تفعيل الأنيميشن للخطوة الجديدة
      });
    }
  }

  void _refreshTracking() {
    setState(() {
      _currentStep = 0;
      for (var i = 0; i < steps.length; i++) {
        steps[i].isCompleted = false;
        steps[i].isActive = (i == 0);
        steps[i].time = (i == 0) ? DateTime.now() : null;
      }
    });
  }
}

// تعديل بسيط في المودل لدعم الخاصية الجديدة
class TrackingStep {
  String title;
  String description;
  IconData icon;
  bool isCompleted;
  bool isActive; // خاصية جديدة لتحديد الخطوة الجارية الآن
  DateTime? time;

  TrackingStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.isCompleted,
    this.isActive = false,
    this.time,
  });
}
