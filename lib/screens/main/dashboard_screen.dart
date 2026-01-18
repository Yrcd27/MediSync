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
import '../../widgets/alerts/health_alert_banner.dart';
import '../../widgets/cards/analysis_detail_card.dart';
import '../../models/blood_pressure.dart';
import '../../models/fasting_blood_sugar.dart';
import '../../models/full_blood_count.dart';
import '../../models/lipid_profile.dart';
import '../../models/liver_profile.dart';
import '../../models/urine_report.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../utils/health_analysis.dart' as health;
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

                  // Health summary cards - showing all 6 test types
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
                        icon: Icons.favorite_rounded,
                        color: AppColors.bloodPressure,
                      ),
                      HealthMetricCard(
                        title: 'Blood Sugar',
                        value: healthProvider.fbsRecords.isNotEmpty
                            ? healthProvider.fbsRecords.last.fbsLevel
                                  .toStringAsFixed(0)
                            : '--',
                        unit: healthProvider.fbsRecords.isNotEmpty
                            ? 'mg/dL'
                            : '',
                        icon: Icons.water_drop_rounded,
                        color: AppColors.bloodSugar,
                      ),
                      HealthMetricCard(
                        title: 'Blood Count',
                        value: healthProvider.fbcRecords.isNotEmpty
                            ? healthProvider.fbcRecords.last.haemoglobin
                                  .toStringAsFixed(1)
                            : '--',
                        unit: healthProvider.fbcRecords.isNotEmpty
                            ? 'g/dL'
                            : '',
                        icon: Icons.science_rounded,
                        color: AppColors.bloodCount,
                      ),
                      HealthMetricCard(
                        title: 'Lipid Profile',
                        value: healthProvider.lipidRecords.isNotEmpty
                            ? healthProvider.lipidRecords.last.totalCholesterol
                                  .toStringAsFixed(0)
                            : '--',
                        unit: healthProvider.lipidRecords.isNotEmpty
                            ? 'mg/dL'
                            : '',
                        icon: Icons.favorite_rounded,
                        color: AppColors.lipidProfile,
                      ),
                      HealthMetricCard(
                        title: 'Liver Profile',
                        value: healthProvider.liverRecords.isNotEmpty
                            ? healthProvider.liverRecords.last.sgpt
                                  .toStringAsFixed(0)
                            : '--',
                        unit: healthProvider.liverRecords.isNotEmpty
                            ? 'U/L'
                            : '',
                        icon: Icons.local_hospital_rounded,
                        color: AppColors.liverProfile,
                      ),
                      HealthMetricCard(
                        title: 'Urine Report',
                        value: healthProvider.urineRecords.isNotEmpty
                            ? healthProvider.urineRecords.last.specificGravity
                                  .toStringAsFixed(3)
                            : '--',
                        unit: healthProvider.urineRecords.isNotEmpty
                            ? 'SG'
                            : '',
                        icon: Icons.opacity_rounded,
                        color: AppColors.urineReport,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Health Alerts Section
                  ..._buildHealthAlerts(healthProvider, user),

                  // Health Insights Section
                  const SectionHeader(title: 'Health Insights'),
                  const SizedBox(height: AppSpacing.md),
                  _buildHealthInsights(healthProvider, user),
                  const SizedBox(height: AppSpacing.xl),

                  // Recent Reports Section
                  const SectionHeader(title: 'Recent Reports'),
                  const SizedBox(height: AppSpacing.md),

                  if (healthProvider.dailyReports.isEmpty)
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
                    ...healthProvider.dailyReports.take(3).map((report) {
                      final testCount = (report['tests'] as List).length;
                      final date = report['date'] as String;
                      final parsedDate =
                          DateTime.tryParse(date) ?? DateTime.now();
                      final formattedDate = DateFormat(
                        'MMM d, yyyy',
                      ).format(parsedDate);

                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              '$testCount',
                              style: AppTypography.body1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          title: Text(
                            'Report - $formattedDate',
                            style: AppTypography.body1.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            '$testCount test(s) recorded',
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

  void _showReportDetails(BuildContext context, Map<String, dynamic> report) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final date = report['date'] as String;
    final tests = report['tests'] as List;
    final parsedDate = DateTime.tryParse(date) ?? DateTime.now();
    final formattedDate = DateFormat('MMMM d, yyyy').format(parsedDate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXl),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Report Details',
                            style: AppTypography.title1.copyWith(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
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
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      formattedDate,
                      style: AppTypography.body1.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${tests.length} test(s) recorded',
                      style: AppTypography.body2.copyWith(
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
              // Test results
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: tests.length,
                  itemBuilder: (context, index) {
                    final test = tests[index] as Map<String, dynamic>;
                    final testType = test['type'] as String;
                    final data = test['data'];

                    // Get analysis based on test type
                    health.HealthResult? analysis;
                    String metricName = '';
                    String value = '';
                    String unit = '';

                    if (testType == 'Blood Pressure' && data is BloodPressure) {
                      analysis = health.HealthAnalysis.analyzeBloodPressure(
                        data,
                      );
                      metricName = 'Blood Pressure';
                      value = '${data.systolic}/${data.diastolic}';
                      unit = 'mmHg';
                    } else if (testType == 'Blood Sugar' &&
                        data is FastingBloodSugar) {
                      analysis = health.HealthAnalysis.analyzeFBS(
                        data.fbsLevel,
                      );
                      metricName = 'Fasting Blood Sugar';
                      value = data.fbsLevel.toStringAsFixed(0);
                      unit = 'mg/dL';
                    } else if (testType == 'Blood Count' &&
                        data is FullBloodCount) {
                      // Get user data for gender
                      final authProvider = context.read<AuthProvider>();
                      final user = authProvider.currentUser;
                      final gender = user?.gender ?? 'Male';

                      analysis = health.HealthAnalysis.analyzeHaemoglobin(
                        data.haemoglobin,
                        gender,
                      );
                      metricName = 'Haemoglobin';
                      value = data.haemoglobin.toStringAsFixed(1);
                      unit = 'g/dL';
                    } else if (testType == 'Lipid Profile' &&
                        data is LipidProfile) {
                      analysis = health.HealthAnalysis.analyzeTotalCholesterol(
                        data.totalCholesterol,
                      );
                      metricName = 'Total Cholesterol';
                      value = data.totalCholesterol.toStringAsFixed(0);
                      unit = 'mg/dL';
                    } else if (testType == 'Liver Profile' &&
                        data is LiverProfile) {
                      analysis = health.HealthAnalysis.analyzeSGPT(data.sgpt);
                      metricName = 'SGPT';
                      value = data.sgpt.toStringAsFixed(0);
                      unit = 'U/L';
                    } else if (testType == 'Urine Report' &&
                        data is UrineReport) {
                      analysis = health.HealthAnalysis.analyzeSpecificGravity(
                        data.specificGravity,
                      );
                      metricName = 'Specific Gravity';
                      value = data.specificGravity.toStringAsFixed(3);
                      unit = '';
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: AppSpacing.borderRadiusMd,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.2),
                                  borderRadius: AppSpacing.borderRadiusSm,
                                ),
                                child: Icon(
                                  test['icon'] as IconData,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      test['type'] as String,
                                      style: AppTypography.label1.copyWith(
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      test['value'] as String,
                                      style: AppTypography.body2.copyWith(
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Add analysis card if available
                        if (analysis != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: AnalysisDetailCard(
                              analysis: analysis,
                              metricName: metricName,
                              value: value,
                              unit: unit,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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

  Color _getStatusColor(health.HealthStatus status) {
    switch (status) {
      case health.HealthStatus.normal:
        return Colors.green;
      case health.HealthStatus.low:
        return Colors.blue;
      case health.HealthStatus.high:
        return Colors.orange;
      case health.HealthStatus.abnormal:
        return Colors.red;
    }
  }

  List<Widget> _buildHealthAlerts(
    HealthRecordsProvider provider,
    dynamic user,
  ) {
    final alerts = <Widget>[];

    // Check for critical/abnormal values
    if (provider.bpRecords.isNotEmpty) {
      final analysis = health.HealthAnalysis.analyzeBloodPressure(
        provider.bpRecords.last,
      );
      if (analysis.status == health.HealthStatus.abnormal) {
        alerts.add(
          HealthAlertBanner(
            title: 'Critical Blood Pressure',
            message:
                '${provider.bpRecords.last.bpLevel} mmHg - ${analysis.recommendation}',
            color: Colors.red,
            icon: Icons.favorite_rounded,
          ),
        );
      }
    }

    if (provider.fbsRecords.isNotEmpty) {
      final analysis = health.HealthAnalysis.analyzeFBS(
        provider.fbsRecords.last.fbsLevel,
      );
      if (analysis.status == health.HealthStatus.abnormal ||
          analysis.status == health.HealthStatus.high) {
        alerts.add(
          HealthAlertBanner(
            title: 'Blood Sugar Alert',
            message:
                '${provider.fbsRecords.last.fbsLevel.toStringAsFixed(0)} mg/dL - ${analysis.recommendation}',
            color: analysis.status == health.HealthStatus.abnormal
                ? Colors.red
                : Colors.orange,
            icon: Icons.water_drop_rounded,
          ),
        );
      }
    }

    if (provider.fbcRecords.isNotEmpty) {
      final analysis = health.HealthAnalysis.analyzeHaemoglobin(
        provider.fbcRecords.last.haemoglobin,
        user.gender,
      );
      if (analysis.status == health.HealthStatus.abnormal ||
          analysis.status == health.HealthStatus.low) {
        alerts.add(
          HealthAlertBanner(
            title: 'Blood Count Alert',
            message:
                'Hemoglobin ${provider.fbcRecords.last.haemoglobin.toStringAsFixed(1)} g/dL - ${analysis.recommendation}',
            color: analysis.status == health.HealthStatus.abnormal
                ? Colors.red
                : Colors.blue,
            icon: Icons.science_rounded,
          ),
        );
      }
    }

    if (provider.lipidRecords.isNotEmpty) {
      final analysis = health.HealthAnalysis.analyzeTotalCholesterol(
        provider.lipidRecords.last.totalCholesterol,
      );
      if (analysis.status == health.HealthStatus.high ||
          analysis.status == health.HealthStatus.abnormal) {
        alerts.add(
          HealthAlertBanner(
            title: 'Cholesterol Alert',
            message:
                '${provider.lipidRecords.last.totalCholesterol.toStringAsFixed(0)} mg/dL - ${analysis.recommendation}',
            color: analysis.status == health.HealthStatus.abnormal
                ? Colors.red
                : Colors.orange,
            icon: Icons.favorite_rounded,
          ),
        );
      }
    }

    if (provider.liverRecords.isNotEmpty) {
      final analysis = health.HealthAnalysis.analyzeSGPT(
        provider.liverRecords.last.sgpt,
      );
      if (analysis.status == health.HealthStatus.high ||
          analysis.status == health.HealthStatus.abnormal) {
        alerts.add(
          HealthAlertBanner(
            title: 'Liver Function Alert',
            message:
                'SGPT ${provider.liverRecords.last.sgpt.toStringAsFixed(0)} U/L - ${analysis.recommendation}',
            color: analysis.status == health.HealthStatus.abnormal
                ? Colors.red
                : Colors.orange,
            icon: Icons.local_hospital_rounded,
          ),
        );
      }
    }

    if (alerts.isNotEmpty) {
      return [
        const SectionHeader(title: 'Health Alerts'),
        const SizedBox(height: AppSpacing.md),
        ...alerts,
        const SizedBox(height: AppSpacing.xl),
      ];
    }
    return [];
  }

  Widget _buildHealthInsights(HealthRecordsProvider provider, dynamic user) {
    final insights = <Map<String, dynamic>>[];

    // Analyze each metric
    if (provider.bpRecords.isNotEmpty) {
      final analysis = health.HealthAnalysis.analyzeBloodPressure(
        provider.bpRecords.last,
      );
      if (analysis.status != health.HealthStatus.normal) {
        insights.add({
          'title': 'Blood Pressure',
          'status': analysis.statusText,
          'recommendation': analysis.recommendation,
          'color': _getStatusColor(analysis.status),
        });
      }
    }

    if (provider.fbsRecords.isNotEmpty) {
      final analysis = health.HealthAnalysis.analyzeFBS(
        provider.fbsRecords.last.fbsLevel,
      );
      if (analysis.status != health.HealthStatus.normal) {
        insights.add({
          'title': 'Blood Sugar',
          'status': analysis.statusText,
          'recommendation': analysis.recommendation,
          'color': _getStatusColor(analysis.status),
        });
      }
    }

    if (provider.fbcRecords.isNotEmpty) {
      final analysis = health.HealthAnalysis.analyzeHaemoglobin(
        provider.fbcRecords.last.haemoglobin,
        user.gender,
      );
      if (analysis.status != health.HealthStatus.normal) {
        insights.add({
          'title': 'Haemoglobin',
          'status': analysis.statusText,
          'recommendation': analysis.recommendation,
          'color': _getStatusColor(analysis.status),
        });
      }
    }

    if (provider.lipidRecords.isNotEmpty) {
      final analysis = health.HealthAnalysis.analyzeTotalCholesterol(
        provider.lipidRecords.last.totalCholesterol,
      );
      if (analysis.status != health.HealthStatus.normal) {
        insights.add({
          'title': 'Cholesterol',
          'status': analysis.statusText,
          'recommendation': analysis.recommendation,
          'color': _getStatusColor(analysis.status),
        });
      }
    }

    if (provider.liverRecords.isNotEmpty) {
      final analysis = health.HealthAnalysis.analyzeSGPT(
        provider.liverRecords.last.sgpt,
      );
      if (analysis.status != health.HealthStatus.normal) {
        insights.add({
          'title': 'Liver Function',
          'status': analysis.statusText,
          'recommendation': analysis.recommendation,
          'color': _getStatusColor(analysis.status),
        });
      }
    }

    if (provider.urineRecords.isNotEmpty) {
      final analysis = health.HealthAnalysis.analyzeSpecificGravity(
        provider.urineRecords.last.specificGravity,
      );
      if (analysis.status != health.HealthStatus.normal) {
        insights.add({
          'title': 'Urine Test',
          'status': analysis.statusText,
          'recommendation': analysis.recommendation,
          'color': _getStatusColor(analysis.status),
        });
      }
    }

    if (insights.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 32),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'All metrics are within normal range',
                  style: AppTypography.body1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_rounded,
                  color: Colors.orange,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${insights.length} ${insights.length == 1 ? 'area' : 'areas'} need attention',
                  style: AppTypography.body1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...insights.map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: insight['color'],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${insight['title']}: ${insight['status']}',
                            style: AppTypography.body2.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            insight['recommendation'],
                            style: AppTypography.caption.copyWith(
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
          ],
        ),
      ),
    );
  }
}
