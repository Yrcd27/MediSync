import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../providers/health_records_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/feedback/empty_state.dart';

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
    // Combine all records with their types and sort by date
    final allRecords = <Map<String, dynamic>>[];

    for (final record in provider.bpRecords) {
      final testDate = DateTime.tryParse(record.testDate) ?? DateTime.now();
      allRecords.add({
        'type': 'Blood Pressure',
        'icon': Icons.favorite_rounded,
        'color': AppColors.bloodPressure,
        'value': record.bpLevel,
        'unit': 'mmHg',
        'date': testDate,
      });
    }

    for (final record in provider.fbsRecords) {
      final testDate = DateTime.tryParse(record.testDate) ?? DateTime.now();
      allRecords.add({
        'type': 'Blood Sugar',
        'icon': Icons.water_drop_rounded,
        'color': AppColors.bloodSugar,
        'value': record.fbsLevel.toStringAsFixed(0),
        'unit': 'mg/dL',
        'date': testDate,
      });
    }

    for (final record in provider.fbcRecords) {
      final testDate = DateTime.tryParse(record.testDate) ?? DateTime.now();
      allRecords.add({
        'type': 'Blood Count',
        'icon': Icons.science_rounded,
        'color': AppColors.bloodCount,
        'value': 'Hb ${record.haemoglobin.toStringAsFixed(1)}',
        'unit': 'g/dL',
        'date': testDate,
      });
    }

    for (final record in provider.lipidRecords) {
      final testDate = DateTime.tryParse(record.testDate) ?? DateTime.now();
      allRecords.add({
        'type': 'Lipid Profile',
        'icon': Icons.monitor_heart_rounded,
        'color': AppColors.lipidProfile,
        'value': 'TC ${record.totalCholesterol.toStringAsFixed(0)}',
        'unit': 'mg/dL',
        'date': testDate,
      });
    }

    for (final record in provider.liverRecords) {
      final testDate = DateTime.tryParse(record.testDate) ?? DateTime.now();
      allRecords.add({
        'type': 'Liver Profile',
        'icon': Icons.local_hospital_rounded,
        'color': AppColors.liverProfile,
        'value': 'SGPT ${record.sgpt.toStringAsFixed(0)}',
        'unit': 'U/L',
        'date': testDate,
      });
    }

    for (final record in provider.urineRecords) {
      final testDate = DateTime.tryParse(record.testDate) ?? DateTime.now();
      allRecords.add({
        'type': 'Urine Report',
        'icon': Icons.opacity_rounded,
        'color': AppColors.urineReport,
        'value': 'SG ${record.specificGravity.toStringAsFixed(3)}',
        'unit': '',
        'date': testDate,
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
        return Container(
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
            ],
          ),
        );
      },
    );
  }
}
