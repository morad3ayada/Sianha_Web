class Employee {
  String id;
  String name;
  String phone;
  String email;
  String jobTitle;
  String department;
  double basicSalary;
  String workSchedule;
  String? imageUrl; // إضافة علامة استفهام للإشارة إلى أنها اختيارية
  String status;
  DateTime hireDate;
  String password;
  String role;

  Employee({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.jobTitle,
    required this.department,
    required this.basicSalary,
    required this.workSchedule,
    this.imageUrl, // جعلها اختيارية
    required this.status,
    required this.hireDate,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'jobTitle': jobTitle,
      'department': department,
      'basicSalary': basicSalary,
      'workSchedule': workSchedule,
      'imageUrl': imageUrl,
      'status': status,
      'hireDate': hireDate.toIso8601String(),
      'password': password,
      'role': role,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      jobTitle: map['jobTitle'],
      department: map['department'],
      basicSalary: map['basicSalary'],
      workSchedule: map['workSchedule'],
      imageUrl: map['imageUrl'],
      status: map['status'],
      hireDate: DateTime.parse(map['hireDate']),
      password: map['password'],
      role: map['role'],
    );
  }
}
