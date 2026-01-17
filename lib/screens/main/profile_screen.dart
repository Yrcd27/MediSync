import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/inputs/custom_text_field.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _heightController.text = user.height > 0 ? user.height.toString() : '';
      _weightController.text = user.weight > 0 ? user.weight.toString() : '';
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      _showErrorMessage('No user data available');
      return;
    }

    // Validate and parse numeric inputs
    double? height;
    double? weight;

    try {
      height = double.parse(_heightController.text.trim());
      weight = double.parse(_weightController.text.trim());
    } catch (e) {
      _showErrorMessage(
        'Please enter valid numeric values for height and weight',
      );
      return;
    }

    if (height <= 0 || height > 300) {
      _showErrorMessage('Height must be between 1 and 300 cm');
      return;
    }

    if (weight <= 0 || weight > 500) {
      _showErrorMessage('Weight must be between 1 and 500 kg');
      return;
    }

    try {
      final updatedUser = currentUser.copyWith(
        name: _nameController.text.trim(),
        height: height,
        weight: weight,
      );

      debugPrint('Attempting to update user: ${updatedUser.toJson()}');
      final success = await authProvider.updateUser(updatedUser);

      if (mounted) {
        if (success) {
          setState(() {
            _isEditing = false;
          });
          _showSuccessMessage('Profile updated successfully!');
          _loadUserData(); // Refresh the form with updated data
        } else {
          _showErrorMessage(authProvider.errorMessage ?? 'Update failed');
        }
      }
    } catch (e) {
      debugPrint('Update profile error: $e');
      if (mounted) {
        _showErrorMessage('Update failed: ${e.toString()}');
      }
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await context.read<AuthProvider>().logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;

          if (user == null) {
            return const Center(child: Text('No user data available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Avatar
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue.withValues(alpha: 0.1),
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Profile Form
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Name field
                          CustomTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            hint: 'Enter your full name',
                            enabled: _isEditing,
                            validator: _isEditing
                                ? (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your full name';
                                    }
                                    if (value.trim().length < 2) {
                                      return 'Name must be at least 2 characters';
                                    }
                                    return null;
                                  }
                                : null,
                          ),

                          const SizedBox(height: 16),

                          // Email field (read-only for now)
                          AbsorbPointer(
                            absorbing: true, // Email cannot be changed
                            child: CustomTextField(
                              controller: _emailController,
                              label: 'Email',
                              hint: 'Your email address',
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Date of Birth (read-only)
                          AbsorbPointer(
                            absorbing: true,
                            child: CustomTextField(
                              controller: TextEditingController(
                                text: user.dateOfBirth,
                              ),
                              label: 'Date of Birth',
                              hint: 'Your date of birth',
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Gender (read-only)
                          AbsorbPointer(
                            absorbing: true,
                            child: CustomTextField(
                              controller: TextEditingController(
                                text: user.gender,
                              ),
                              label: 'Gender',
                              hint: 'Your gender',
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Blood Group (read-only)
                          AbsorbPointer(
                            absorbing: true,
                            child: CustomTextField(
                              controller: TextEditingController(
                                text: user.bloodGroup,
                              ),
                              label: 'Blood Group',
                              hint: 'Your blood group',
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Height and Weight in a row
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _heightController,
                                  label: 'Height (cm)',
                                  hint: 'Your height',
                                  enabled: _isEditing,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  validator: _isEditing
                                      ? (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Required';
                                          }
                                          final height = double.tryParse(
                                            value.trim(),
                                          );
                                          if (height == null) {
                                            return 'Invalid number';
                                          }
                                          if (height < 50 || height > 300) {
                                            return '50-300 cm';
                                          }
                                          return null;
                                        }
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomTextField(
                                  controller: _weightController,
                                  label: 'Weight (kg)',
                                  hint: 'Your weight',
                                  enabled: _isEditing,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  validator: _isEditing
                                      ? (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Required';
                                          }
                                          final weight = double.tryParse(
                                            value.trim(),
                                          );
                                          if (weight == null) {
                                            return 'Invalid number';
                                          }
                                          if (weight < 10 || weight > 500) {
                                            return '10-500 kg';
                                          }
                                          return null;
                                        }
                                      : null,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Action buttons
                          if (_isEditing)
                            Row(
                              children: [
                                Expanded(
                                  child: SecondaryButton(
                                    text: 'Cancel',
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = false;
                                      });
                                      _loadUserData(); // Reset form
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: PrimaryButton(
                                    text: 'Save Changes',
                                    onPressed: authProvider.isLoading
                                        ? null
                                        : _updateProfile,
                                    isLoading: authProvider.isLoading,
                                  ),
                                ),
                              ],
                            )
                          else
                            PrimaryButton(
                              text: 'Edit Profile',
                              onPressed: () {
                                setState(() {
                                  _isEditing = true;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // App Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'App Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('App Version', '1.0.0'),
                        _buildInfoRow('Developer', 'MediSync Team'),
                        _buildInfoRow('Support', 'support@medisync.com'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
