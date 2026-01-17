import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/inputs/custom_text_field.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/feedback/loading_indicator.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/feedback/custom_snackbar.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../models/blood_pressure.dart';

class BloodPressureRecordsScreen extends StatefulWidget {
  const BloodPressureRecordsScreen({super.key});

  @override
  State<BloodPressureRecordsScreen> createState() =>
      _BloodPressureRecordsScreenState();
}

class _BloodPressureRecordsScreenState
    extends State<BloodPressureRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testDateController = TextEditingController();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _testDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _testDateController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _testDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _addRecord() async {
    if (_formKey.currentState!.validate() && !_isSubmitting) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final authProvider = context.read<AuthProvider>();
        final healthProvider = context.read<HealthRecordsProvider>();

        if (authProvider.currentUser == null) return;

        final record = BloodPressure(
          id: 0,
          testDate: _testDateController.text,
          bpLevel: '${_systolicController.text}/${_diastolicController.text}',
          imageUrl: _imageUrlController.text.isEmpty
              ? null
              : _imageUrlController.text,
        );

        final success = await healthProvider.addBPRecord(
          record,
          authProvider.currentUser!.id,
        );

        if (mounted) {
          if (success) {
            CustomSnackBar.show(
              context,
              message: 'Blood pressure record added successfully!',
              type: SnackBarType.success,
            );

            _systolicController.clear();
            _diastolicController.clear();
            _imageUrlController.clear();
            _testDateController.text = DateFormat(
              'yyyy-MM-dd',
            ).format(DateTime.now());
          } else {
            CustomSnackBar.show(
              context,
              message: healthProvider.errorMessage ?? 'Error adding record',
              type: SnackBarType.error,
            );
          }
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.bloodPressure.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                          ),
                          child: Icon(
                            Icons.favorite_rounded,
                            color: AppColors.bloodPressure,
                            size: AppSpacing.iconMd,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Text(
                          'Add Blood Pressure',
                          style: AppTypography.titleMedium.copyWith(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.lg),

                    GestureDetector(
                      onTap: _selectDate,
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _testDateController,
                          label: 'Test Date',
                          hint: 'Select date',
                          suffixIcon: Icons.calendar_today,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _systolicController,
                            label: 'Systolic (mmHg)',
                            hint: '120',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Required';
                              final val = double.tryParse(value);
                              if (val == null || val < 80 || val > 200)
                                return 'Invalid range (80-200)';
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: CustomTextField(
                            controller: _diastolicController,
                            label: 'Diastolic (mmHg)',
                            hint: '80',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Required';
                              final val = double.tryParse(value);
                              if (val == null || val < 50 || val > 130)
                                return 'Invalid range (50-130)';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _imageUrlController,
                      label: 'Report Image (Optional)',
                      hint: 'URL or file path',
                    ),
                    SizedBox(height: AppSpacing.lg),

                    PrimaryButton(
                      text: 'Add Record',
                      onPressed: _isSubmitting ? null : _addRecord,
                      isLoading: _isSubmitting,
                      icon: Icons.add_rounded,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            Consumer<HealthRecordsProvider>(
              builder: (context, healthProvider, child) {
                if (healthProvider.bpRecords.isEmpty) {
                  return const EmptyState(
                    icon: Icons.favorite_border,
                    message: 'No blood pressure records yet',
                    description: 'Add your first blood pressure record above',
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: healthProvider.bpRecords.length,
                  itemBuilder: (context, index) {
                    final record = healthProvider
                        .bpRecords[healthProvider.bpRecords.length - 1 - index];
                    return _buildRecordCard(record, isDark);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard(BloodPressure record, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(AppSpacing.md),
        leading: Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: _getBPColor(
              record.systolic.toDouble(),
              record.diastolic.toDouble(),
            ).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.favorite_rounded,
            color: _getBPColor(
              record.systolic.toDouble(),
              record.diastolic.toDouble(),
            ),
            size: AppSpacing.iconMd,
          ),
        ),
        title: Text(
          '${record.systolic.toStringAsFixed(0)}/${record.diastolic.toStringAsFixed(0)} mmHg',
          style: AppTypography.titleSmall.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy').format(DateTime.parse(record.testDate)),
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: _getBPColor(
              record.systolic.toDouble(),
              record.diastolic.toDouble(),
            ).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Text(
            _getBPStatus(
              record.systolic.toDouble(),
              record.diastolic.toDouble(),
            ),
            style: AppTypography.labelSmall.copyWith(
              color: _getBPColor(
                record.systolic.toDouble(),
                record.diastolic.toDouble(),
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getBPColor(double systolic, double diastolic) {
    if (systolic < 120 && diastolic < 80) return AppColors.success;
    if (systolic < 140 || diastolic < 90) return AppColors.warning;
    return AppColors.error;
  }

  String _getBPStatus(double systolic, double diastolic) {
    if (systolic < 120 && diastolic < 80) return 'Normal';
    if (systolic < 140 || diastolic < 90) return 'Elevated';
    return 'High';
  }
}
