import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/health_records_provider.dart';
import '../../../models/full_blood_count.dart';
import '../../../widgets/buttons/primary_button.dart';

class AddBloodCountScreen extends StatefulWidget {
  const AddBloodCountScreen({super.key});

  @override
  State<AddBloodCountScreen> createState() => _AddBloodCountScreenState();
}

class _AddBloodCountScreenState extends State<AddBloodCountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hbController = TextEditingController();
  final _wbcController = TextEditingController();
  final _plateletController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _hbController.dispose();
    _wbcController.dispose();
    _plateletController.dispose();
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
              primary: AppColors.bloodCount,
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

      final record = FullBloodCount(
        id: 0,
        testDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        haemoglobin: double.parse(_hbController.text),
        totalLeucocyteCount: double.parse(_wbcController.text),
        plateletCount: double.parse(_plateletController.text),
        imageUrl: null,
      );

      final success = await healthProvider.addFBCRecord(record, user.id);

      if (mounted) {
        if (success) {
          _showSuccess('Blood count record added!');
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
        title: Text('Add Blood Count', style: AppTypography.title1),
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
                    color: AppColors.bloodCount.withOpacity(0.15),
                    borderRadius: AppSpacing.borderRadiusLg,
                  ),
                  child: Icon(
                    Icons.science_rounded,
                    size: 40,
                    color: AppColors.bloodCount,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Date Picker
              _buildDatePicker(isDark),

              const SizedBox(height: AppSpacing.xl),

              // Hemoglobin
              _buildInputField(
                controller: _hbController,
                label: 'Hemoglobin (Hb)',
                hint: '14.0',
                suffix: 'g/dL',
                isDark: isDark,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  final val = double.tryParse(v);
                  if (val == null || val < 5 || val > 25) return 'Enter 5-25';
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // WBC
              _buildInputField(
                controller: _wbcController,
                label: 'WBC (Total Leucocyte Count)',
                hint: '7000',
                suffix: 'cells/mcL',
                isDark: isDark,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  final val = double.tryParse(v);
                  if (val == null || val < 1000 || val > 50000) {
                    return 'Enter 1000-50000';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Platelets
              _buildInputField(
                controller: _plateletController,
                label: 'Platelet Count',
                hint: '250000',
                suffix: 'cells/mcL',
                isDark: isDark,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  final val = double.tryParse(v);
                  if (val == null || val < 50000 || val > 700000) {
                    return 'Enter valid range';
                  }
                  return null;
                },
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
                      'Hb: Male 13.5-17.5, Female 12-16 g/dL',
                      style: AppTypography.caption,
                    ),
                    Text(
                      'WBC: 4,500-11,000 cells/mcL',
                      style: AppTypography.caption,
                    ),
                    Text(
                      'Platelets: 150,000-400,000 cells/mcL',
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
                  color: AppColors.bloodCount,
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String suffix,
    required bool isDark,
    required String? Function(String?) validator,
  }) {
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
              borderSide: BorderSide(color: AppColors.bloodCount, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
