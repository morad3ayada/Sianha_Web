class AdminModel {
  final String? id;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? governorateId;
  final String? areaId;
  final String? governorateName;
  final String? areaName;
  final bool isActive;
  final bool isBlocked;

  AdminModel({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.address,
    this.governorateId,
    this.areaId,
    this.governorateName,
    this.areaName,
    this.isActive = true,
    this.isBlocked = false,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id']?.toString(),
      fullName: json['fullName']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      email: json['email']?.toString(),
      address: json['address']?.toString(),
      governorateId: json['governorateId']?.toString(),
      areaId: json['areaId']?.toString(),
      governorateName: json['governorateName']?.toString(),
      areaName: json['areaName']?.toString(),
      isActive: json['isActive'] ?? true,
      isBlocked: json['isBlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    return {
      if (includeId) 'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'governorateId': governorateId,
      'areaId': areaId,
      'isActive': isActive,
      'isBlocked': isBlocked,
    };
  }
}
