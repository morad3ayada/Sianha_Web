import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api/api_constants.dart';
import '../models/admin_model.dart';

class AdminsService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ApiConstants.tokenKey);
    return {
      'Content-Type': 'application/json',
      'Accept': 'text/plain',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<AdminModel>> getAdmins() async {
    final response = await http.get(
      Uri.parse(ApiConstants.admins),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final dynamic decodedBody = json.decode(response.body);
      List<dynamic> data;
      if (decodedBody is List<dynamic>) {
        data = decodedBody;
      } else if (decodedBody is Map<String, dynamic>) {
        data = (decodedBody['data'] ?? decodedBody['items'] ?? decodedBody['results'] ?? []) as List<dynamic>;
      } else {
        throw Exception('Unexpected response type: ${decodedBody.runtimeType}');
      }
      return data.map((json) => AdminModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load admins: ${response.statusCode}');
    }
  }

  Future<void> createAdmin(Map<String, dynamic> adminData) async {
    final response = await http.post(
      Uri.parse(ApiConstants.admins),
      headers: await _getHeaders(),
      body: json.encode(adminData),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create admin: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> updateAdmin(String id, Map<String, dynamic> adminData) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.admins}/$id'),
      headers: await _getHeaders(),
      body: json.encode(adminData),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update admin: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> deleteAdmin(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.admins}/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete admin: ${response.statusCode}');
    }
  }
}
