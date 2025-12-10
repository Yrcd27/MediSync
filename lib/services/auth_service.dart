import '../models/user.dart';
import '../core/services/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<User> login(String email, String password) async {
    try {
      final response = await _apiService.post('/users/login', {
        'email': email,
        'password': password,
      });

      final userData = _apiService.handleResponse(response);
      final user = User.fromJson(userData);

      // Store user session (in real app, you'd get a token from the response)
      await _apiService.saveToken('dummy_token_${user.id}', user.id);

      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<User> register(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.post('/users/addUser', userData);
      final userResponse = _apiService.handleResponse(response);
      return User.fromJson(userResponse);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    await _apiService.clearToken();
  }

  Future<bool> isLoggedIn() async {
    await _apiService.loadToken();
    return _apiService.currentUserId != null;
  }

  Future<User> updateUser(User user, String currentPassword) async {
    try {
      // Create update data with only the fields that can be updated
      final updateData = {
        'id': user.id,
        'name': user.name,
        'email': user.email, // Include email even if it can't be changed
        'password': currentPassword, // Always include current password
        'dateOfBirth': user.dateOfBirth, // Keep original date format
        'gender': user.gender, // Keep original gender
        'height': user.height,
        'weight': user.weight,
        'bloodGroup': user.bloodGroup, // Keep original blood group
      };

      print('Updating user with data: $updateData');
      final response = await _apiService.put('/users/updateUser', updateData);

      // Check if response is successful
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = _apiService.handleResponse(response);
        final updatedUser = User.fromJson(responseData);
        print('User updated successfully: ${updatedUser.toJson()}');
        return updatedUser;
      } else {
        print(
          'Update failed with status: ${response.statusCode}, body: ${response.body}',
        );
        throw Exception(
          'Update failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Update user error: $e');
      throw Exception('Update failed: ${e.toString()}');
    }
  }
}
