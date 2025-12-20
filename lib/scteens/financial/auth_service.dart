import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api/api_constants.dart';
import '../../core/api/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<bool> logout() async {
    try {
      final response = await _apiService.post(
        ApiConstants.logout,
        body: {}, // Empty body as per CURL
        hasToken: true,
      );

      // Even if the server call fails, we should clear local token
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(ApiConstants.tokenKey);
      
      return response.statusCode == 200;
    } catch (e) {
      print("Logout error: $e");
      // Still try to clear local token
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(ApiConstants.tokenKey);
      return false;
    }
  }
}
