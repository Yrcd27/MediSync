import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import 'signup_step3_screen.dart';

class SignupStep2Screen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const SignupStep2Screen({
    super.key,
    required this.userData,
  });

  @override
  State<SignupStep2Screen> createState() => _SignupStep2ScreenState();
}

class _SignupStep2ScreenState extends State<SignupStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _dobController = TextEditingController();
  String _selectedGender = '';
  String _selectedBloodGroup = '';

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      if (_selectedGender.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select your gender'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedBloodGroup.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select your blood group'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final updatedUserData = {
        ...widget.userData,
        'dateOfBirth': _dobController.text,
        'gender': _selectedGender,
        'bloodGroup': _selectedBloodGroup,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupStep3Screen(userData: updatedUserData),
        ),
      );
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
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Title
                const Text(
                  'Step 2: Personal Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tell us a bit more about yourself',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Date of Birth
                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: _dobController,
                      label: 'Date of Birth',
                      hint: 'Select your date of birth',
                      suffixIcon: const Icon(Icons.calendar_today),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Gender
                const Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: _genders.map((gender) {
                    final isSelected = _selectedGender == gender;
                    return ChoiceChip(
                      label: Text(gender),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedGender = selected ? gender : '';
                        });
                      },
                      selectedColor: Colors.blue.withValues(alpha: 0.2),
                      backgroundColor: Colors.grey.shade100,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.blue : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                // Blood Group
                const Text(
                  'Blood Group',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: _bloodGroups.map((bloodGroup) {
                    final isSelected = _selectedBloodGroup == bloodGroup;
                    return ChoiceChip(
                      label: Text(bloodGroup),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedBloodGroup = selected ? bloodGroup : '';
                        });
                      },
                      selectedColor: Colors.blue.withValues(alpha: 0.2),
                      backgroundColor: Colors.grey.shade100,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.blue : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                // Navigation buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Back',
                        onPressed: () => Navigator.pop(context),
                        backgroundColor: Colors.grey.shade300,
                        textColor: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: 'Next',
                        onPressed: _nextStep,
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
}
