class ServiceCategoryModel {
  final String? id;
  final String? name;
  final String? description;
  final String? imageUrl;

  ServiceCategoryModel({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
