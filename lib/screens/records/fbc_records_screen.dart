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
import '../../models/full_blood_count.dart';

class FbcRecordsScreen extends StatefulWidget {
  const FbcRecordsScreen({super.key});

  @override
  State<FbcRecordsScreen> createState() => _FbcRecordsScreenState();
}

class _FbcRecordsScreenState extends State<FbcRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testDateController = TextEditingController();
  final _haemoglobinController = TextEditingController();
  final _wbcController = TextEditingController();
  final _plateletController = TextEditingController();
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
    _haemoglobinController.dispose();
    _wbcController.dispose();
    _plateletController.dispose();
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

        final record = FullBloodCount(
          id: 0,
          testDate: _testDateController.text,
          haemoglobin: double.parse(_haemoglobinController.text),
          totalLeucocyteCount: double.parse(_wbcController.text),
          plateletCount: double.parse(_plateletController.text),
          imageUrl: _imageUrlController.text.isEmpty
              ? null
              : _imageUrlController.text,
        );

        final success = await healthProvider.addFBCRecord(
          record,
          authProvider.currentUser!.id,
        );

        if (mounted) {
          if (success) {
            CustomSnackBar.show(
              context,
              message: 'FBC record added successfully!',
              type: SnackBarType.success,
            );

            _haemoglobinController.clear();
            _wbcController.clear();
            _plateletController.clear();
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
                            color: AppColors.bloodCount.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Icon(
                            Icons.bloodtype_rounded,
                            color: AppColors.bloodCount,
                            size: AppSpacing.iconMd,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Text(
                          'Add Full Blood Count',
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

                    CustomTextField(
                      controller: _haemoglobinController,
                      label: 'Haemoglobin (g/dL)',
                      hint: '14.5',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 5 || val > 20)
                          return 'Invalid range (5-20)';
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _wbcController,
                      label: 'WBC (cells/mcL)',
                      hint: '7500',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 3000 || val > 15000)
                          return 'Invalid range (3000-15000)';
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _plateletController,
                      label: 'Platelet (cells/mcL)',
                      hint: '250000',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 100000 || val > 500000)
                          return 'Invalid range (100000-500000)';
                        return null;
                      },
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
                if (healthProvider.fbcRecords.isEmpty) {
                  return const EmptyState(
                    icon: Icons.bloodtype_outlined,
                    message: 'No FBC records yet',
                    description: 'Add your first full blood count record above',
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: healthProvider.fbcRecords.length,
                  itemBuilder: (context, index) {
                    final record = healthProvider
                        .fbcRecords[healthProvider.fbcRecords.length - 1 - index];
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

  Widget _buildRecordCard(FullBloodCount record, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.all(AppSpacing.md),
        childrenPadding: EdgeInsets.all(AppSpacing.md),
        leading: Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: _getHemoglobinColor(record.haemoglobin).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.bloodtype_rounded,
            color: _getHemoglobinColor(record.haemoglobin),
            size: AppSpacing.iconMd,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Hb: ${record.haemoglobin.toStringAsFixed(1)} g/dL',
                style: AppTypography.titleSmall.copyWith(
                  color:
                      isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: _getHemoglobinColor(record.haemoglobin).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Text(
                _getHemoglobinStatus(record.haemoglobin),
                style: AppTypography.labelSmall.copyWith(
                  color: _getHemoglobinColor(record.haemoglobin),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy').format(DateTime.parse(record.testDate)),
          style: AppTypography.bodySmall.copyWith(
            color:
                isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'WBC: ${record.totalLeucocyteCount.toStringAsFixed(0)} cells/mcL',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Platelets: ${record.plateletCount.toStringAsFixed(0)} cells/mcL',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getHemoglobinColor(double hemoglobin) {
    if (hemoglobin >= 12.0) return AppColors.success;
    if (hemoglobin >= 10.0) return AppColors.warning;
    return AppColors.error;
  }

  String _getHemoglobinStatus(double hemoglobin) {
    if (hemoglobin >= 12.0) return 'Normal';
    if (hemoglobin >= 10.0) return 'Low';
    return 'Very Low';
  }
}
