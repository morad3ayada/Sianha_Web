import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api/api_constants.dart';
import '../models/report_model.dart';

class ReportsService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ApiConstants.tokenKey);
    return {
      'accept': 'text/plain',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<ReportModel>> getReports() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.reports),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);
        
        List<dynamic> data;
        if (decodedBody is List<dynamic>) {
          data = decodedBody;
        } else if (decodedBody is Map<String, dynamic>) {
          data = (decodedBody['data'] ?? 
                  decodedBody['items'] ?? 
                  decodedBody['results'] ?? 
                  decodedBody['reports'] ?? []) as List<dynamic>;
        } else {
          throw Exception('Unexpected response type: ${decodedBody.runtimeType}');
        }

        return data.map((json) => ReportModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reports: ${response.statusCode}');
      }
    } catch (e, stack) {
      print('Error fetching reports: $e');
      print(stack);
      rethrow;
    }
  }
}
