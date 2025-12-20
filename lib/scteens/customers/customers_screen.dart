import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/api/api_constants.dart';
import '../../core/api/api_service.dart';
import 'add_customer_screen.dart';
import 'customer_details_screen.dart';
import 'customer_model.dart';
// import 'customer_list_screen.dart'; 

class CustomersScreen extends StatefulWidget {
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<Customer> customers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService().get(
        '${ApiConstants.users}?Role=1',
        hasToken: true,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic> data = responseBody['items'] ?? [];
        
        setState(() {
          customers = data.map((json) => Customer.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "فشل تحميل البيانات: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "حدث خطأ: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة العملاء'),
        backgroundColor: Colors.yellow[700],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchCustomers,
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _searchCustomers,
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchCustomers,
                        child: Text("إعادة المحاولة"),
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    _buildStatsCards(),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'ابحث عن عميل بالاسم أو الهاتف...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) => _searchCustomer(value),
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: customers.isEmpty
                          ? Center(child: Text("لا يوجد عملاء"))
                          : ListView.builder(
                              itemCount: customers.length,
                              itemBuilder: (context, index) {
                                final customer = customers[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(customer.name.isNotEmpty ? customer.name[0] : "?"),
                                    backgroundColor: Colors.yellow[100],
                                  ),
                                  title: Text(customer.name),
                                  subtitle: Text(customer.phone),
                                  trailing: customer.status == 'نشط'
                                      ? Icon(Icons.check_circle, color: Colors.green)
                                      : Icon(Icons.cancel, color: Colors.grey),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CustomerDetailsScreen(
                                          customer: customer,
                                          onCustomerUpdated: (updatedCustomer) {
                                            _updateCustomer(updatedCustomer);
                                          },
                                          onCustomerDeleted: (customerId) {
                                            _deleteCustomer(customerId);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCustomerScreen(
                onCustomerAdded: (newCustomer) {
                  _addCustomer(newCustomer);
                },
              ),
            ),
          );
        },
        backgroundColor: Colors.yellow[800],
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard('إجمالي العملاء', '${customers.length}', Icons.people,
              Colors.yellow),
          _buildStatCard(
              'عملاء نشطين',
              '${customers.where((c) => c.status == 'نشط').length}',
              Icons.check_circle,
              Colors.green),
          _buildStatCard(
              'طلبات اليوم', '0', Icons.shopping_cart, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        SizedBox(height: 8),
        Text(value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(title, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  void _addCustomer(Customer customer) {
    setState(() {
      customers.add(customer);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إضافة العميل ${customer.name} بنجاح')),
    );
  }

  void _updateCustomer(Customer updatedCustomer) {
    setState(() {
      int index = customers.indexWhere((c) => c.id == updatedCustomer.id);
      if (index != -1) {
        customers[index] = updatedCustomer;
      }
    });
  }

  void _deleteCustomer(String customerId) {
    setState(() {
      customers.removeWhere((c) => c.id == customerId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم حذف العميل بنجاح')),
    );
  }

  void _searchCustomers() {
    showSearch(
      context: context,
      delegate: CustomerSearchDelegate(customers: customers),
    );
  }

  void _searchCustomer(String query) {
    // Implement local search logic if needed to update list view
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تصفية العملاء'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('جميع العملاء'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('العملاء النشطين'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('العملاء الجدد'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerSearchDelegate extends SearchDelegate {
  final List<Customer> customers;

  CustomerSearchDelegate({required this.customers});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = customers.where((customer) {
      return customer.name.toLowerCase().contains(query.toLowerCase()) ||
          customer.phone.contains(query);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final customer = results[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(customer.name.isNotEmpty ? customer.name[0] : "?"),
          ),
          title: Text(customer.name),
          subtitle: Text(customer.phone),
          onTap: () {
            close(context, customer);
          },
        );
      },
    );
  }
}
