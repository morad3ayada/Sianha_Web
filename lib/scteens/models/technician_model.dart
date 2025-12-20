class Technician {
  final String id;
  final String name;
  final String specialty;
  final String governorate;
  final String district;
  final String status;
  final double rating;
  final int activeProjects;
  final String phone;
  final List<String> skills;
  final int experience;

  Technician({
    required this.id,
    required this.name,
    required this.specialty,
    required this.governorate,
    required this.district,
    required this.status,
    required this.rating,
    required this.activeProjects,
    required this.phone,
    required this.skills,
    required this.experience,
  });
}

class Governorate {
  final String name;
  final int availableTechnicians;
  final int busyTechnicians;
  final List<String> availableSpecialties;

  Governorate({
    required this.name,
    required this.availableTechnicians,
    required this.busyTechnicians,
    required this.availableSpecialties,
  });
}

class District {
  final String name;
  final String governorate;
  final int technicianCount;
  final List<String> specialties;

  District({
    required this.name,
    required this.governorate,
    required this.technicianCount,
    required this.specialties,
  });
}
