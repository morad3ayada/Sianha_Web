import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';
import 'status_codes.dart';

class ApiService {
  Future<Map<String, String>> _getHeaders({bool hasToken = true}) async {
    Map<String, String> headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
    };

    if (hasToken) {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(ApiConstants.tokenKey);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<http.Response> get(String url, {bool hasToken = true}) async {
    print("---------------- API GET REQUEST ----------------");
    print("URL: $url");
    
    final headers = await _getHeaders(hasToken: hasToken);
    print("Headers: $headers");

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      _logResponse(response);
      return response;
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<http.Response> post(String url, {Map<String, dynamic>? body, bool hasToken = true}) async {
    print("---------------- API POST REQUEST ----------------");
    print("URL: $url");
    print("Body: $body");

    final headers = await _getHeaders(hasToken: hasToken);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      _logResponse(response);
      return response;
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<http.Response> put(String url, Map<String, dynamic> body, {bool hasToken = true}) async {
    print("---------------- API PUT REQUEST ----------------");
    print("URL: $url");
    print("Body: $body");

    final headers = await _getHeaders(hasToken: hasToken);

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      _logResponse(response);
      return response;
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<http.Response> delete(String url, {bool hasToken = true}) async {
    print("---------------- API DELETE REQUEST ----------------");
    print("URL: $url");

    final headers = await _getHeaders(hasToken: hasToken);

    try {
      final response = await http.delete(Uri.parse(url), headers: headers);
      _logResponse(response);
      return response;
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  void _logResponse(http.Response response) {
    print("---------------- API RESPONSE ----------------");
    print("Status Code: ${response.statusCode}");
    print("Body: ${response.body}");
  }
}
