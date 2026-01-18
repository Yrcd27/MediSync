import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../core/services/api_service.dart';
import '../core/config/app_config.dart';
import '../core/utils/app_logger.dart';
import '../core/utils/exception_handler.dart';

/// Authentication service for login, registration, and user management
class AuthService {
  final ApiService _apiService = ApiService();

  /// Login with email and password
  Future<User> login(String email, String password) async {
    try {
      AppLogger.info('Attempting login for: $email', 'AuthService');
      AppLogger.debug('Login endpoint: ${AppConfig.login}', 'AuthService');

      final response = await _apiService.post(AppConfig.login, {
        'email': email,
        'password': password,
      });

      AppLogger.debug('Response status: ${response.statusCode}', 'AuthService');

      final userData = _apiService.handleResponse(response);
      final user = User.fromJson(userData);

      AppLogger.success('User logged in: ${user.name}', 'AuthService');

      // Store user session
      await _apiService.saveUserSession(user.id);
      await _saveUserData(user);

      return user;
    } catch (e, stackTrace) {
      ExceptionHandler.log('login', e, stackTrace);
      throw Exception(ExceptionHandler.getMessage(e));
    }
  }

  /// Register a new user
  Future<User> register(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.post(AppConfig.addUser, userData);
      final userResponse = _apiService.handleResponse(response);
      return User.fromJson(userResponse);
    } catch (e, stackTrace) {
      ExceptionHandler.log('register', e, stackTrace);
      throw Exception(ExceptionHandler.getMessage(e));
    }
  }

  /// Logout and clear session
  Future<void> logout() async {
    await _apiService.clearSession();
    await _clearUserData();
    AppLogger.info('User logged out', 'AuthService');
  }

  /// Check if user is logged in and restore session
  Future<User?> restoreSession() async {
    await _apiService.loadUserSession();
    final userId = _apiService.currentUserId;

    if (userId == null) {
      return null;
    }

    // Try to get user data from local storage first
    final localUser = await _loadUserData();
    if (localUser != null) {
      AppLogger.info('Session restored from local storage', 'AuthService');
      return localUser;
    }

    // If no local data, fetch from server
    try {
      final response = await _apiService.get(AppConfig.getUser(userId));
      final userData = _apiService.handleResponse(response);
      final user = User.fromJson(userData);
      await _saveUserData(user);
      AppLogger.info('Session restored from server', 'AuthService');
      return user;
    } catch (e, stackTrace) {
      ExceptionHandler.log('restoreSession', e, stackTrace);
      // If fetch fails, clear session
      await logout();
      return null;
    }
  }

  /// Update user profile
  Future<User> updateUser(User user, String currentPassword) async {
    try {
      final updateData = user.toUpdateJson(currentPassword);
      final response = await _apiService.put(AppConfig.updateUser, updateData);

      if (_apiService.isSuccessful(response)) {
        final responseData = _apiService.handleResponse(response);
        final updatedUser = User.fromJson(responseData);
        await _saveUserData(updatedUser);
        AppLogger.success('User profile updated', 'AuthService');
        return updatedUser;
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e, stackTrace) {
      ExceptionHandler.log('updateUser', e, stackTrace);
      throw Exception(ExceptionHandler.getMessage(e));
    }
  }

  /// Get user by ID from server
  Future<User> getUserById(int userId) async {
    try {
      final response = await _apiService.get(AppConfig.getUser(userId));
      final userData = _apiService.handleResponse(response);
      return User.fromJson(userData);
    } catch (e, stackTrace) {
      ExceptionHandler.log('getUserById', e, stackTrace);
      throw Exception(ExceptionHandler.getMessage(e));
    }
  }

  // Save user data to local storage
  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', user.id);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_dob', user.dateOfBirth);
    await prefs.setString('user_gender', user.gender);
    await prefs.setDouble('user_height', user.height);
    await prefs.setDouble('user_weight', user.weight);
    await prefs.setString('user_blood_group', user.bloodGroup);
  }

  // Load user data from local storage
  Future<User?> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      return null;
    }

    return User(
      id: userId,
      name: prefs.getString('user_name') ?? '',
      email: prefs.getString('user_email') ?? '',
      dateOfBirth: prefs.getString('user_dob') ?? '',
      gender: prefs.getString('user_gender') ?? '',
      height: prefs.getDouble('user_height') ?? 0.0,
      weight: prefs.getDouble('user_weight') ?? 0.0,
      bloodGroup: prefs.getString('user_blood_group') ?? '',
    );
  }

  // Clear user data from local storage
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_dob');
    await prefs.remove('user_gender');
    await prefs.remove('user_height');
    await prefs.remove('user_weight');
    await prefs.remove('user_blood_group');
  }
}
