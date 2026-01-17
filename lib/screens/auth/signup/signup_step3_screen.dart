import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/inputs/custom_text_field.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/buttons/secondary_button.dart';
import '../../../providers/auth_provider.dart';

class SignupStep3Screen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const SignupStep3Screen({
    super.key,
    required this.userData,
  });

  @override
  State<SignupStep3Screen> createState() => _SignupStep3ScreenState();
}

class _SignupStep3ScreenState extends State<SignupStep3Screen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _completeSignup() async {
    if (_formKey.currentState!.validate()) {
      final completeUserData = {
        ...widget.userData,
        'height': double.parse(_heightController.text),
        'weight': double.parse(_weightController.text),
      };

      final success =
          await context.read<AuthProvider>().register(completeUserData);

      if (!mounted) return;

      if (success) {
        // Show success message and navigate back to login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Account created successfully! Please login to continue.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to login screen
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.read<AuthProvider>().errorMessage ??
                'Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Progress indicator
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Title
                const Text(
                  'Step 3: Physical Metrics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Almost done! Enter your physical measurements',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Summary card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Account Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildSummaryRow('Name', widget.userData['name']),
                        _buildSummaryRow('Email', widget.userData['email']),
                        _buildSummaryRow(
                            'Date of Birth', widget.userData['dateOfBirth']),
                        _buildSummaryRow('Gender', widget.userData['gender']),
                        _buildSummaryRow(
                            'Blood Group', widget.userData['bloodGroup']),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Height field
                CustomTextField(
                  controller: _heightController,
                  label: 'Height (cm)',
                  hint: 'Enter your height in centimeters',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    final height = double.tryParse(value);
                    if (height == null) {
                      return 'Please enter a valid number';
                    }
                    if (height < 50 || height > 300) {
                      return 'Please enter a realistic height (50-300 cm)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Weight field
                CustomTextField(
                  controller: _weightController,
                  label: 'Weight (kg)',
                  hint: 'Enter your weight in kilograms',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null) {
                      return 'Please enter a valid number';
                    }
                    if (weight < 10 || weight > 500) {
                      return 'Please enter a realistic weight (10-500 kg)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                // Navigation buttons
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: 'Back',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return PrimaryButton(
                            text: 'Create Account',
                            onPressed:
                                authProvider.isLoading ? null : _completeSignup,
                            isLoading: authProvider.isLoading,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
