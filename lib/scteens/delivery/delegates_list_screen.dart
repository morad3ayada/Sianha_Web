import 'package:flutter/material.dart';
import 'delegate_profile_screen.dart';
import 'delegate_tracking_screen.dart';

class DelegatesListScreen extends StatefulWidget {
  @override
  _DelegatesListScreenState createState() => _DelegatesListScreenState();
}

class _DelegatesListScreenState extends State<DelegatesListScreen> {
  List<Delegate> delegates = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadDelegates();
  }

  void _loadDelegates() {
    delegates = [
      Delegate('أحمد محمد', 'القاهرة', 'المعادي', 'نشط', 4.5),
      Delegate('محمد علي', 'الجيزة', 'الدقي', 'نشط', 4.2),
      Delegate('خالد أحمد', 'الإسكندرية', 'سموحة', 'غير نشط', 3.8),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('قائمة المندوبين'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNewDelegate,
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          _buildSearchBar(),

          // قائمة المندوبين
          Expanded(
            child: ListView.builder(
              itemCount: delegates.length,
              itemBuilder: (context, index) {
                return _buildDelegateCard(delegates[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'ابحث عن مندوب...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildDelegateCard(Delegate delegate) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(
          delegate.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${delegate.governorate} - ${delegate.area}'),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                Text(' ${delegate.rating}'),
                SizedBox(width: 10),
                _buildStatusChip(delegate.status),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DelegateProfileScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = status == 'نشط' ? Colors.green : Colors.red;
    return Chip(
      label: Text(
        status,
        style: TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: color,
      padding: EdgeInsets.symmetric(horizontal: 4),
      labelPadding: EdgeInsets.symmetric(horizontal: 4),
    );
  }

  void _addNewDelegate() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إضافة مندوب جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'الاسم')),
              TextField(decoration: InputDecoration(labelText: 'المحافظة')),
              TextField(decoration: InputDecoration(labelText: 'المنطقة')),
              TextField(decoration: InputDecoration(labelText: 'الهاتف')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              // إضافة المندوب
              Navigator.pop(context);
            },
            child: Text('إضافة'),
          ),
        ],
      ),
    );
  }
}

class Delegate {
  final String name;
  final String governorate;
  final String area;
  final String status;
  final double rating;

  Delegate(this.name, this.governorate, this.area, this.status, this.rating);
}
