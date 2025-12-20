class RejectedOrder {
  final String id;
  final String serviceType;
  final String customerName;
  final String customerPhone;
  final String address;
  final String governorate;
  final String center;
  final String rejectionReason;
  final DateTime rejectionDate;
  final DateTime requestDate;
  final String technicianId;
  final String technicianName;

  RejectedOrder({
    required this.id,
    required this.serviceType,
    required this.customerName,
    required this.customerPhone,
    required this.address,
    required this.governorate,
    required this.center,
    required this.rejectionReason,
    required this.rejectionDate,
    required this.requestDate,
    required this.technicianId,
    required this.technicianName,
  });
}
