import 'package:flutter/material.dart';
import 'delegate_profile_screen.dart';
import 'car/tow_profile_screen.dart';

class AgentsMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('خريطة المواقع'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Stack(
        children: [
          // خريطة (نص بديل)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 100, color: Colors.grey[400]),
                Text('خريطة جوجل - عرض جميع المواقع'),
              ],
            ),
          ),

          // ماركرات ومعلومات
          _buildMarkers(),

          // فلوتنج أزرار
          _buildFloatingControls(context),
        ],
      ),
    );
  }

  Widget _buildMarkers() {
    return Positioned(
      top: 100,
      left: 50,
      child: Column(
        children: [
          _buildMarker('مندوب نشط', Colors.green, Icons.person),
          SizedBox(height: 20),
          _buildMarker('ونش متاح', Colors.orange, Icons.local_shipping),
        ],
      ),
    );
  }

  Widget _buildMarker(String label, Color color, IconData icon) {
    return GestureDetector(
      onTap: () {
        // عرض معلومات الموقع
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingControls(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        children: [
          FloatingActionButton.small(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DelegateProfileScreen()),
              );
            },
            backgroundColor: Colors.green,
            child: Icon(Icons.person),
          ),
          SizedBox(height: 10),
          FloatingActionButton.small(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TowProfileScreen()),
              );
            },
            backgroundColor: Colors.orange,
            child: Icon(Icons.local_shipping),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _showMapOptions,
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    // عرض فلاتر الخريطة
  }

  void _showMapOptions() {
    // خيارات الخريطة
  }
}
