import 'package:flutter/material.dart';

class TowTrackingScreen extends StatefulWidget {
  final Map<String, dynamic>? towData;

  const TowTrackingScreen({Key? key, this.towData}) : super(key: key);

  @override
  _TowTrackingScreenState createState() => _TowTrackingScreenState();
}

class _TowTrackingScreenState extends State<TowTrackingScreen> {
  int _currentStep = 0;
  List<TrackingStep> steps = [];

  @override
  void initState() {
    super.initState();
    _initializeSteps();
  }

  void _initializeSteps() {
    steps = [
      TrackingStep('استلام الطلب', Icons.check_circle, true,
          DateTime.now().subtract(Duration(minutes: 30))),
      TrackingStep('التحرك', Icons.directions_car, false, null),
      TrackingStep('على وصول', Icons.location_on, false, null),
      TrackingStep('الوصول', Icons.flag, false, null),
      TrackingStep('رفع السيارة', Icons.arrow_upward, false, null),
      TrackingStep('استلام الدفع', Icons.payment, false, null),
      TrackingStep('التسليم', Icons.done_all, false, null),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تتبع الونش'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshTracking,
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: _showMap,
          ),
        ],
      ),
      body: Column(
        children: [
          // معلومات الونش
          _buildTowInfo(),

          // Stepper للتتبع
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: _nextStep,
                onStepCancel: _previousStep,
                controlsBuilder: (context, details) {
                  return Row(
                    children: [
                      if (_currentStep < steps.length - 1)
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text('التالي'),
                        ),
                      SizedBox(width: 8),
                      if (_currentStep > 0)
                        OutlinedButton(
                          onPressed: details.onStepCancel,
                          child: Text('السابق'),
                        ),
                    ],
                  );
                },
                steps: steps.map((step) {
                  return Step(
                    title: Text(
                      step.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: step.time != null
                        ? Text(
                            '${step.time!.hour}:${step.time!.minute.toString().padLeft(2, '0')}')
                        : null,
                    content: Container(),
                    state: step.isCompleted
                        ? StepState.complete
                        : StepState.indexed,
                    isActive: steps.indexOf(step) == _currentStep,
                  );
                }).toList(),
              ),
            ),
          ),

          // معلومات إضافية
          _buildAdditionalInfo(),
        ],
      ),
    );
  }

  Widget _buildTowInfo() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.orange[100],
              child: Icon(Icons.local_shipping, size: 30, color: Colors.orange),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.towData?['name'] ?? 'ونش 101',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      '${widget.towData?['governorate'] ?? 'القاهرة'} - ${widget.towData?['area'] ?? 'مدينة نصر'}'),
                  Text(
                      'السائق: ${widget.towData?['driverName'] ?? 'محمد أحمد'}'),
                  Text('الهاتف: ${widget.towData?['phone'] ?? '01234567890'}'),
                ],
              ),
            ),
            Chip(
              label: Text(
                widget.towData?['status'] ?? 'متاح',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor:
                  _getStatusColor(widget.towData?['status'] ?? 'متاح'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تفاصيل الرحلة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child:
                      _buildInfoItem('المسافة', '5 كم', Icons.directions_car),
                ),
                Expanded(
                  child:
                      _buildInfoItem('الوقت المتوقع', '45 دقيقة', Icons.timer),
                ),
                Expanded(
                  child: _buildInfoItem('التكلفة', '300 جنيه', Icons.money),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                      'نقطة الانطلاق', 'الدقي', Icons.location_on),
                ),
                Expanded(
                  child: _buildInfoItem(
                      'الوجهة', 'مدينة نصر', Icons.location_searching),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  void _nextStep() {
    if (_currentStep < steps.length - 1) {
      setState(() {
        _currentStep++;
        steps[_currentStep].isCompleted = true;
        steps[_currentStep].time = DateTime.now();
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _refreshTracking() {
    setState(() {
      _currentStep = 0;
      steps.forEach((step) => step.isCompleted = false);
      steps[0].isCompleted = true;
      steps[0].time = DateTime.now();
    });
  }

  void _showMap() {
    // عرض الخريطة
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'متاح':
        return Colors.green;
      case 'مشغول':
        return Colors.red;
      case 'في الطريق':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class TrackingStep {
  final String title;
  final IconData icon;
  bool isCompleted;
  DateTime? time;

  TrackingStep(this.title, this.icon, this.isCompleted, this.time);
}
