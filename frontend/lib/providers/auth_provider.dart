import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

/// Authentication Provider for managing user state
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _currentUser;
  String? _currentPassword; // Store for profile updates
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  /// Check authentication status and restore session
  Future<void> checkAuthStatus() async {
    // Don't notify during initial loading to avoid build-time state changes
    _isLoading = true;

    try {
      _currentUser = await _authService.restoreSession();
    } catch (e) {
      _currentUser = null;
    } finally {
      _isLoading = false;
      // Only notify after the complete operation to prevent build-time conflicts
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.login(email, password);
      _currentPassword = password; // Store for profile updates
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register a new user
  Future<bool> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(userData);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update user profile
  Future<bool> updateUser(User user) async {
    if (_currentPassword == null) {
      _errorMessage = 'Please login again to update your profile.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedUser = await _authService.updateUser(
        user,
        _currentPassword!,
      );
      _currentUser = updatedUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update password (requires re-login)
  void setPassword(String password) {
    _currentPassword = password;
  }

  /// Logout
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _currentPassword = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
