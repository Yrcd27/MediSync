import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../widgets/inputs/custom_text_field.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/feedback/custom_snackbar.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/app_logger.dart';
import '../main/main_layout.dart';
import 'signup/signup_step1_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      AppLogger.info(
        'Login attempt for: ${_emailController.text.trim()}',
        'LoginScreen',
      );

      final success = await context.read<AuthProvider>().login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      AppLogger.info('Login result: $success', 'LoginScreen');

      if (!success && mounted) {
        final errorMsg =
            context.read<AuthProvider>().errorMessage ?? 'Login failed';
        AppLogger.warning('Login failed: $errorMsg', 'LoginScreen');

        CustomSnackBar.show(
          context,
          message: errorMsg,
          type: SnackBarType.error,
        );
      } else if (success && mounted) {
        AppLogger.success('Login successful, loading user data', 'LoginScreen');

        // Navigate to dashboard immediately, load data in background
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout()),
          (route) => false,
        );

        // Load fresh health records for the new user in background
        final currentUser = context.read<AuthProvider>().currentUser;
        if (currentUser != null) {
          context.read<HealthRecordsProvider>().loadAllRecords(currentUser.id);
          AppLogger.success('Loading data in background', 'LoginScreen');
        }
      }
    }
  }

  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupStep1Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome text
                  Text(
                    'Welcome Back',
                    style: AppTypography.headline2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Sign in to access your health records',
                    style: AppTypography.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  // Email field
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Password field
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock_outlined,
                    suffixIcon: _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    onSuffixIconPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  // Login button
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return PrimaryButton(
                        text: 'Login',
                        onPressed: authProvider.isLoading ? null : _login,
                        isLoading: authProvider.isLoading,
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Signup link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.body2,
                      ),
                      TextButton(
                        onPressed: _navigateToSignup,
                        child: Text(
                          'Sign up',
                          style: AppTypography.body2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
