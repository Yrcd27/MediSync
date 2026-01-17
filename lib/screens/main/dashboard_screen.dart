import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_records_provider.dart';
import '../../widgets/cards/health_metric_card.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/feedback/loading_indicator.dart';
import '../../widgets/modals/record_type_selector.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../utils/health_analysis.dart';
import 'analytics_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Records are already loaded by main_layout, no need to reload here
    // unless explicitly refreshed by user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              final user = context.read<AuthProvider>().currentUser;
              if (user != null) {
                context.read<HealthRecordsProvider>().loadAllRecords(user.id);
              }
            },
          ),
        ],
      ),
      body: Consumer2<AuthProvider, HealthRecordsProvider>(
        builder: (context, authProvider, healthProvider, child) {
          final user = authProvider.currentUser;

          if (user == null) {
            return Center(
              child: Text('No user data available', style: AppTypography.body1),
            );
          }

          if (healthProvider.isLoading) {
            return const LoadingIndicator(message: 'Loading health records...');
          }

          return RefreshIndicator(
            onRefresh: () async {
              await healthProvider.loadAllRecords(user.id);
            },
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome message
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              user.name.isNotEmpty
                                  ? user.name[0].toUpperCase()
                                  : 'U',
                              style: AppTypography.headline2.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back, ${user.name}!',
                                  style: AppTypography.title2,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Today is ${DateFormat('MMMM d, y').format(DateTime.now())}',
                                  style: AppTypography.body2.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Quick Actions
                  const SectionHeader(title: 'Quick Actions'),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionButton(
                          context,
                          icon: Icons.add_circle,
                          label: 'Add Record',
                          color: AppColors.primary,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const RecordTypeSelector(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildQuickActionButton(
                          context,
                          icon: Icons.analytics,
                          label: 'View Charts',
                          color: AppColors.success,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AnalyticsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Quick Stats
                  const SectionHeader(title: 'Health Summary'),
                  const SizedBox(height: AppSpacing.md),

                  // Health summary cards - using correct model fields
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.1,
                    children: [
                      HealthMetricCard(
                        title: 'Blood Pressure',
                        value: healthProvider.bpRecords.isNotEmpty
                            ? healthProvider.bpRecords.last.bpLevel.split(
                                '/',
                              )[0]
                            : '--',
                        unit: healthProvider.bpRecords.isNotEmpty ? 'mmHg' : '',
                        icon: Icons.favorite,
                        color: healthProvider.bpRecords.isNotEmpty
                            ? HealthAnalysis.analyzeBloodPressure(
                                healthProvider.bpRecords.last,
                              ).color
                            : AppColors.bloodPressure,
                        subtitle: healthProvider.bpRecords.isNotEmpty
                            ? '${healthProvider.bpRecords.length} records'
                            : 'No data',
                      ),
                      HealthMetricCard(
                        title: 'Blood Sugar',
                        value: healthProvider.fbsRecords.isNotEmpty
                            ? healthProvider.fbsRecords.last.fbsLevel
                                  .toStringAsFixed(0)
                            : '--',
                        unit: 'mg/dL',
                        icon: Icons.bloodtype,
                        color: healthProvider.fbsRecords.isNotEmpty
                            ? HealthAnalysis.analyzeFBS(
                                healthProvider.fbsRecords.last.fbsLevel,
                              ).color
                            : AppColors.bloodSugar,
                        subtitle: healthProvider.fbsRecords.isNotEmpty
                            ? '${healthProvider.fbsRecords.length} records'
                            : 'No data',
                      ),
                      HealthMetricCard(
                        title: 'Haemoglobin',
                        value: healthProvider.fbcRecords.isNotEmpty
                            ? healthProvider.fbcRecords.last.haemoglobin
                                  .toStringAsFixed(1)
                            : '--',
                        unit: 'g/dL',
                        icon: Icons.science,
                        color: healthProvider.fbcRecords.isNotEmpty
                            ? HealthAnalysis.analyzeHaemoglobin(
                                healthProvider.fbcRecords.last.haemoglobin,
                                user.gender,
                              ).color
                            : AppColors.bloodCount,
                        subtitle: healthProvider.fbcRecords.isNotEmpty
                            ? '${healthProvider.fbcRecords.length} FBC records'
                            : 'No data',
                      ),
                      HealthMetricCard(
                        title: 'Cholesterol',
                        value: healthProvider.lipidRecords.isNotEmpty
                            ? healthProvider.lipidRecords.last.totalCholesterol
                                  .toStringAsFixed(0)
                            : '--',
                        unit: 'mg/dL',
                        icon: Icons.monitor_heart,
                        color: healthProvider.lipidRecords.isNotEmpty
                            ? HealthAnalysis.analyzeTotalCholesterol(
                                healthProvider
                                    .lipidRecords
                                    .last
                                    .totalCholesterol,
                              ).color
                            : AppColors.lipidProfile,
                        subtitle: healthProvider.lipidRecords.isNotEmpty
                            ? '${healthProvider.lipidRecords.length} records'
                            : 'No data',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Recent Reports Section
                  const SectionHeader(title: 'Recent Reports'),
                  const SizedBox(height: AppSpacing.md),

                  if (healthProvider.reports.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: AppSpacing.iconXl,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'No reports available',
                              style: AppTypography.body1,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Add some health records to see comprehensive reports',
                              style: AppTypography.body2.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...healthProvider.reports.take(3).map((report) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              '${report.testCount}',
                              style: AppTypography.body1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          title: Text(
                            'Report - ${report.reportDate}',
                            style: AppTypography.body1.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            '${report.testCount} test(s) recorded',
                            style: AppTypography.body2.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: AppSpacing.iconSm,
                            color: AppColors.textTertiary,
                          ),
                          onTap: () {
                            _showReportDetails(context, report);
                          },
                        ),
                      );
                    }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showReportDetails(BuildContext context, dynamic report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              const Text(
                'Report Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: ${report.reportDate}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              if (report.bloodPressure != null)
                _buildDetailTile(
                  'Blood Pressure',
                  report.bloodPressure.bpLevel,
                ),
              if (report.fastingBloodSugar != null)
                _buildDetailTile(
                  'FBS',
                  '${report.fastingBloodSugar.fbsLevel.toStringAsFixed(1)} mg/dL',
                ),
              if (report.fullBloodCount != null)
                _buildDetailTile(
                  'Haemoglobin',
                  '${report.fullBloodCount.haemoglobin.toStringAsFixed(1)} g/dL',
                ),
              if (report.lipidProfile != null)
                _buildDetailTile(
                  'Total Cholesterol',
                  '${report.lipidProfile.totalCholesterol.toStringAsFixed(0)} mg/dL',
                ),
              if (report.liverProfile != null)
                _buildDetailTile(
                  'SGPT',
                  '${report.liverProfile.sgpt.toStringAsFixed(1)} U/L',
                ),
              if (report.urineReport != null)
                _buildDetailTile(
                  'Urine SG',
                  '${report.urineReport.specificGravity.toStringAsFixed(3)}',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconMd),
            SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTypography.titleSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
