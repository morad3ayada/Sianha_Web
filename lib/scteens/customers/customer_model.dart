
class Customer {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final DateTime registrationDate;
  final List<String> orders;
  final String status;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.registrationDate,
    required this.orders,
    required this.status,
  });

  // دوال التحويل من/إلى JSON
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      name: json['fullName'] ?? 'Unknown',
      phone: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      address: '${json['governorateName'] ?? ''} - ${json['areaName'] ?? ''}',
      registrationDate: DateTime.now(), // Not in API response snippet
      orders: [], // Not in API response snippet
      status: json['isBlocked'] == true ? 'محظور' : 'نشط',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'registrationDate': registrationDate.toIso8601String(),
      'orders': orders,
      'status': status,
    };
  }
}