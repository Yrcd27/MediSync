import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../providers/health_records_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../widgets/cards/analysis_detail_card.dart';
import '../../utils/health_analysis.dart' as health;

class AllRecordsScreen extends StatelessWidget {
  const AllRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          'All Records',
          style: AppTypography.title1.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<HealthRecordsProvider>(
        builder: (context, healthProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              final user = context.read<AuthProvider>().currentUser;
              if (user != null) {
                await healthProvider.loadAllRecords(user.id);
              }
            },
            color: AppColors.primary,
            child: _buildAllRecordsList(context, healthProvider, isDark),
          );
        },
      ),
    );
  }

  Widget _buildAllRecordsList(
    BuildContext context,
    HealthRecordsProvider provider,
    bool isDark,
  ) {
    final user = context.read<AuthProvider>().currentUser;
    // Combine all records with their types and sort by date
    final allRecords = <Map<String, dynamic>>[];

    for (final record in provider.bpRecords) {
      final testDate = DateTime.tryParse(record.testDate) ?? DateTime.now();
      final analysis = health.HealthAnalysis.analyzeBloodPressure(record);
      allRecords.add({
        'type': 'Blood Pressure',
        'icon': Icons.favorite_rounded,
        'color': AppColors.bloodPressure,
        'value': record.bpLevel,
        'unit': 'mmHg',
        'date': testDate,
        'status': _getStatusIcon(analysis.status),
        'statusText': analysis.statusText,
        'analysis': analysis,
        'metricName': 'Blood Pressure',
        'rawValue': '${record.systolic}/${record.diastolic}',
        'rawUnit': 'mmHg',
      });
    }

    for (final record in provider.fbsRecords) {
      final testDate = DateTime.tryParse(record.testDate) ?? DateTime.now();
      final analysis = health.HealthAnalysis.analyzeFBS(record.fbsLevel);
      allRecords.add({
        'type': 'Blood Sugar',
        'icon': Icons.water_drop_rounded,
        'color': AppColors.bloodSugar,
        'value': record.fbsLevel.toStringAsFixed(0),
        'unit': 'mg/dL',
        'date': testDate,
        'status': _getStatusIcon(analysis.status),
        'statusText': analysis.statusText,
        'analysis': analysis,
        'metricName': 'Fasting Blood Sugar',
        'rawValue': record.fbsLevel.toStringAsFixed(0),
        'rawUnit': 'mg/dL',
      });
    }

    for (final record in provider.fbcRecords) {
      final testDate = DateTime.tryParse(record.testDate) ?? DateTime.now();
      final analysis = health.HealthAnalysis.analyzeHaemoglobin(
        record.haemoglobin,
        user?.gender ?? 'Male',
      );
      allRecords.add({
        'type': 'Blood Count',
        'icon': Icons.science_rounded,
        'color': AppColors.bloodCount,
        'value': 'Hb ${record.haemoglobin.toStringAsFixed(1)}',
        'unit': 'g/dL',
        'date': testDate,
        'status': _getStatusIcon(analysis.status),
        'statusText': analysis.statusText,
        'analysis': analysis,
        'metricName': 'Haemoglobin',
        'rawValue': record.haemoglobin.toStringAsFixed(1),
        'rawUnit': 'g/dL',
      });
    }

    for (final record in provider.lipidRecords) {
      final testDate = DateTime.tryParse(record.testDate) ?? DateTime.now();
      final analysis = health.HealthAnalysis.analyzeTotalCholesterol(
        record.totalCholesterol,
      );
      allRecords.add({
        'type': 'Lipid Profile',
        'icon': Icons.monitor_heart_rounded,
        'color': AppColors.lipidProfile,
        'value': 'TC ${record.totalCholesterol.toStringAsFixed(0)}',
        'unit': 'mg/dL',
        'date': testDate,
        'status': _getStatusIcon(analysis.status),
        'statusText': analysis.statusText,
        'analysis': analysis,
        'metricName': 'Total Cholesterol',
        'rawValue': record.totalCholesterol.toStringAsFixed(0),
        'rawUnit': 'mg/dL',
      });
    }

    for (final record in provider.liverRecords) {
      final testDate = DateTime.tryParse(record.testDate) ?? DateTime.now();
      final analysis = health.HealthAnalysis.analyzeSGPT(record.sgpt);
      allRecords.add({
        'type': 'Liver Profile',
        'icon': Icons.local_hospital_rounded,
        'color': AppColors.liverProfile,
        'value': 'SGPT ${record.sgpt.toStringAsFixed(0)}',
        'unit': 'U/L',
        'date': testDate,
        'status': _getStatusIcon(analysis.status),
        'statusText': analysis.statusText,
        'analysis': analysis,
        'metricName': 'SGPT',
        'rawValue': record.sgpt.toStringAsFixed(0),
        'rawUnit': 'U/L',
      });
    }

    for (final record in provider.urineRecords) {
      final testDate = DateTime.tryParse(record.testDate) ?? DateTime.now();
      final analysis = health.HealthAnalysis.analyzeSpecificGravity(
        record.specificGravity,
      );
      allRecords.add({
        'type': 'Urine Report',
        'icon': Icons.opacity_rounded,
        'color': AppColors.urineReport,
        'value': 'SG ${record.specificGravity.toStringAsFixed(3)}',
        'unit': '',
        'date': testDate,
        'status': _getStatusIcon(analysis.status),
        'statusText': analysis.statusText,
        'analysis': analysis,
        'metricName': 'Specific Gravity',
        'rawValue': record.specificGravity.toStringAsFixed(3),
        'rawUnit': '',
      });
    }

    // Sort by date (most recent first)
    allRecords.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );

    if (allRecords.isEmpty) {
      return Center(
        child: EmptyState(
          icon: Icons.history_rounded,
          message: 'No Records Yet',
          description: 'Start adding health records to track your progress',
        ),
      );
    }

    return ListView.builder(
      padding: AppSpacing.screenPadding,
      itemCount: allRecords.length,
      itemBuilder: (context, index) {
        final record = allRecords[index];
        return InkWell(
          onTap: () => _showHealthInsights(context, record),
          borderRadius: AppSpacing.borderRadiusMd,
          child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: AppSpacing.borderRadiusMd,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (record['color'] as Color).withOpacity(0.15),
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                  child: Icon(
                    record['icon'] as IconData,
                    color: record['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record['type'] as String,
                        style: AppTypography.label1.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        DateFormat(
                          'MMM d, yyyy',
                        ).format(record['date'] as DateTime),
                        style: AppTypography.caption.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      record['value'] as String,
                      style: AppTypography.title3.copyWith(
                        color: record['color'] as Color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if ((record['unit'] as String).isNotEmpty)
                      Text(
                        record['unit'] as String,
                        style: AppTypography.caption.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getStatusIcon(health.HealthStatus status) {
    switch (status) {
      case health.HealthStatus.normal:
        return '✅';
      case health.HealthStatus.low:
        return '🔵';
      case health.HealthStatus.high:
        return '⚠️';
      case health.HealthStatus.abnormal:
        return '🚨';
    }
  }

  void _showHealthInsights(BuildContext context, Map<String, dynamic> record) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final analysis = record['analysis'] as health.HealthResult;
    final metricName = record['metricName'] as String;
    final value = record['rawValue'] as String;
    final unit = record['rawUnit'] as String;
    final testType = record['type'] as String;
    final testDate = DateFormat(
      'MMMM d, yyyy',
    ).format(record['date'] as DateTime);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusLg,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (record['color'] as Color).withOpacity(0.15),
                          borderRadius: AppSpacing.borderRadiusSm,
                        ),
                        child: Icon(
                          record['icon'] as IconData,
                          color: record['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              testType,
                              style: AppTypography.title2.copyWith(
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              testDate,
                              style: AppTypography.body2.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close_rounded,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  height: 1,
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        // Value display
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: (record['color'] as Color).withOpacity(0.1),
                            borderRadius: AppSpacing.borderRadiusMd,
                            border: Border.all(
                              color: (record['color'] as Color).withOpacity(
                                0.3,
                              ),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                value,
                                style: AppTypography.headline1.copyWith(
                                  color: record['color'] as Color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (unit.isNotEmpty) ...[
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  unit,
                                  style: AppTypography.title3.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // Health insights
                        AnalysisDetailCard(
                          analysis: analysis,
                          metricName: metricName,
                          value: value,
                          unit: unit,
                        ),
                      ],
                    ),
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppSpacing.borderRadiusMd,
                        ),
                      ),
                      child: Text(
                        'Got it',
                        style: AppTypography.label1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
