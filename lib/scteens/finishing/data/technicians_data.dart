import '../../models/technician_model.dart';

class TechniciansData {
  static List<Governorate> governorates = [
    Governorate(
      name: 'القاهرة',
      availableTechnicians: 45,
      busyTechnicians: 15,
      availableSpecialties: [
        'سباك',
        'كهرباء',
        'دهان',
        'نجار',
        'جبس',
        'سيراميك'
      ],
    ),
    Governorate(
      name: 'الجيزة',
      availableTechnicians: 32,
      busyTechnicians: 12,
      availableSpecialties: ['سباك', 'كهرباء', 'دهان', 'نجار', 'ألومنيوم'],
    ),
    Governorate(
      name: 'الإسكندرية',
      availableTechnicians: 28,
      busyTechnicians: 10,
      availableSpecialties: ['سباك', 'كهرباء', 'دهان', 'سيراميك'],
    ),
    Governorate(
      name: 'سوهاج',
      availableTechnicians: 25,
      busyTechnicians: 8,
      availableSpecialties: ['سباك', 'كهرباء', 'دهان', 'نجار'],
    ),
  ];

  static List<District> districts = [
    District(
        name: 'حي مصر الجديدة',
        governorate: 'القاهرة',
        technicianCount: 12,
        specialties: ['سباك', 'كهرباء', 'دهان']),
    District(
        name: 'حي المهندسين',
        governorate: 'القاهرة',
        technicianCount: 15,
        specialties: ['نجار', 'جبس', 'سيراميك']),
    District(
        name: 'حي الدقي',
        governorate: 'الجيزة',
        technicianCount: 8,
        specialties: ['سباك', 'كهرباء']),
    District(
        name: 'حي الهرم',
        governorate: 'الجيزة',
        technicianCount: 10,
        specialties: ['دهان', 'نجار']),
    District(
        name: 'مركز جرجا',
        governorate: 'سوهاج',
        technicianCount: 10,
        specialties: ['سباك', 'كهرباء']),
    District(
        name: 'مركز طهطا',
        governorate: 'سوهاج',
        technicianCount: 8,
        specialties: ['دهان', 'نجار']),
  ];

  // تأكد من أن technicians هو List<Technician>
  static List<Technician> technicians = [
    Technician(
      id: 'T001',
      name: 'محمد أحمد',
      specialty: 'سباك',
      governorate: 'القاهرة',
      district: 'حي مصر الجديدة',
      status: 'متاح',
      rating: 4.8,
      activeProjects: 2,
      phone: '+201000000001',
      skills: ['سباكة منزلية', 'تركيب حمامات', 'صيانة مواسير'],
      experience: 5,
    ),
    Technician(
      id: 'T002',
      name: 'أحمد محمود',
      specialty: 'كهرباء',
      governorate: 'القاهرة',
      district: 'حي المهندسين',
      status: 'متاح',
      rating: 4.6,
      activeProjects: 1,
      phone: '+201000000002',
      skills: ['تركيب كهرباء', 'صيانة لوحات', 'أنظمة إضاءة'],
      experience: 7,
    ),
    Technician(
      id: 'T003',
      name: 'خالد إبراهيم',
      specialty: 'دهان',
      governorate: 'الجيزة',
      district: 'حي الهرم',
      status: 'مشغول',
      rating: 4.9,
      activeProjects: 3,
      phone: '+201000000003',
      skills: ['دهان داخلي', 'دهان خارجي', 'ورق حائط'],
      experience: 8,
    ),
    Technician(
      id: 'T004',
      name: 'محمود سعيد',
      specialty: 'نجار',
      governorate: 'سوهاج',
      district: 'مركز جرجا',
      status: 'متاح',
      rating: 4.7,
      activeProjects: 1,
      phone: '+201000000004',
      skills: ['أثاث منزلي', 'أبواب وشبابيك', 'مطابخ'],
      experience: 6,
    ),
  ];
}
