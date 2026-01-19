import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/health_records_provider.dart';
import '../../../models/fasting_blood_sugar.dart';
import '../../../widgets/buttons/primary_button.dart';

class AddBloodSugarScreen extends StatefulWidget {
  const AddBloodSugarScreen({super.key});

  @override
  State<AddBloodSugarScreen> createState() => _AddBloodSugarScreenState();
}

class _AddBloodSugarScreenState extends State<AddBloodSugarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fbsController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fbsController.dispose();
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
              primary: AppColors.bloodSugar,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
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

      final record = FastingBloodSugar(
        id: 0,
        testDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        fbsLevel: double.parse(_fbsController.text),
        imageUrl: null,
      );

      final success = await healthProvider.addFBSRecord(record, user);

      if (mounted) {
        if (success) {
          _showSuccess('Blood sugar record added!');
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
        title: Text('Add Blood Sugar', style: AppTypography.title1),
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
                    color: AppColors.bloodSugar.withOpacity(0.15),
                    borderRadius: AppSpacing.borderRadiusLg,
                  ),
                  child: Icon(
                    Icons.water_drop_rounded,
                    size: 40,
                    color: AppColors.bloodSugar,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Date Picker
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
                        color: AppColors.bloodSugar,
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

              const SizedBox(height: AppSpacing.xl),

              // FBS Value
              Text('Fasting Blood Sugar', style: AppTypography.label1),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _fbsController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: AppTypography.headline3,
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  final val = double.tryParse(value);
                  if (val == null || val < 30 || val > 500) {
                    return 'Enter 30-500';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: '95',
                  suffixText: 'mg/dL',
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
                    borderSide: BorderSide(
                      color: AppColors.bloodSugar,
                      width: 2,
                    ),
                  ),
                ),
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
                          'Reference Ranges',
                          style: AppTypography.label2.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Normal: Below 100 mg/dL',
                      style: AppTypography.caption,
                    ),
                    Text(
                      'Pre-diabetic: 100-125 mg/dL',
                      style: AppTypography.caption,
                    ),
                    Text('Diabetic: 126+ mg/dL', style: AppTypography.caption),
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
}
