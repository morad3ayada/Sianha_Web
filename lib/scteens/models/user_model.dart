class UserModel {
  final String? id;
  final String? fullName;
  final String? serviceCategoryId;
  final String? governorateId;
  final String? governorateName;
  final String? areaName;
  final List<String>? categories;
  final String? technicianId;

  UserModel({
    this.id,
    this.fullName,
    this.serviceCategoryId,
    this.governorateId,
    this.governorateName,
    this.areaName,
    this.categories,
    this.technicianId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      fullName: json['fullName']?.toString(),
      serviceCategoryId: json['serviceCategoryId']?.toString(),
      governorateId: json['governorateId']?.toString(),
      governorateName: json['governorateName']?.toString(),
      areaName: json['areaName']?.toString(),
      categories: json['categories'] != null 
          ? List<String>.from(json['categories'].map((x) => x.toString()))
          : null,
      technicianId: json['technicianId']?.toString(),
    );
  }
}
