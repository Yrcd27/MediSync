import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/health_records_provider.dart';
import '../../../models/liver_profile.dart';
import '../../../widgets/buttons/primary_button.dart';

class AddLiverProfileScreen extends StatefulWidget {
  const AddLiverProfileScreen({super.key});

  @override
  State<AddLiverProfileScreen> createState() => _AddLiverProfileScreenState();
}

class _AddLiverProfileScreenState extends State<AddLiverProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _proteinController = TextEditingController();
  final _albuminController = TextEditingController();
  final _bilirubinController = TextEditingController();
  final _sgptController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _proteinController.dispose();
    _albuminController.dispose();
    _bilirubinController.dispose();
    _sgptController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.liverProfile,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final user = context.read<AuthProvider>().currentUser;
      final healthProvider = context.read<HealthRecordsProvider>();

      if (user == null) {
        _showError('User not found');
        return;
      }

      final record = LiverProfile(
        id: 0,
        testDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        proteinTotalSerum: double.parse(_proteinController.text),
        albuminSerum: double.parse(_albuminController.text),
        bilirubinTotalSerum: double.parse(_bilirubinController.text),
        sgpt: double.parse(_sgptController.text),
        imageUrl: null,
      );

      final success = await healthProvider.addLiverRecord(record, user.id);

      if (mounted) {
        if (success) {
          _showSuccess('Liver profile record added!');
          Navigator.pop(context);
        } else {
          _showError(healthProvider.errorMessage ?? 'Failed to add record');
        }
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.success),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text('Add Liver Profile', style: AppTypography.title1),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.liverProfile.withOpacity(0.15),
                    borderRadius: AppSpacing.borderRadiusLg,
                  ),
                  child: Icon(
                    Icons.local_hospital_rounded,
                    size: 40,
                    color: AppColors.liverProfile,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              _buildDatePicker(isDark),
              const SizedBox(height: AppSpacing.xl),

              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      _proteinController,
                      'Total Protein',
                      '7.0',
                      'g/dL',
                      isDark,
                      (v) => _validateRange(v, 3, 12),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildInputField(
                      _albuminController,
                      'Albumin',
                      '4.0',
                      'g/dL',
                      isDark,
                      (v) => _validateRange(v, 1, 7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      _bilirubinController,
                      'Bilirubin',
                      '0.8',
                      'mg/dL',
                      isDark,
                      (v) => _validateRange(v, 0.1, 15),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildInputField(
                      _sgptController,
                      'SGPT (ALT)',
                      '25',
                      'U/L',
                      isDark,
                      (v) => _validateRange(v, 5, 500),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.info,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Normal Ranges',
                          style: AppTypography.label2.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Total Protein: 6.0-8.3 g/dL',
                      style: AppTypography.caption,
                    ),
                    Text('Albumin: 3.5-5.0 g/dL', style: AppTypography.caption),
                    Text(
                      'Bilirubin: 0.1-1.2 mg/dL',
                      style: AppTypography.caption,
                    ),
                    Text('SGPT (ALT): 7-56 U/L', style: AppTypography.caption),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxxl),

              PrimaryButton(
                text: 'Save Record',
                onPressed: _isSubmitting ? null : _submitForm,
                isLoading: _isSubmitting,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateRange(String? value, double min, double max) {
    if (value == null || value.isEmpty) return 'Required';
    final val = double.tryParse(value);
    if (val == null || val < min || val > max) return 'Invalid';
    return null;
  }

  Widget _buildDatePicker(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Test Date', style: AppTypography.label1),
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.liverProfile,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  DateFormat('MMMM dd, yyyy').format(_selectedDate),
                  style: AppTypography.body1,
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label,
    String hint,
    String suffix,
    bool isDark,
    String? Function(String?) validator,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.label2),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
            filled: true,
            fillColor: isDark
                ? AppColors.darkSurfaceVariant
                : AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusMd,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppSpacing.borderRadiusMd,
              borderSide: BorderSide(color: AppColors.liverProfile, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
          ),
        ),
      ],
    );
  }
}
