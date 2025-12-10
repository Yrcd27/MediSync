import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;
  int? _currentUserId;

  // Getters
  String? get token => _token;
  int? get currentUserId => _currentUserId;

  // Load token from storage
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _currentUserId = prefs.getInt('user_id');
  }

  // Save token to storage
  Future<void> saveToken(String token, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    _token = token;
    _currentUserId = userId;
    await prefs.setString('auth_token', token);
    await prefs.setInt('user_id', userId);
  }

  // Clear token
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = null;
    _currentUserId = null;
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
  }

  // Get headers with auth token if available
  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Generic GET request
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    return await http.get(url, headers: _headers);
  }

  // Generic POST request
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    print('Making POST request to: $url');
    print('Request body: ${json.encode(body)}');
    print('Headers: $_headers');

    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(body),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print('Request failed with error: $e');
      rethrow;
    }
  }

  // Generic PUT request
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    print('Making PUT request to: $url');
    print('Request body: ${json.encode(body)}');
    print('Headers: $_headers');

    try {
      final response = await http.put(
        url,
        headers: _headers,
        body: json.encode(body),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print('PUT request failed with error: $e');
      rethrow;
    }
  }

  // Generic DELETE request
  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    return await http.delete(url, headers: _headers);
  }

  // Handle API response
  Map<String, dynamic> handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Handle API response for lists
  List<dynamic> handleListResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return [];
      }
      return json.decode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
