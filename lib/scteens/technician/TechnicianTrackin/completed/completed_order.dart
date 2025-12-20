class CompletedOrder {
  final String id;
  final String serviceType;
  final String customerName;
  final String customerPhone;
  final String address;
  final String governorate;
  final String center;
  final double price;
  final double rating;
  final DateTime completionDate;
  final String technicianId;
  final String technicianName;
  final String? notes;

  CompletedOrder({
    required this.id,
    required this.serviceType,
    required this.customerName,
    required this.customerPhone,
    required this.address,
    required this.governorate,
    required this.center,
    required this.price,
    required this.rating,
    required this.completionDate,
    required this.technicianId,
    required this.technicianName,
    this.notes,
  });
}

// نموذج للإحصائيات
class GovernorateStats {
  final String governorate;
  final int totalOrders;
  final double totalRevenue;
  final double averageRating;
  final Map<String, int> serviceTypeDistribution;

  GovernorateStats({
    required this.governorate,
    required this.totalOrders,
    required this.totalRevenue,
    required this.averageRating,
    required this.serviceTypeDistribution,
  });
}

class CenterStats {
  final String center;
  final int totalOrders;
  final double totalRevenue;
  final double averageRating;

  CenterStats({
    required this.center,
    required this.totalOrders,
    required this.totalRevenue,
    required this.averageRating,
  });
}
