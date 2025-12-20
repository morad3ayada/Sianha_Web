class Area {
  final String id;
  final String name;
  final String governorateId;

  Area({
    required this.id,
    required this.name,
    required this.governorateId,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      governorateId: json['governorateId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'governorateId': governorateId,
    };
  }
}
