import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api/api_constants.dart';

class UserService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ApiConstants.tokenKey);
    return {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse(ApiConstants.profile),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
        return decoded['data'];
      }
      return decoded;
    } else {
      throw Exception('Failed to load profile: ${response.statusCode}');
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    final response = await http.post(
      Uri.parse(ApiConstants.changePassword),
      headers: await _getHeaders(),
      body: json.encode({
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      }),
    );

    return response.statusCode == 200;
  }
}
