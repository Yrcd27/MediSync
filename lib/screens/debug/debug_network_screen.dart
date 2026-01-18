import 'package:flutter/material.dart';
import '../../core/config/app_config.dart';
import '../../core/utils/app_logger.dart';
import '../../services/auth_service.dart';

class DebugNetworkScreen extends StatefulWidget {
  const DebugNetworkScreen({super.key});

  @override
  State<DebugNetworkScreen> createState() => _DebugNetworkScreenState();
}

class _DebugNetworkScreenState extends State<DebugNetworkScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
            const Text(
              'Test Credentials:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                hintText: 'Enter test email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                hintText: 'Enter test password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_emailController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter email and password'),
                    ),
                  );
                  return;
                }
                await _testUserUpdate();
              },
              child: const Text('Test User Update Fix'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testUserUpdate() async {
    if (!mounted) return;

    try {
      final authService = AuthService();
      final testEmail = _emailController.text;
      final testPassword = _passwordController.text;

      AppLogger.info('Starting user update test...', 'Debug');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Testing user login and update...')),
      );

      // Step 1: Login to get a user
      final user = await authService.login(testEmail, testPassword);
      AppLogger.success('Login successful. User: ${user.name}', 'Debug');

      // Step 2: Try to update the user with current password
      final updatedUser = user.copyWith(
        name: 'Test Update ${DateTime.now().millisecond}',
      );

      final result = await authService.updateUser(updatedUser, testPassword);
      AppLogger.success('Update successful! Result: ${result.name}', 'Debug');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Update test PASSED! User: ${result.name}')),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Update test FAILED',
        tag: 'Debug',
        error: e,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Update test FAILED: $e')));
    }
  }
}
