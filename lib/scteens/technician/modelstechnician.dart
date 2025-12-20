class Technician {
  final String id;
  final String name;
  final String phone;
  final String governorate;
  final String center;
  final String address;
  final String specialty;
  final String workSchedule;
  final String status;
  final String? rejectionReason;
  final bool isCraneOperator;
  final String? licensePlate;
  final String? driverLicense;
  final String? craneLicense;
  final String? frontIdImage;
  final String? backIdImage;
  final String? missingData;
  final String? workHours;
  final String? experience;
  final String? transportation;
  final String? vehicleLicense; // رخصة السيارة

  Technician({
    this.id = '',
    required this.name,
    required this.phone,
    this.governorate = '',
    this.center = '',
    this.address = '',
    required this.specialty,
    this.workSchedule = '',
    required this.status,
    this.rejectionReason,
    this.isCraneOperator = false,
    this.licensePlate,
    this.driverLicense,
    this.craneLicense,
    this.frontIdImage,
    this.backIdImage,
    this.missingData,
    this.workHours = '',
    this.experience = '',
    this.transportation = '',
    this.vehicleLicense,
  });

  // Copy with method for editing
  Technician copyWith({
    String? name,
    String? phone,
    String? governorate,
    String? center,
    String? address,
    String? specialty,
    String? workSchedule,
    String? workHours,
    String? experience,
    String? transportation,
    String? frontIdImage,
    String? backIdImage,
    String? licensePlate,
    String? driverLicense,
    String? craneLicense,
    String? vehicleLicense,
  }) {
    return Technician(
      id: this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      governorate: governorate ?? this.governorate,
      center: center ?? this.center,
      address: address ?? this.address,
      specialty: specialty ?? this.specialty,
      workSchedule: workSchedule ?? this.workSchedule,
      status: this.status,
      rejectionReason: this.rejectionReason,
      isCraneOperator: this.isCraneOperator,
      licensePlate: licensePlate ?? this.licensePlate,
      driverLicense: driverLicense ?? this.driverLicense,
      craneLicense: craneLicense ?? this.craneLicense,
      frontIdImage: frontIdImage ?? this.frontIdImage,
      backIdImage: backIdImage ?? this.backIdImage,
      missingData: this.missingData,
      workHours: workHours ?? this.workHours,
      experience: experience ?? this.experience,
      transportation: transportation ?? this.transportation,
      vehicleLicense: vehicleLicense ?? this.vehicleLicense,
    );
  }
}