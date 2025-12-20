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
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      price: (json['price'] as num?)?.toDouble(),
      governorateName: json['governorateName'],
      payWay: json['payWay'],
      orderStatus: json['orderStatus'] is int ? json['orderStatus'] : int.tryParse(json['orderStatus']?.toString() ?? ''),
      date: json['date'],
      serviceCategoryId: json['serviceCategoryId'],
      governorateId: json['governorateId'],
      areaName: json['areaName'],
      serviceCategoryName: json['serviceCategoryName'],
    );
  }
}
