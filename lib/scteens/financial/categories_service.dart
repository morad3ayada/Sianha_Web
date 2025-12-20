import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api/api_constants.dart';
import '../models/service_category_model.dart';
import '../models/service_sub_category_model.dart';
import '../models/report_model.dart';
import 'package:http_parser/http_parser.dart';

class CategoriesService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ApiConstants.tokenKey);
    return {
      'accept': 'text/plain',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // --- Main Categories ---
  Future<List<ServiceCategoryModel>> getCategories() async {
    final response = await http.get(
      Uri.parse(ApiConstants.serviceCategories),
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
      return data.map((json) => ServiceCategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

  Future<void> createCategory({
    required String name,
    required String description,
    dynamic imageFile,
  }) async {
    final uri = Uri.parse(ApiConstants.serviceCategories);
    final request = http.MultipartRequest('POST', uri);
    
    final headers = await _getHeaders();
    request.headers.addAll(headers);
    
    request.fields['Name'] = name;
    request.fields['Description'] = description;
    request.fields['ImageUrl'] = '';

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'Image',
        imageFile.path,
        contentType: MediaType('image', 'png'),
      ));
    }

    final response = await request.send();
    if (response.statusCode != 200 && response.statusCode != 201) {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Failed to create category: $responseBody');
    }
  }

  Future<void> updateCategory({
    required String id,
    required String name,
    required String description,
    String? imageUrl,
    dynamic imageFile,
  }) async {
    final uri = Uri.parse('${ApiConstants.serviceCategories}/$id');
    final request = http.MultipartRequest('PUT', uri);
    
    final headers = await _getHeaders();
    request.headers.addAll(headers);
    
    request.fields['Id'] = id;
    request.fields['Name'] = name;
    request.fields['Description'] = description;
    request.fields['ImageUrl'] = imageUrl ?? '';

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'Image',
        imageFile.path,
        contentType: MediaType('image', 'png'),
      ));
    }

    final response = await request.send();
    if (response.statusCode != 200 && response.statusCode != 204) {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Failed to update category: $responseBody');
    }
  }

  Future<void> deleteCategory(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.serviceCategories}/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete category: ${response.statusCode}');
    }
  }

  // --- Sub Categories ---
  Future<List<ServiceSubCategoryModel>> getSubCategories() async {
    final response = await http.get(
      Uri.parse(ApiConstants.serviceSubCategories),
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
      return data.map((json) => ServiceSubCategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subcategories: ${response.statusCode}');
    }
  }

  Future<void> createSubCategory({
    required String name,
    required String serviceCategoryId,
    required double price,
    required double cost,
    required double costRate,
    dynamic imageFile,
  }) async {
    final uri = Uri.parse(ApiConstants.serviceSubCategories);
    final request = http.MultipartRequest('POST', uri);
    
    final headers = await _getHeaders();
    request.headers.addAll(headers);
    
    request.fields['Name'] = name;
    request.fields['ServiceCategoryId'] = serviceCategoryId;
    request.fields['Price'] = price.toString();
    request.fields['Cost'] = cost.toString();
    request.fields['CostRate'] = costRate.toString();
    request.fields['ImageUrl'] = '';

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'Image',
        imageFile.path,
        contentType: MediaType('image', 'png'),
      ));
    }

    final response = await request.send();
    if (response.statusCode != 200 && response.statusCode != 201) {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Failed to create subcategory: $responseBody');
    }
  }

  Future<void> updateSubCategory({
    required String id,
    required String name,
    required String serviceCategoryId,
    required double price,
    required double cost,
    required double costRate,
    String? imageUrl,
    dynamic imageFile,
  }) async {
    // User curl used POST for edit, but specified PUT is usually better. 
    // However, I will use POST as provided in the user's specific edit curl for subcategories if it includes the ID in the body/fields.
    // Wait, let's look at the user's edit curl again:
    // curl -X 'POST' '.../api/ServiceSubCategories' ... -F 'Name=...'
    // It doesn't even have an ID field in the curl provided for subcategories edit? 
    // Actually, usually edit is PUT /api/ServiceSubCategories/{id}. 
    // I'll check if there's an ID field in the POST fields for edit.
    // The user's provided edit curl for CATEGORIES used PUT. 
    // The user's provided edit curl for SUBCATEGORIES used POST and no ID?
    // Let me re-read: "+زرار تعديل برضوا وتسمع في السيرفر عن طريق curl -X 'POST' '.../api/ServiceSubCategories' ... -F 'Name=string2' -F 'ServiceCategoryId=...' -F 'Price=200' -F 'Cost=150' -F 'CostRate=2000' -F 'ImageUrl=' -F 'Image=@151.png;type=image/png'"
    // This looks like a duplicate of the create curl. Maybe they use PUT for edit as well.
    // I'll assume PUT /{id} like the main categories unless it fails. 
    // Actually, I'll use PUT /api/ServiceSubCategories/{id} and Include Id in fields.
    
    final uri = Uri.parse('${ApiConstants.serviceSubCategories}/$id');
    final request = http.MultipartRequest('PUT', uri);
    
    final headers = await _getHeaders();
    request.headers.addAll(headers);
    
    request.fields['Id'] = id;
    request.fields['Name'] = name;
    request.fields['ServiceCategoryId'] = serviceCategoryId;
    request.fields['Price'] = price.toString();
    request.fields['Cost'] = cost.toString();
    request.fields['CostRate'] = costRate.toString();
    request.fields['ImageUrl'] = imageUrl ?? '';

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'Image',
        imageFile.path,
        contentType: MediaType('image', 'png'),
      ));
    }

    final response = await request.send();
    if (response.statusCode != 200 && response.statusCode != 204) {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Failed to update subcategory: $responseBody');
    }
  }

  Future<void> deleteSubCategory(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.serviceSubCategories}/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete subcategory: ${response.statusCode}');
    }
  }

  // --- Feedback ---
  Future<List<ReportModel>> getSubCategoryFeedbacks(String subCategoryId) async {
    final response = await http.get(
      Uri.parse(ApiConstants.subCategoryFeedbacks(subCategoryId)),
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
      return data.map((json) => ReportModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load feedbacks: ${response.statusCode}');
    }
  }

  Future<double> getSubCategoryFeedbackAvg(String subCategoryId) async {
    final response = await http.get(
      Uri.parse(ApiConstants.subCategoryFeedbackAvg(subCategoryId)),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final dynamic decodedBody = json.decode(response.body);
      if (decodedBody is Map<String, dynamic> && decodedBody.containsKey('data')) {
        return (decodedBody['data'] as num?)?.toDouble() ?? 0.0;
      }
      return (decodedBody as num?)?.toDouble() ?? 0.0;
    }
    return 0.0;
  }

  // --- Main Categories Feedbacks ---
  Future<List<ReportModel>> getCategoryFeedbacks(String categoryId) async {
    final response = await http.get(
      Uri.parse(ApiConstants.categoryFeedbacks(categoryId)),
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
      return data.map((json) => ReportModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load category feedbacks: ${response.statusCode}');
    }
  }

  Future<double> getCategoryFeedbackAvg(String categoryId) async {
    final response = await http.get(
      Uri.parse(ApiConstants.categoryFeedbackAvg(categoryId)),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final dynamic decodedBody = json.decode(response.body);
      if (decodedBody is Map<String, dynamic> && decodedBody.containsKey('data')) {
        return (decodedBody['data'] as num?)?.toDouble() ?? 0.0;
      }
      return (decodedBody as num?)?.toDouble() ?? 0.0;
    }
    return 0.0;
  }
}
