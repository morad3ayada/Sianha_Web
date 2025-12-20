class ServiceSubCategoryModel {
  final String? id;
  final String? name;
  final String? serviceCategoryId;
  final String? serviceCategoryName; // Optional, for display if available
  final double? price;
  final double? cost;
  final double? costRate;
  final String? imageUrl;

  ServiceSubCategoryModel({
    this.id,
    this.name,
    this.serviceCategoryId,
    this.serviceCategoryName,
    this.price,
    this.cost,
    this.costRate,
    this.imageUrl,
  });

  factory ServiceSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceSubCategoryModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      serviceCategoryId: json['serviceCategoryId']?.toString(),
      serviceCategoryName: json['serviceCategoryName']?.toString(),
      price: (json['price'] as num?)?.toDouble(),
      cost: (json['cost'] as num?)?.toDouble(),
      costRate: (json['costRate'] as num?)?.toDouble(),
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'serviceCategoryId': serviceCategoryId,
      'price': price,
      'cost': cost,
      'costRate': costRate,
      'imageUrl': imageUrl,
    };
  }
}
