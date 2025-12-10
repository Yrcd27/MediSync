import 'package:flutter/material.dart';
import '../../core/config/app_config.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

class DebugNetworkScreen extends StatelessWidget {
  const DebugNetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Debug')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Network Configuration:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Base URL: ${AppConfig.baseUrl}'),
                    Text('API Version: ${AppConfig.apiVersion}'),
                    Text('Full Base URL: ${AppConfig.fullBaseUrl}'),
                    const SizedBox(height: 8),
                    Text('Register URL: ${AppConfig.baseUrl}/users/addUser'),
                    Text('Login URL: ${AppConfig.baseUrl}/users/login'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Test URLs:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Backend should be running on your computer port 8080',
            ),
            const Text('• Using IP 192.168.56.1 for network access'),
            const Text(
              '• Make sure your backend allows connections from your IP',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await _testUserUpdate(context);
              },
              child: const Text('Test User Update Fix'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testUserUpdate(BuildContext context) async {
    try {
      final authService = AuthService();
      const testPassword = 'nimal@123'; // Current password for testing

      print('Starting user update test...');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Testing user login and update...')),
      );

      // Step 1: Login to get a user
      final user = await authService.login('nimal123@gmail.com', testPassword);
      print('Login successful. User: ${user.name}');

      // Step 2: Try to update the user with current password
      final updatedUser = user.copyWith(
        name: 'Nimal Test Update ${DateTime.now().millisecond}',
      );

      final result = await authService.updateUser(updatedUser, testPassword);
      print('Update successful! Result: ${result.name}');

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Update test PASSED! User: ${result.name}')),
      );
    } catch (e) {
      print('Update test FAILED: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Update test FAILED: $e')));
    }
  }
}
