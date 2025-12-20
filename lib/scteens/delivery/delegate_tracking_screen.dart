import 'package:flutter/material.dart';

class DelegateTrackingScreen extends StatefulWidget {
  @override
  _DelegateTrackingScreenState createState() => _DelegateTrackingScreenState();
}

class _DelegateTrackingScreenState extends State<DelegateTrackingScreen> {
  int _currentStep = 0;
  List<TrackingStep> steps = [
    TrackingStep('تم استلام الطلب', Icons.check_circle, true),
    TrackingStep('تم التحرك', Icons.directions_run, false),
    TrackingStep('في الطريق', Icons.directions_walk, false),
    TrackingStep('تم الوصول', Icons.location_on, false),
    TrackingStep('تم التسليم', Icons.done_all, false),
    TrackingStep('استلام الدفع', Icons.payment, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تتبع المندوب'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshTracking,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // معلومات المندوب
            _buildDelegateInfo(),
            SizedBox(height: 20),

            // Stepper للتتبع
            Expanded(
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: _nextStep,
                onStepCancel: _previousStep,
                steps: steps.map((step) {
                  return Step(
                    title: Text(step.title),
                    content: Container(),
                    state: step.isCompleted
                        ? StepState.complete
                        : StepState.indexed,
                    isActive: steps.indexOf(step) == _currentStep,
                  );
                }).toList(),
              ),
            ),

            // معلومات إضافية
            _buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildDelegateInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, size: 30, color: Colors.blue),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أحمد محمد',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('القاهرة - المعادي'),
                  Text('رقم الهاتف: 01234567890'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('معلومات الطلب',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text('وقت الاستلام: 10:30 ص')),
                Expanded(child: Text('المدة المتوقعة: 45 دقيقة')),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text('المسافة: 5 كم')),
                Expanded(child: Text('الحالة: قيد التنفيذ')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < steps.length - 1) {
      setState(() {
        _currentStep++;
        steps[_currentStep].isCompleted = true;
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
    });
  }
}

class TrackingStep {
  String title;
  IconData icon;
  bool isCompleted;

  TrackingStep(this.title, this.icon, this.isCompleted);
}
