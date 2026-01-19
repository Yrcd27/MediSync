import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../providers/health_records_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/feedback/empty_state.dart';
import '../records/view/view_blood_pressure_screen.dart';
import '../records/view/view_blood_sugar_screen.dart';
import '../records/view/view_blood_count_screen.dart';
import '../records/view/view_lipid_profile_screen.dart';
import '../records/view/view_liver_profile_screen.dart';
import '../records/view/view_urine_report_screen.dart';
import '../records/all_records_screen.dart';
import '../../widgets/modals/record_type_selector.dart';

class RecordsHubScreen extends StatelessWidget {
  const RecordsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          'Health Records',
          style: AppTypography.title1.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        elevation: 0,
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
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add New Record Button
                  _buildAddRecordButton(context, isDark),

                  const SizedBox(height: AppSpacing.xl),

                  // Health Categories Section
                  Text(
                    'Health Categories',
                    style: AppTypography.title2.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Category Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.1,
                    children: [
                      _buildCategoryCard(
                        context,
                        title: 'Blood Pressure',
                        icon: Icons.favorite_rounded,
                        color: AppColors.bloodPressure,
                        count: healthProvider.bpRecords.length,
                        latestValue: healthProvider.bpRecords.isNotEmpty
                            ? healthProvider.bpRecords.first.bpLevel
                            : null,
                        unit: 'mmHg',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ViewBloodPressureScreen(),
                          ),
                        ),
                        isDark: isDark,
                      ),
                      _buildCategoryCard(
                        context,
                        title: 'Blood Sugar',
                        icon: Icons.water_drop_rounded,
                        color: AppColors.bloodSugar,
                        count: healthProvider.fbsRecords.length,
                        latestValue: healthProvider.fbsRecords.isNotEmpty
                            ? healthProvider.fbsRecords.first.fbsLevel
                                  .toStringAsFixed(0)
                            : null,
                        unit: 'mg/dL',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ViewBloodSugarScreen(),
                          ),
                        ),
                        isDark: isDark,
                      ),
                      _buildCategoryCard(
                        context,
                        title: 'Blood Count',
                        icon: Icons.science_rounded,
                        color: AppColors.bloodCount,
                        count: healthProvider.fbcRecords.length,
                        latestValue: healthProvider.fbcRecords.isNotEmpty
                            ? 'Hb ${healthProvider.fbcRecords.first.haemoglobin.toStringAsFixed(1)}'
                            : null,
                        unit: 'g/dL',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ViewBloodCountScreen(),
                          ),
                        ),
                        isDark: isDark,
                      ),
                      _buildCategoryCard(
                        context,
                        title: 'Lipid Profile',
                        icon: Icons.monitor_heart_rounded,
                        color: AppColors.lipidProfile,
                        count: healthProvider.lipidRecords.length,
                        latestValue: healthProvider.lipidRecords.isNotEmpty
                            ? 'TC ${healthProvider.lipidRecords.first.totalCholesterol.toStringAsFixed(0)}'
                            : null,
                        unit: 'mg/dL',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ViewLipidProfileScreen(),
                          ),
                        ),
                        isDark: isDark,
                      ),
                      _buildCategoryCard(
                        context,
                        title: 'Liver Profile',
                        icon: Icons.local_hospital_rounded,
                        color: AppColors.liverProfile,
                        count: healthProvider.liverRecords.length,
                        latestValue: healthProvider.liverRecords.isNotEmpty
                            ? 'SGPT ${healthProvider.liverRecords.first.sgpt.toStringAsFixed(0)}'
                            : null,
                        unit: 'U/L',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ViewLiverProfileScreen(),
                          ),
                        ),
                        isDark: isDark,
                      ),
                      _buildCategoryCard(
                        context,
                        title: 'Urine Report',
                        icon: Icons.opacity_rounded,
                        color: AppColors.urineReport,
                        count: healthProvider.urineRecords.length,
                        latestValue: healthProvider.urineRecords.isNotEmpty
                            ? 'SG ${healthProvider.urineRecords.first.specificGravity.toStringAsFixed(3)}'
                            : null,
                        unit: '',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ViewUrineReportScreen(),
                          ),
                        ),
                        isDark: isDark,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Recent Records Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Records',
                        style: AppTypography.title2.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AllRecordsScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'View All',
                          style: AppTypography.label1.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Recent Records List
                  _buildRecentRecordsList(context, healthProvider, isDark),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddRecordButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => _showRecordTypeSelector(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppSpacing.borderRadiusMd,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Record',
                    style: AppTypography.title2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Log your health measurements',
                    style: AppTypography.body2.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required int count,
    required String? latestValue,
    required String unit,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.surfaceVariant,
                    borderRadius: AppSpacing.borderRadiusFull,
                  ),
                  child: Text(
                    '$count',
                    style: AppTypography.label2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: AppTypography.label1.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            if (latestValue != null)
              Text(
                latestValue,
                style: AppTypography.title3.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            else
              Text(
                'No data',
                style: AppTypography.body2.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRecordsList(
    BuildContext context,
    HealthRecordsProvider provider,
    bool isDark,
  ) {
    // Combine all records with their types and sort by date
    final allRecords = <Map<String, dynamic>>[];

    for (final record in provider.bpRecords) {
      allRecords.add({
        'type': 'Blood Pressure',
        'icon': Icons.favorite_rounded,
        'color': AppColors.bloodPressure,
        'value': record.bpLevel,
        'unit': 'mmHg',
        'date': record.testDate,
      });
    }

    for (final record in provider.fbsRecords) {
      allRecords.add({
        'type': 'Blood Sugar',
        'icon': Icons.water_drop_rounded,
        'color': AppColors.bloodSugar,
        'value': record.fbsLevel.toStringAsFixed(0),
        'unit': 'mg/dL',
        'date': record.testDate,
      });
    }

    for (final record in provider.fbcRecords) {
      allRecords.add({
        'type': 'Blood Count',
        'icon': Icons.science_rounded,
        'color': AppColors.bloodCount,
        'value': 'Hb ${record.haemoglobin.toStringAsFixed(1)}',
        'unit': 'g/dL',
        'date': record.testDate,
      });
    }

    for (final record in provider.lipidRecords) {
      allRecords.add({
        'type': 'Lipid Profile',
        'icon': Icons.monitor_heart_rounded,
        'color': AppColors.lipidProfile,
        'value': 'TC ${record.totalCholesterol.toStringAsFixed(0)}',
        'unit': 'mg/dL',
        'date': record.testDate,
      });
    }

    for (final record in provider.liverRecords) {
      allRecords.add({
        'type': 'Liver Profile',
        'icon': Icons.local_hospital_rounded,
        'color': AppColors.liverProfile,
        'value': 'SGPT ${record.sgpt.toStringAsFixed(0)}',
        'unit': 'U/L',
        'date': record.testDate,
      });
    }

    for (final record in provider.urineRecords) {
      allRecords.add({
        'type': 'Urine Report',
        'icon': Icons.opacity_rounded,
        'color': AppColors.urineReport,
        'value': 'SG ${record.specificGravity.toStringAsFixed(3)}',
        'unit': '',
        'date': record.testDate,
      });
    }

    // Sort by date (most recent first)
    allRecords.sort((a, b) => b['date'].compareTo(a['date']));

    // Take only the 5 most recent
    final recentRecords = allRecords.take(5).toList();

    if (recentRecords.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        child: const EmptyState(
          icon: Icons.history_rounded,
          message: 'No Records Yet',
          description: 'Start adding health records to track your progress',
        ),
      );
    }

    return Column(
      children: recentRecords.map((record) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (record['color'] as Color).withOpacity(0.15),
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Icon(
                  record['icon'] as IconData,
                  color: record['color'] as Color,
                  size: 22,
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
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(record['date'] as String),
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              Text(
                '${record['value']} ${record['unit']}',
                style: AppTypography.title3.copyWith(
                  color: record['color'] as Color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) {
        return 'Today';
      } else if (diff.inDays == 1) {
        return 'Yesterday';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} days ago';
      } else {
        return DateFormat('MMM dd, yyyy').format(date);
      }
    } catch (e) {
      return dateStr;
    }
  }

  void _showRecordTypeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RecordTypeSelector(),
    );
  }
}
