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
import '../../models/urine_report.dart';

class UrineReportRecordsScreen extends StatefulWidget {
  const UrineReportRecordsScreen({super.key});

  @override
  State<UrineReportRecordsScreen> createState() =>
      _UrineReportRecordsScreenState();
}

class _UrineReportRecordsScreenState extends State<UrineReportRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testDateController = TextEditingController();
  final _specificGravityController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _selectedColor = 'Yellow';
  String _selectedAppearance = 'Clear';
  String _selectedProtein = 'Negative';
  String _selectedSugar = 'Negative';

  bool _isSubmitting = false;

  final List<String> _colorOptions = [
    'Pale Yellow',
    'Yellow',
    'Dark Yellow',
    'Amber',
    'Red',
    'Brown',
    'Clear',
  ];

  final List<String> _appearanceOptions = ['Clear', 'Cloudy', 'Turbid', 'Hazy'];

  final List<String> _proteinOptions = [
    'Negative',
    'Trace',
    '1+',
    '2+',
    '3+',
    '4+',
  ];

  final List<String> _sugarOptions = [
    'Negative',
    'Trace',
    '1+',
    '2+',
    '3+',
    '4+',
  ];

  @override
  void initState() {
    super.initState();
    _testDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _testDateController.dispose();
    _specificGravityController.dispose();
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

        final record = UrineReport(
          id: 0,
          testDate: _testDateController.text,
          color: _selectedColor,
          appearance: _selectedAppearance,
          protein: _selectedProtein,
          sugar: _selectedSugar,
          specificGravity: _specificGravityController.text.isNotEmpty
              ? double.parse(_specificGravityController.text)
              : 1.020, // Default value if not provided
          imageUrl: _imageUrlController.text.isEmpty
              ? null
              : _imageUrlController.text,
        );

        final success = await healthProvider.addUrineRecord(
          record,
          authProvider.currentUser!.id,
        );

        if (mounted) {
          if (success) {
            CustomSnackBar.show(
              context,
              message: 'Urine report record added successfully!',
              type: SnackBarType.success,
            );

            _selectedColor = 'Yellow';
            _selectedAppearance = 'Clear';
            _selectedProtein = 'Negative';
            _selectedSugar = 'Negative';
            _specificGravityController.clear();
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
                            color: AppColors.urineReport.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Icon(
                            Icons.opacity_rounded,
                            color: AppColors.urineReport,
                            size: AppSpacing.iconMd,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Text(
                          'Add Urine Report',
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

                    _buildStyledDropdown(
                      label: 'Color',
                      value: _selectedColor,
                      options: _colorOptions,
                      isDark: isDark,
                      onChanged: (value) {
                        setState(() {
                          _selectedColor = value ?? 'Yellow';
                        });
                      },
                    ),
                    SizedBox(height: AppSpacing.md),

                    _buildStyledDropdown(
                      label: 'Appearance',
                      value: _selectedAppearance,
                      options: _appearanceOptions,
                      isDark: isDark,
                      onChanged: (value) {
                        setState(() {
                          _selectedAppearance = value ?? 'Clear';
                        });
                      },
                    ),
                    SizedBox(height: AppSpacing.md),

                    _buildStyledDropdown(
                      label: 'Protein',
                      value: _selectedProtein,
                      options: _proteinOptions,
                      isDark: isDark,
                      onChanged: (value) {
                        setState(() {
                          _selectedProtein = value ?? 'Negative';
                        });
                      },
                    ),
                    SizedBox(height: AppSpacing.md),

                    _buildStyledDropdown(
                      label: 'Sugar',
                      value: _selectedSugar,
                      options: _sugarOptions,
                      isDark: isDark,
                      onChanged: (value) {
                        setState(() {
                          _selectedSugar = value ?? 'Negative';
                        });
                      },
                    ),
                    SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _specificGravityController,
                      label: 'Specific Gravity (Optional)',
                      hint: '1.020',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
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
                if (healthProvider.urineRecords.isEmpty) {
                  return const EmptyState(
                    icon: Icons.opacity_outlined,
                    message: 'No urine report records yet',
                    description: 'Add your first urine report record above',
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: healthProvider.urineRecords.length,
                  itemBuilder: (context, index) {
                    final record = healthProvider
                        .urineRecords[healthProvider.urineRecords.length - 1 - index];
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

  Widget _buildStyledDropdown({
    required String label,
    required String value,
    required List<String> options,
    required bool isDark,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
      value: value,
      dropdownColor: isDark ? AppColors.darkSurface : AppColors.surface,
      style: AppTypography.bodyMedium.copyWith(
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      ),
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildRecordCard(UrineReport record, bool isDark) {
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
            color: _getUrineColor(record.color).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.opacity_rounded,
            color: _getUrineColor(record.color),
            size: AppSpacing.iconMd,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Color: ${record.color}',
                style: AppTypography.titleSmall.copyWith(
                  color:
                      isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
            if (record.protein != 'Negative' || record.sugar != 'Negative')
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Text(
                  'Abnormal',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.xs),
            Text(
              DateFormat('MMM dd, yyyy').format(DateTime.parse(record.testDate)),
              style: AppTypography.bodySmall.copyWith(
                color:
                    isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Protein: ${record.protein}, Sugar: ${record.sugar}',
              style: AppTypography.labelSmall.copyWith(
                color:
                    isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getUrineColor(String color) {
    switch (color.toLowerCase()) {
      case 'pale yellow':
      case 'yellow':
        return Colors.yellow[700]!;
      case 'dark yellow':
      case 'amber':
        return Colors.amber[800]!;
      case 'red':
        return Colors.red;
      case 'brown':
        return Colors.brown;
      case 'clear':
        return Colors.blue[200]!;
      default:
        return Colors.amber[700]!;
    }
  }
}
