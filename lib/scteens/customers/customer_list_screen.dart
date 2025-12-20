import 'package:flutter/material.dart';
import 'customer_model.dart';

class CustomerListScreen extends StatelessWidget {
  final List<Customer> customers;
  final Function(Customer) onCustomerTap;

  CustomerListScreen({
    required this.customers,
    required this.onCustomerTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return _buildCustomerCard(customer, context);
      },
    );
  }

  Widget _buildCustomerCard(Customer customer, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(customer.status),
          child: Text(
            customer.name[0],
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          customer.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customer.phone),
            Row(
              children: [
                Icon(Icons.location_on, size: 12),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    customer.address,
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusChip(customer.status),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: () => onCustomerTap(customer),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;

    switch (status) {
      case 'نشط':
        chipColor = Colors.green;
        break;
      case 'غير نشط':
        chipColor = Colors.orange;
        break;
      case 'محظور':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'نشط':
        return Colors.green;
      case 'غير نشط':
        return Colors.orange;
      case 'محظور':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
