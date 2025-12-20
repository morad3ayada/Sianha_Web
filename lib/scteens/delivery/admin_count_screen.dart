import 'package:flutter/material.dart';

class AdminCountScreen extends StatefulWidget {
  @override
  _AdminCountScreenState createState() => _AdminCountScreenState();
}

class _AdminCountScreenState extends State<AdminCountScreen> {
  List<Governorate> governorates = [];

  @override
  void initState() {
    super.initState();
    _loadGovernorates();
  }

  void _loadGovernorates() {
    // بيانات تجريبية
    governorates = [
      Governorate('القاهرة', 10, 5),
      Governorate('الجيزة', 8, 4),
      Governorate('الإسكندرية', 6, 3),
      Governorate('الدقهلية', 4, 2),
      // ... باقي المحافظات
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة العدد - 27 محافظة'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveData,
          ),
        ],
      ),
      body: Column(
        children: [
          // إحصائيات عامة
          _buildGeneralStats(),

          // قائمة المحافظات
          Expanded(
            child: ListView.builder(
              itemCount: governorates.length,
              itemBuilder: (context, index) {
                return _buildGovernorateCard(governorates[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralStats() {
    int totalDelegates =
        governorates.fold(0, (sum, gov) => sum + gov.delegates);
    int totalTows = governorates.fold(0, (sum, gov) => sum + gov.tows);

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatCircle('مندوبين', totalDelegates, Colors.green),
            _buildStatCircle('ونشات', totalTows, Colors.orange),
            _buildStatCircle('محافظات', governorates.length, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCircle(String label, int value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildGovernorateCard(Governorate gov) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gov.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildCounter('مندوبين', gov.delegates, (newValue) {
                    setState(() {
                      gov.delegates = newValue;
                    });
                  }),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: _buildCounter('ونشات', gov.tows, (newValue) {
                    setState(() {
                      gov.tows = newValue;
                    });
                  }),
                ),
              ],
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'المراكز/الأحياء',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounter(String label, int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        SizedBox(height: 4),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove, size: 20),
              onPressed: () {
                if (value > 0) onChanged(value - 1);
              },
            ),
            Container(
              width: 40,
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xfffb5151)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, size: 20),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }

  void _saveData() {
    // حفظ البيانات
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حفظ البيانات بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class Governorate {
  String name;
  int delegates;
  int tows;

  Governorate(this.name, this.delegates, this.tows);
}
