class ApiConstants {
  static const String baseUrl = "https://anamelorg.runasp.net";
  
  // Auth Endpoints
  static const String login = "$baseUrl/api/Auth/login";
  
  // Dashboard Endpoints
  // Dashboard Endpoints
  static const String users = "$baseUrl/api/Dashboard/users";
  static const String governorates = "$baseUrl/api/Governorates";
  static const String areas = "$baseUrl/api/Areas";
  
  static const String technicians = "$baseUrl/api/Dashboard/technicians";
  static const String merchants = "$baseUrl/api/Dashboard/merchants";
  static const String getAllOrders = "$baseUrl/api/Orders/GetAllOrders";
  static const String assignOrder = "$baseUrl/api/Orders/AssignOrder";
  static const String serviceCategories = "$baseUrl/api/ServiceCategories";
  static const String serviceSubCategories = "$baseUrl/api/ServiceSubCategories";
  static const String reports = "$baseUrl/api/Reports";
  
  // Reassign order endpoint - orderId will be appended
  static String reassignOrder(String orderId) => "$baseUrl/api/Orders/$orderId/reassign";
  
  // Update Order Status endpoint
  static String updateOrderStatus(String orderId) => "$baseUrl/api/Orders/UpdateStatus/$orderId";
  
  // Storage Keys
  static const String tokenKey = "auth_token";
  // SubCategories Feedbacks
  static String subCategoryFeedbacks(String subCategoryId) => "$baseUrl/api/ServiceSubCategories/$subCategoryId/feedbacks";
  static String subCategoryFeedbackAvg(String subCategoryId) => "$baseUrl/api/ServiceSubCategories/$subCategoryId/feedback-avg";
  
  // Main Categories Feedbacks
  static String categoryFeedbacks(String categoryId) => "$baseUrl/api/ServiceCategories/$categoryId/feedbacks";
  static String categoryFeedbackAvg(String categoryId) => "$baseUrl/api/ServiceCategories/$categoryId/feedback-avg";
  // Users
  static const String profile = "$baseUrl/api/Users/profile";
  static const String changePassword = "$baseUrl/api/Users/change-password";
  // Auth
  static const String logout = "$baseUrl/api/Auth/logout";
  
  // Admins
  static const String admins = "$baseUrl/api/Admins";
}
