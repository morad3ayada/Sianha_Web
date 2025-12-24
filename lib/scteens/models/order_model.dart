class OrderModel {
  final String? id;
  final double? price;
  final String? governorateName;
  final int? payWay;
  final int? orderStatus;
  final String? date;
  final String? serviceCategoryId;
  final String? governorateId;
  final String? areaName;
  final String? serviceCategoryName;
  final String? title;
  final String? createdAt;
  final String? customerName;
  final String? address;
  final String? problemDescription;
  final String? problemImageUrl;
  final String? customerPhoneNumber;
  final String? technicianName;
  final String? technicianPhoneNumber;
  final String? merchantName;
  final String? merchantPhoneNumber;
  
  // Fields from Reports API
  final String? userName;
  final String? description;
  final String? userId;
  
  OrderModel({
    this.id,
    this.price,
    this.governorateName,
    this.payWay,
    this.orderStatus,
    this.date,
    this.serviceCategoryId,
    this.governorateId,
    this.areaName,
    this.serviceCategoryName,
    this.title,
    this.createdAt,
    this.customerName,
    this.address,
    this.problemDescription,
    this.problemImageUrl,
    this.customerPhoneNumber,
    this.technicianName,
    this.technicianPhoneNumber,
    this.merchantName,
    this.merchantPhoneNumber,
    this.userName,
    this.description,
    this.userId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Debug log to check what we are actually receiving for each order
    if (json['customerPhoneNumber'] == null) {
      print("DEBUG: Order ${json['id']} - customerPhoneNumber is NULL. Available keys: ${json.keys.toList()}");
    } else {
      print("DEBUG: Order ${json['id']} - Customer Phone: ${json['customerPhoneNumber']}");
    }

    return OrderModel(
      id: json['id']?.toString(),
      price: (json['price'] as num?)?.toDouble(),
      governorateName: json['governorateName']?.toString(),
      payWay: json['payWay'] is num ? (json['payWay'] as num).toInt() : null,
      orderStatus: json['orderStatus'] is num 
          ? (json['orderStatus'] as num).toInt() 
          : int.tryParse(json['orderStatus']?.toString() ?? ''),
      date: json['date'],
      serviceCategoryId: json['serviceCategoryId'],
      governorateId: json['governorateId'],
      areaName: json['areaName'],
      serviceCategoryName: json['serviceCategoryName'],
      title: json['title'],
      createdAt: json['createdAt'],
      customerName: json['customerName'],
      address: json['address'],
      problemDescription: json['problemDescription'],
      problemImageUrl: json['problemImageUrl'],
      customerPhoneNumber: json['customerPhoneNumber']?.toString(),
      // Handle the 'technicia' spelling from Swagger if it's there
      technicianName: (json['technicianName'] ?? json['techniciaName'])?.toString(),
      technicianPhoneNumber: (json['technicianPhoneNumber'] ?? json['techniciaPhoneNumber'])?.toString(),
      merchantName: json['merchantName']?.toString(),
      merchantPhoneNumber: json['merchantPhoneNumber']?.toString(),
      // Reports API fields
      userName: json['userName']?.toString(),
      description: json['description']?.toString(),
      userId: json['userId']?.toString(),
    );
  }
}
