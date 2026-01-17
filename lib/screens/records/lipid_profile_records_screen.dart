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
import '../../models/lipid_profile.dart';

class LipidProfileRecordsScreen extends StatefulWidget {
  const LipidProfileRecordsScreen({super.key});

  @override
  State<LipidProfileRecordsScreen> createState() =>
      _LipidProfileRecordsScreenState();
}

class _LipidProfileRecordsScreenState extends State<LipidProfileRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testDateController = TextEditingController();
  final _totalCholesterolController = TextEditingController();
  final _hdlController = TextEditingController();
  final _ldlController = TextEditingController();
  final _triglyceridesController = TextEditingController();
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
    _totalCholesterolController.dispose();
    _hdlController.dispose();
    _ldlController.dispose();
    _triglyceridesController.dispose();
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

        final record = LipidProfile(
          id: 0,
          testDate: _testDateController.text,
          totalCholesterol: double.parse(_totalCholesterolController.text),
          hdl: double.parse(_hdlController.text),
          ldl: double.parse(_ldlController.text),
          vldl:
              double.parse(_triglyceridesController.text) /
              5, // VLDL is typically calculated as triglycerides/5
          triglycerides: double.parse(_triglyceridesController.text),
          imageUrl: _imageUrlController.text.isEmpty
              ? null
              : _imageUrlController.text,
        );

        final success = await healthProvider.addLipidRecord(
          record,
          authProvider.currentUser!.id,
        );

        if (mounted) {
          if (success) {
            CustomSnackBar.show(
              context,
              message: 'Lipid profile record added successfully!',
              type: SnackBarType.success,
            );

            _totalCholesterolController.clear();
            _hdlController.clear();
            _ldlController.clear();
            _triglyceridesController.clear();
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
                            color: AppColors.lipidProfile.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Icon(
                            Icons.favorite_rounded,
                            color: AppColors.lipidProfile,
                            size: AppSpacing.iconMd,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Text(
                          'Add Lipid Profile',
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
                      controller: _totalCholesterolController,
                      label: 'Total Cholesterol (mg/dL)',
                      hint: '200',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 100 || val > 400)
                          return 'Invalid range (100-400)';
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _hdlController,
                      label: 'HDL (mg/dL)',
                      hint: '50',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 20 || val > 100)
                          return 'Invalid range (20-100)';
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _ldlController,
                      label: 'LDL (mg/dL)',
                      hint: '100',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 50 || val > 300)
                          return 'Invalid range (50-300)';
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _triglyceridesController,
                      label: 'Triglycerides (mg/dL)',
                      hint: '150',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 50 || val > 500)
                          return 'Invalid range (50-500)';
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
                if (healthProvider.lipidRecords.isEmpty) {
                  return const EmptyState(
                    icon: Icons.favorite_border,
                    message: 'No lipid profile records yet',
                    description: 'Add your first lipid profile record above',
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: healthProvider.lipidRecords.length,
                  itemBuilder: (context, index) {
                    final record = healthProvider
                        .lipidRecords[healthProvider.lipidRecords.length - 1 - index];
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

  Widget _buildRecordCard(LipidProfile record, bool isDark) {
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
            color: _getCholesterolColor(record.totalCholesterol).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.favorite_rounded,
            color: _getCholesterolColor(record.totalCholesterol),
            size: AppSpacing.iconMd,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Total: ${record.totalCholesterol.toStringAsFixed(0)} mg/dL',
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
                color: _getCholesterolColor(record.totalCholesterol).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Text(
                _getCholesterolStatus(record.totalCholesterol),
                style: AppTypography.labelSmall.copyWith(
                  color: _getCholesterolColor(record.totalCholesterol),
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
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'HDL: ${record.hdl.toStringAsFixed(0)} mg/dL',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'LDL: ${record.ldl.toStringAsFixed(0)} mg/dL',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Triglycerides: ${record.triglycerides.toStringAsFixed(0)} mg/dL',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'TC/HDL: ${(record.totalCholesterol / record.hdl).toStringAsFixed(1)}',
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
        ],
      ),
    );
  }

  Color _getCholesterolColor(double cholesterol) {
    if (cholesterol < 200) return AppColors.success;
    if (cholesterol < 240) return AppColors.warning;
    return AppColors.error;
  }

  String _getCholesterolStatus(double cholesterol) {
    if (cholesterol < 200) return 'Normal';
    if (cholesterol < 240) return 'Borderline';
    return 'High';
  }
}
