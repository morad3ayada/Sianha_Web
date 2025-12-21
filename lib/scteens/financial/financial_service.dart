import 'dart:async'; // Connect Timeout
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api/api_constants.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

class FinancialService {
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(ApiConstants.tokenKey);
      
      final Map<String, String> headers = {
        'accept': 'text/plain',
      };
      
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      print('---------------- API REQUEST ----------------');
      print('URL: ${ApiConstants.getAllOrders}');
      print('Headers: $headers');

      final response = await http.get(
        Uri.parse(ApiConstants.getAllOrders),
        headers: headers,
      ).timeout(Duration(seconds: 10)); // Add 10s timeout

      print('---------------- API RESPONSE ----------------');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
        throw Exception('Connection timed out. Please check your internet connection.');
    } catch (e) {
      print('Error fetching orders: $e');
      rethrow;
    }
  }

  Future<List<UserModel>> getTechnicians() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/Dashboard/users?Role=2'),
        headers: headers,
      );

       ('GET Technicians', response);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load technicians: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching technicians: $e');
      throw Exception('Failed to load technicians: $e');
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ApiConstants.tokenKey);

    final Map<String, String> headers = {
      'accept': 'text/plain',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<void> assignOrder(String s, String t, {String? reason}) async {}

  Future<void> reassignOrder(String s, String t, {String? reason}) async {}
}
