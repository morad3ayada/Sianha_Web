class ReportModel {
  final String? id;
  final String? orderId;
  final String? customerName;
  final String? technicianName;
  final double? rate;
  final String? comment;
  final String? createdAt;
  final String? title;

  ReportModel({
    this.id,
    this.orderId,
    this.title,
    this.customerName,
    this.technicianName,
    this.rate,
    this.comment,
    this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id']?.toString(),
      orderId: json['orderId']?.toString(),
      title: json['title']?.toString(),
      customerName: (json['userName'] ?? json['customerName'])?.toString(),
      technicianName: json['technicianName']?.toString(),
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      comment: (json['description'] ?? json['comment'])?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }
}
