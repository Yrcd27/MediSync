import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/health_records_provider.dart';
import '../../../models/urine_report.dart';
import '../../../widgets/buttons/primary_button.dart';

class AddUrineReportScreen extends StatefulWidget {
  const AddUrineReportScreen({super.key});

  @override
  State<AddUrineReportScreen> createState() => _AddUrineReportScreenState();
}

class _AddUrineReportScreenState extends State<AddUrineReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sgController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedColor = 'Pale Yellow';
  String _selectedAppearance = 'Clear';
  String _selectedProtein = 'Negative';
  String _selectedSugar = 'Negative';
  bool _isSubmitting = false;

  final List<String> _colorOptions = [
    'Pale Yellow',
    'Yellow',
    'Dark Yellow',
    'Amber',
    'Red/Pink',
  ];
  final List<String> _appearanceOptions = [
    'Clear',
    'Slightly Cloudy',
    'Cloudy',
    'Turbid',
  ];
  final List<String> _proteinSugarOptions = [
    'Negative',
    'Trace',
    '+',
    '++',
    '+++',
  ];

  @override
  void dispose() {
    _sgController.dispose();
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
              primary: AppColors.urineReport,
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

      final record = UrineReport(
        id: 0,
        testDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        color: _selectedColor,
        appearance: _selectedAppearance,
        protein: _selectedProtein,
        sugar: _selectedSugar,
        specificGravity: double.parse(_sgController.text),
        imageUrl: null,
      );

      final success = await healthProvider.addUrineRecord(record, user.id);

      if (mounted) {
        if (success) {
          _showSuccess('Urine report added!');
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
        title: Text('Add Urine Report', style: AppTypography.title1),
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
                    color: AppColors.urineReport.withOpacity(0.15),
                    borderRadius: AppSpacing.borderRadiusLg,
                  ),
                  child: Icon(
                    Icons.opacity_rounded,
                    size: 40,
                    color: AppColors.urineReport,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              _buildDatePicker(isDark),
              const SizedBox(height: AppSpacing.xl),

              // Specific Gravity
              Text('Specific Gravity', style: AppTypography.label1),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _sgController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  final val = double.tryParse(v);
                  if (val == null || val < 1.000 || val > 1.040) {
                    return 'Enter 1.000-1.040';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: '1.015',
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
                      color: AppColors.urineReport,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Color Dropdown
              _buildDropdown(
                'Color',
                _selectedColor,
                _colorOptions,
                (v) => setState(() => _selectedColor = v!),
                isDark,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Appearance Dropdown
              _buildDropdown(
                'Appearance',
                _selectedAppearance,
                _appearanceOptions,
                (v) => setState(() => _selectedAppearance = v!),
                isDark,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Protein & Sugar in row
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      'Protein',
                      _selectedProtein,
                      _proteinSugarOptions,
                      (v) => setState(() => _selectedProtein = v!),
                      isDark,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildDropdown(
                      'Sugar',
                      _selectedSugar,
                      _proteinSugarOptions,
                      (v) => setState(() => _selectedSugar = v!),
                      isDark,
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
                          'Normal Values',
                          style: AppTypography.label2.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Specific Gravity: 1.005-1.030',
                      style: AppTypography.caption,
                    ),
                    Text(
                      'Color: Pale Yellow to Yellow',
                      style: AppTypography.caption,
                    ),
                    Text(
                      'Protein & Sugar: Negative',
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
                  color: AppColors.urineReport,
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

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options,
    void Function(String?) onChanged,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.label1),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceVariant
                : AppColors.surfaceVariant,
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: options
                  .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                  .toList(),
              onChanged: onChanged,
              style: AppTypography.body1.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
              dropdownColor: isDark ? AppColors.darkSurface : AppColors.surface,
            ),
          ),
        ),
      ],
    );
  }
}
