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
import '../../models/fasting_blood_sugar.dart';

class FbsRecordsScreen extends StatefulWidget {
  const FbsRecordsScreen({super.key});

  @override
  State<FbsRecordsScreen> createState() => _FbsRecordsScreenState();
}

class _FbsRecordsScreenState extends State<FbsRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testDateController = TextEditingController();
  final _fbsController = TextEditingController();
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
    _fbsController.dispose();
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

        final record = FastingBloodSugar(
          id: 0,
          testDate: _testDateController.text,
          fbsLevel: double.parse(_fbsController.text),
          imageUrl: _imageUrlController.text.isEmpty
              ? null
              : _imageUrlController.text,
        );

        final success = await healthProvider.addFBSRecord(
          record,
          authProvider.currentUser!.id,
        );

        if (mounted) {
          if (success) {
            CustomSnackbar.show(
              context,
              message: 'FBS record added successfully!',
              type: SnackbarType.success,
            );

            _fbsController.clear();
            _imageUrlController.clear();
            _testDateController.text = DateFormat(
              'yyyy-MM-dd',
            ).format(DateTime.now());
          } else {
            CustomSnackbar.show(
              context,
              message: healthProvider.errorMessage ?? 'Error adding record',
              type: SnackbarType.error,
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
                            color: AppColors.bloodSugar.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Icon(
                            Icons.bloodtype_rounded,
                            color: AppColors.bloodSugar,
                            size: AppSpacing.iconMd,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Text(
                          'Add Fasting Blood Sugar',
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
                      controller: _fbsController,
                      label: 'Fasting Blood Sugar (mg/dL)',
                      hint: '90',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final val = double.tryParse(value);
                        if (val == null || val < 30 || val > 400)
                          return 'Invalid range (30-400)';
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
                if (healthProvider.fbsRecords.isEmpty) {
                  return const EmptyState(
                    icon: Icons.water_drop_outlined,
                    message: 'No FBS records yet',
                    description: 'Add your first blood sugar record above',
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: healthProvider.fbsRecords.length,
                  itemBuilder: (context, index) {
                    final record = healthProvider
                        .fbsRecords[healthProvider.fbsRecords.length - 1 - index];
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

  Widget _buildRecordCard(FastingBloodSugar record, bool isDark) {
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
            color: _getFBSColor(record.fbsLevel).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.water_drop_rounded,
            color: _getFBSColor(record.fbsLevel),
            size: AppSpacing.iconMd,
          ),
        ),
        title: Text(
          '${record.fbsLevel.toStringAsFixed(1)} mg/dL',
          style: AppTypography.titleSmall.copyWith(
            color:
                isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy').format(DateTime.parse(record.testDate)),
          style: AppTypography.bodySmall.copyWith(
            color:
                isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: _getFBSColor(record.fbsLevel).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Text(
            _getFBSStatus(record.fbsLevel),
            style: AppTypography.labelSmall.copyWith(
              color: _getFBSColor(record.fbsLevel),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              child: Text(
                                _testDateController.text,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _fbsController,
                            decoration: InputDecoration(
                              labelText: 'Fasting Blood Sugar (mg/dL)',
                              hintText: '90',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: const TextStyle(fontSize: 14),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Required';
                              final val = double.tryParse(value);
                              if (val == null || val < 30 || val > 400)
                                return 'Invalid range';
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _imageUrlController,
                            decoration: InputDecoration(
                              labelText: 'Report Image (Optional)',
                              hintText: 'URL or file path',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: _addRecord,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Add Record',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Consumer<HealthRecordsProvider>(
                  builder: (context, healthProvider, child) {
                    if (healthProvider.fbsRecords.isEmpty) {
                      return Card(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.water_drop,
                                size: 48,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'No records yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: healthProvider.fbsRecords.length,
                      itemBuilder: (context, index) {
                        final record =
                            healthProvider.fbsRecords[healthProvider
                                    .fbsRecords
                                    .length -
                                1 -
                                index];
                        return _buildCompactRecordCard(record);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard(FastingBloodSugar record, bool isDark) {
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
            color: _getFBSColor(record.fbsLevel).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.water_drop_rounded,
            color: _getFBSColor(record.fbsLevel),
            size: AppSpacing.iconMd,
          ),
        ),
        title: Text(
          '${record.fbsLevel.toStringAsFixed(1)} mg/dL',
          style: AppTypography.titleSmall.copyWith(
            color:
                isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy').format(DateTime.parse(record.testDate)),
          style: AppTypography.bodySmall.copyWith(
            color:
                isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: _getFBSColor(record.fbsLevel).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Text(
            _getFBSStatus(record.fbsLevel),
            style: AppTypography.labelSmall.copyWith(
              color: _getFBSColor(record.fbsLevel),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getFBSColor(double fbs) {
    if (fbs < 100) return AppColors.success;
    if (fbs < 126) return AppColors.warning;
    return AppColors.error;
  }

  String _getFBSStatus(double fbs) {
    if (fbs < 100) return 'Normal';
    if (fbs < 126) return 'Pre-diabetic';
    return 'Diabetic';
  }
}
