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
      // Use the specific authorization token
      const String authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NDE4ZmYyOS02OTcyLTQ0MTAtOTdkOC01MGU1MjU5YzRhMmUiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBZG1pbiIsImp0aSI6ImRhYjNjNmFkLTYyYzAtNDcxYi1iZWY4LTE0YTk3MjVjYzI5ZCIsImV4cCI6MTc5NzY4MjAwNiwiaXNzIjoiTWFpbnRlbmFuY2VBUEkiLCJhdWQiOiJNYWludGVuYW5jZUNsaWVudCJ9.oVJKnnsBnpFBdzXVoarVxWXqeqhj6bJhM9u8u4BqdYM';
      
      final Map<String, String> headers = {
        'accept': '*/*',
        'Authorization': 'Bearer $authToken',
      };

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
        final dynamic decodedData = json.decode(response.body);
        
        // Check if the response is a Map (object) or List (array)
        if (decodedData is List) {
          // Direct array response
          return decodedData.map((json) => OrderModel.fromJson(json)).toList();
        } else if (decodedData is Map<String, dynamic>) {
          // Object response - try to find the orders array
          // Common keys: 'data', 'orders', 'items', 'results'
          final List<dynamic>? ordersList = decodedData['data'] ?? 
                                            decodedData['orders'] ?? 
                                            decodedData['items'] ?? 
                                            decodedData['results'];
          
          if (ordersList != null) {
            return ordersList.map((json) => OrderModel.fromJson(json)).toList();
          } else {
            print('ERROR: Could not find orders array in response. Keys: ${decodedData.keys}');
            throw Exception('Invalid response format: orders array not found');
          }
        } else {
          throw Exception('Unexpected response type: ${decodedData.runtimeType}');
        }
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

      print('---------------- GET TECHNICIANS RESPONSE ----------------');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        
        // Check if the response is a Map (object) or List (array)
        if (decodedData is List) {
          // Direct array response
          return decodedData.map((json) => UserModel.fromJson(json)).toList();
        } else if (decodedData is Map<String, dynamic>) {
          // Object response - try to find the technicians array
          final List<dynamic>? techsList = decodedData['data'] ?? 
                                           decodedData['users'] ?? 
                                           decodedData['technicians'] ?? 
                                           decodedData['items'] ?? 
                                           decodedData['results'];
          
          if (techsList != null) {
            return techsList.map((json) => UserModel.fromJson(json)).toList();
          } else {
            print('ERROR: Could not find technicians array in response. Keys: ${decodedData.keys}');
            throw Exception('Invalid response format: technicians array not found');
          }
        } else {
          throw Exception('Unexpected response type: ${decodedData.runtimeType}');
        }
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

  Future<void> assignOrder(String orderId, String technicianId, {String? reason}) async {
    try {
      final String authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NDE4ZmYyOS02OTcyLTQ0MTAtOTdkOC01MGU1MjU5YzRhMmUiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBZG1pbiIsImp0aSI6ImRhYjNjNmFkLTYyYzAtNDcxYi1iZWY4LTE0YTk3MjVjYzI5ZCIsImV4cCI6MTc5NzY4MjAwNiwiaXNzIjoiTWFpbnRlbmFuY2VBUEkiLCJhdWQiOiJNYWludGVuYW5jZUNsaWVudCJ9.oVJKnnsBnpFBdzXVoarVxWXqeqhj6bJhM9u8u4BqdYM';
      
      final Map<String, String> headers = {
        'accept': '*/*',
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        "technicianId": technicianId,
        "reason": reason ?? "string"
      });

      print('---------------- ASSIGN ORDER REQUEST ----------------');
      print('URL: ${ApiConstants.assignOrder}');
      print('Body: $body');

      final response = await http.post(
        Uri.parse(ApiConstants.assignOrder),
        headers: headers,
        body: body,
      ).timeout(Duration(seconds: 10));

      print('---------------- ASSIGN ORDER RESPONSE ----------------');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to assign order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error assigning order: $e');
      rethrow;
    }
  }

  Future<void> reassignOrder(String orderId, String technicianId, {String? reason}) async {
    try {
      final String authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NDE4ZmYyOS02OTcyLTQ0MTAtOTdkOC01MGU1MjU5YzRhMmUiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBZG1pbiIsImp0aSI6ImRhYjNjNmFkLTYyYzAtNDcxYi1iZWY4LTE0YTk3MjVjYzI5ZCIsImV4cCI6MTc5NzY4MjAwNiwiaXNzIjoiTWFpbnRlbmFuY2VBUEkiLCJhdWQiOiJNYWludGVuYW5jZUNsaWVudCJ9.oVJKnnsBnpFBdzXVoarVxWXqeqhj6bJhM9u8u4BqdYM';
      
      final Map<String, String> headers = {
        'accept': '*/*',
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        "technicianId": technicianId,
        "reason": reason ?? "string"
      });

      final String url = ApiConstants.reassignOrder(orderId);

      print('---------------- REASSIGN ORDER REQUEST ----------------');
      print('URL: $url');
      print('Body: $body');

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      ).timeout(Duration(seconds: 10));

      print('---------------- REASSIGN ORDER RESPONSE ----------------');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to reassign order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error reassigning order: $e');
      rethrow;
    }
  }
}
