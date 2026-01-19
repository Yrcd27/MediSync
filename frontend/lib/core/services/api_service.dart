import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

/// API Service for handling all HTTP requests to the backend
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  int? _currentUserId;

  // Getters
  int? get currentUserId => _currentUserId;

  // Load user ID from storage
  Future<void> loadUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getInt('user_id');
  }

  // Save user session to storage
  Future<void> saveUserSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = userId;
    await prefs.setInt('user_id', userId);
  }

  // Clear session
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = null;
    await prefs.remove('user_id');
  }

  // Get headers
  Map<String, String> get _headers {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  // Build full URL
  String _buildUrl(String endpoint) {
    // Use baseUrl directly - backend doesn't use /api/v1 prefix
    return '${AppConfig.baseUrl}$endpoint';
  }

  // Generic GET request
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse(_buildUrl(endpoint));
    try {
      final response = await http
          .get(url, headers: _headers)
          .timeout(const Duration(seconds: 30));
      return response;
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Could not connect to server.');
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  // Generic POST request
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(_buildUrl(endpoint));
    try {
      final response = await http
          .post(url, headers: _headers, body: json.encode(body))
          .timeout(const Duration(seconds: 30));
      return response;
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Could not connect to server.');
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  // Generic PUT request
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(_buildUrl(endpoint));
    try {
      final response = await http
          .put(url, headers: _headers, body: json.encode(body))
          .timeout(const Duration(seconds: 30));
      return response;
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Could not connect to server.');
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  // Generic DELETE request
  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse(_buildUrl(endpoint));
    try {
      final response = await http
          .delete(url, headers: _headers)
          .timeout(const Duration(seconds: 30));
      return response;
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on HttpException {
      throw Exception('Could not connect to server.');
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  // Handle API response for single object
  Map<String, dynamic> handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      throw Exception('Invalid email or password');
    } else if (response.statusCode == 404) {
      throw Exception('Resource not found');
    } else if (response.statusCode >= 500) {
      throw Exception('Server error. Please try again later.');
    } else {
      // Try to parse error message from backend
      try {
        final body = response.body;
        if (body.isNotEmpty) {
          throw Exception(body);
        }
      } catch (_) {}
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  // Handle API response for lists
  List<dynamic> handleListResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return [];
      }
      return json.decode(response.body) as List<dynamic>;
    } else if (response.statusCode == 404) {
      // Return empty list if not found (common for first-time users)
      return [];
    } else if (response.statusCode >= 500) {
      throw Exception('Server error. Please try again later.');
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  // Check if response is successful
  bool isSuccessful(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
