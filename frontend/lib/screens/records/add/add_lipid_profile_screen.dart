import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/health_records_provider.dart';
import '../../../models/lipid_profile.dart';
import '../../../widgets/buttons/primary_button.dart';

class AddLipidProfileScreen extends StatefulWidget {
  const AddLipidProfileScreen({super.key});

  @override
  State<AddLipidProfileScreen> createState() => _AddLipidProfileScreenState();
}

class _AddLipidProfileScreenState extends State<AddLipidProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _totalCholController = TextEditingController();
  final _hdlController = TextEditingController();
  final _ldlController = TextEditingController();
  final _vldlController = TextEditingController();
  final _triglyceridesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _totalCholController.dispose();
    _hdlController.dispose();
    _ldlController.dispose();
    _vldlController.dispose();
    _triglyceridesController.dispose();
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
              primary: AppColors.lipidProfile,
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

      final record = LipidProfile(
        id: 0,
        testDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        totalCholesterol: double.parse(_totalCholController.text),
        hdl: double.parse(_hdlController.text),
        ldl: double.parse(_ldlController.text),
        vldl: double.parse(_vldlController.text),
        triglycerides: double.parse(_triglyceridesController.text),
        imageUrl: null,
      );

      final success = await healthProvider.addLipidRecord(record, user.id);

      if (mounted) {
        if (success) {
          _showSuccess('Lipid profile record added!');
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
        title: Text('Add Lipid Profile', style: AppTypography.title1),
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
                    color: AppColors.lipidProfile.withOpacity(0.15),
                    borderRadius: AppSpacing.borderRadiusLg,
                  ),
                  child: Icon(
                    Icons.monitor_heart_rounded,
                    size: 40,
                    color: AppColors.lipidProfile,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              _buildDatePicker(isDark),
              const SizedBox(height: AppSpacing.xl),

              _buildInputField(
                _totalCholController,
                'Total Cholesterol',
                '180',
                'mg/dL',
                isDark,
                (v) => _validateRange(v, 50, 400),
              ),
              const SizedBox(height: AppSpacing.lg),

              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      _hdlController,
                      'HDL',
                      '50',
                      'mg/dL',
                      isDark,
                      (v) => _validateRange(v, 10, 150),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildInputField(
                      _ldlController,
                      'LDL',
                      '100',
                      'mg/dL',
                      isDark,
                      (v) => _validateRange(v, 20, 300),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      _vldlController,
                      'VLDL',
                      '30',
                      'mg/dL',
                      isDark,
                      (v) => _validateRange(v, 5, 100),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildInputField(
                      _triglyceridesController,
                      'Triglycerides',
                      '150',
                      'mg/dL',
                      isDark,
                      (v) => _validateRange(v, 30, 600),
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
                          'Desirable Levels',
                          style: AppTypography.label2.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Total Cholesterol: <200 mg/dL',
                      style: AppTypography.caption,
                    ),
                    Text(
                      'HDL: >40 mg/dL (higher is better)',
                      style: AppTypography.caption,
                    ),
                    Text(
                      'LDL: <100 mg/dL (lower is better)',
                      style: AppTypography.caption,
                    ),
                    Text(
                      'Triglycerides: <150 mg/dL',
                      style: AppTypography.caption,
                    ),
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
                  color: AppColors.lipidProfile,
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
        Text(label, style: AppTypography.label1),
        const SizedBox(height: AppSpacing.sm),
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
              borderSide: BorderSide(color: AppColors.lipidProfile, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
