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
  
  // Reassign order endpoint - orderId will be appended
  static String reassignOrder(String orderId) => "$baseUrl/api/Orders/$orderId/reassign";
  
  // Storage Keys
  static const String tokenKey = "auth_token";
}
