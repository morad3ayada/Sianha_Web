import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api/api_constants.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

// Financial service for orders and technicians management
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
      ).timeout(Duration(seconds: 10));

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

      _logResponse('GET Technicians', response);

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);
        
        // Check if response is a Map (wrapped) or List (direct)
        List<dynamic> data;
        if (decodedBody is Map<String, dynamic>) {
          // Response is wrapped, try common wrapper keys
          print('Response is a Map, keys: ${decodedBody.keys}');
          if (decodedBody.containsKey('items')) {
            data = decodedBody['items'] as List<dynamic>;
          } else if (decodedBody.containsKey('data')) {
            data = decodedBody['data'] as List<dynamic>;
          } else if (decodedBody.containsKey('users')) {
            data = decodedBody['users'] as List<dynamic>;
          } else if (decodedBody.containsKey('result')) {
            data = decodedBody['result'] as List<dynamic>;
          } else {
            // If no known wrapper key, throw with available keys
            throw Exception('Unknown response structure. Available keys: ${decodedBody.keys}');
          }
        } else if (decodedBody is List<dynamic>) {
          // Response is a direct list
          data = decodedBody;
        } else {
          throw Exception('Unexpected response type: ${decodedBody.runtimeType}');
        }
        
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load technicians: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching technicians: $e');
      throw Exception('Failed to load technicians: $e');
    }
  }

  Future<bool> assignOrder(String orderId, String technicianId) async {
    try {
      final headers = await _getHeaders();
      headers['Content-Type'] = 'application/json';

      final body = json.encode({
        'orderId': orderId,
        'technicianId': technicianId,
      });

      print('---------------- ASSIGN ORDER REQUEST ----------------');
      print('URL: ${ApiConstants.assignOrder}');
      print('Body: $body');

      final response = await http.post(
        Uri.parse(ApiConstants.assignOrder),
        headers: headers,
        body: body,
      );

      _logResponse('ASSIGN ORDER', response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to assign order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error assigning order: $e');
      throw Exception('Failed to assign order: $e');
    }
  }

  // Reassign order to a technician with optional reason
  Future<bool> reassignOrder(
    String orderId, 
    String technicianId, 
    {String? reason}
  ) async {
    try {
      final headers = await _getHeaders();
      headers['Content-Type'] = 'application/json';

      final body = json.encode({
        'technicianId': technicianId,
        if (reason != null && reason.isNotEmpty) 'reason': reason,
      });

      print('---------------- REASSIGN ORDER REQUEST ----------------');
      print('URL: ${ApiConstants.reassignOrder(orderId)}');
      print('Body: $body');

      final response = await http.put(
        Uri.parse(ApiConstants.reassignOrder(orderId)),
        headers: headers,
        body: body,
      );

      _logResponse('REASSIGN ORDER', response);

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to reassign order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error reassigning order: $e');
      throw Exception('Failed to reassign order: $e');
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

  void _logResponse(String title, http.Response response) {
    print('---------------- $title ----------------');
    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');
  }
}
