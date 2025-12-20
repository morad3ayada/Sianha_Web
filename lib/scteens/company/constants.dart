
class AppConstants {
  static const String appName = 'نظام إدارة الموظفين';
  static const String companyName = 'شركتك';
  
  // أدوار المستخدمين
  static const String roleAdmin = 'مدير';
  static const String roleAccountant = 'محاسب';
  static const String roleEmployee = 'موظف';
  static const String roleTechnician = 'فني';
  static const String roleSales = 'مندوب';
  static const String roleCustomerService = 'خدمة عملاء';
  
  // حالات الموظف
  static const String statusWorking = 'شغال';
  static const String statusVacation = 'أجازة';
  static const String statusSuspended = 'موقوف';
  
  // أقسام الشركة
  static const List<String> departments = [
    'موارد بشرية',
    'خدمة عملاء',
    'صيانة',
    'تسويق',
    'محاسبة',
    'تكنولوجيا المعلومات',
    'إدارة',
  ];
  
  // مواعيد العمل
  static const List<String> workSchedules = [
    '9-5',
    'نوبات',
    'ساعات مرنة',
  ];
}