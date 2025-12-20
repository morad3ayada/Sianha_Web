class Attendance {
  String id;
  String employeeId;
  DateTime date;
  DateTime? checkIn;
  DateTime? checkOut;
  bool isPresent;
  bool isLate;
  String? notes;

  Attendance({
    required this.id,
    required this.employeeId,
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.isPresent,
    required this.isLate,
    this.notes,
  });

  double get workingHours {
    if (checkIn == null || checkOut == null) return 0;
    return checkOut!.difference(checkIn!).inHours.toDouble();
  }
}
