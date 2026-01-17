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
import '../../models/liver_profile.dart';

class LiverProfileRecordsScreen extends StatefulWidget {
  const LiverProfileRecordsScreen({super.key});

  @override
  State<LiverProfileRecordsScreen> createState() =>
      _LiverProfileRecordsScreenState();
}

class _LiverProfileRecordsScreenState extends State<LiverProfileRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testDateController = TextEditingController();
  final _totalProteinController = TextEditingController();
  final _albuminController = TextEditingController();
  final _bilirubinController = TextEditingController();
  final _sgptController = TextEditingController();
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
    _totalProteinController.dispose();
    _albuminController.dispose();
    _bilirubinController.dispose();
    _sgptController.dispose();
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

        final record = LiverProfile(
          id: 0,
          testDate: _testDateController.text,
          proteinTotalSerum: double.parse(_totalProteinController.text),
          albuminSerum: double.parse(_albuminController.text),
          bilirubinTotalSerum: double.parse(_bilirubinController.text),
          sgpt: double.parse(_sgptController.text),
          imageUrl: _imageUrlController.text.isEmpty
              ? null
              : _imageUrlController.text,
        );

        final success = await healthProvider.addLiverRecord(
          record,
          authProvider.currentUser!.id,
        );

        if (mounted) {
          if (success) {
            CustomSnackBar.show(
              context,
              message: 'Liver profile record added successfully!',
              type: SnackBarType.success,
            );

            _totalProteinController.clear();
            _albuminController.clear();
            _bilirubinController.clear();
            _sgptController.clear();
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
                            color: AppColors.liverProfile.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                          ),
                          child: Icon(
                            Icons.science_rounded,
                            color: AppColors.liverProfile,
                            size: AppSpacing.iconMd,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Text(
                          'Add Liver Profile',
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
                      controller: _totalProteinController,
                      label: 'Total Protein (g/dL)',
                      hint: '7.0',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 4 || val > 10)
                          return 'Invalid range (4-10)';
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _albuminController,
                      label: 'Albumin (g/dL)',
                      hint: '4.0',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 2 || val > 6)
                          return 'Invalid range (2-6)';
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _bilirubinController,
                      label: 'Bilirubin (mg/dL)',
                      hint: '1.0',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 0 || val > 5)
                          return 'Invalid range (0-5)';
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _sgptController,
                      label: 'SGPT/ALT (U/L)',
                      hint: '30',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 5 || val > 200)
                          return 'Invalid range (5-200)';
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
                if (healthProvider.liverRecords.isEmpty) {
                  return const EmptyState(
                    icon: Icons.science_outlined,
                    message: 'No liver profile records yet',
                    description: 'Add your first liver profile record above',
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: healthProvider.liverRecords.length,
                  itemBuilder: (context, index) {
                    final record =
                        healthProvider.liverRecords[healthProvider
                                .liverRecords
                                .length -
                            1 -
                            index];
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

  Widget _buildRecordCard(LiverProfile record, bool isDark) {
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
            color: _getSGPTColor(record.sgpt).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.science_rounded,
            color: _getSGPTColor(record.sgpt),
            size: AppSpacing.iconMd,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'SGPT: ${record.sgpt.toStringAsFixed(0)} U/L',
                style: AppTypography.titleSmall.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: _getSGPTColor(record.sgpt).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Text(
                _getSGPTStatus(record.sgpt),
                style: AppTypography.labelSmall.copyWith(
                  color: _getSGPTColor(record.sgpt),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy').format(DateTime.parse(record.testDate)),
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total Protein: ${record.proteinTotalSerum.toStringAsFixed(1)} g/dL',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Albumin: ${record.albuminSerum.toStringAsFixed(1)} g/dL',
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
                      'Bilirubin: ${record.bilirubinTotalSerum.toStringAsFixed(1)} mg/dL',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getSGPTColor(double sgpt) {
    if (sgpt <= 40) return AppColors.success;
    if (sgpt <= 80) return AppColors.warning;
    return AppColors.error;
  }

  String _getSGPTStatus(double sgpt) {
    if (sgpt <= 40) return 'Normal';
    if (sgpt <= 80) return 'Elevated';
    return 'High';
  }
}
