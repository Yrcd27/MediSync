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
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../utils/health_analysis.dart' as health;
import '../../models/blood_pressure.dart';
import '../../models/fasting_blood_sugar.dart';
import '../../models/full_blood_count.dart';
import '../../models/lipid_profile.dart';
import '../../models/liver_profile.dart';
import '../../models/urine_report.dart';
import '../../models/user.dart';
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
      appBar: CustomAppBar(title: 'Dashboard'),
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
                            ? healthProvider.bpRecords.first.bpLevel.split(
                                '/',
                              )[0]
                            : '--',
                        unit: healthProvider.bpRecords.isNotEmpty ? 'mmHg' : '',
                        icon: Icons.favorite_rounded,
                        color: AppColors.bloodPressure,
                        onTap: healthProvider.bpRecords.isNotEmpty
                            ? () => _showHealthAnalysisModal(
                                context,
                                'Blood Pressure Analysis',
                                healthProvider.bpRecords.first,
                                'bp',
                                user,
                              )
                            : null,
                      ),
                      HealthMetricCard(
                        title: 'Blood Sugar',
                        value: healthProvider.fbsRecords.isNotEmpty
                            ? healthProvider.fbsRecords.first.fbsLevel
                                  .toStringAsFixed(0)
                            : '--',
                        unit: healthProvider.fbsRecords.isNotEmpty
                            ? 'mg/dL'
                            : '',
                        icon: Icons.water_drop_rounded,
                        color: AppColors.bloodSugar,
                        onTap: healthProvider.fbsRecords.isNotEmpty
                            ? () => _showHealthAnalysisModal(
                                context,
                                'Blood Sugar Analysis',
                                healthProvider.fbsRecords.first,
                                'fbs',
                                user,
                              )
                            : null,
                      ),
                      HealthMetricCard(
                        title: 'Blood Count',
                        value: healthProvider.fbcRecords.isNotEmpty
                            ? healthProvider.fbcRecords.first.haemoglobin
                                  .toStringAsFixed(1)
                            : '--',
                        unit: healthProvider.fbcRecords.isNotEmpty
                            ? 'g/dL'
                            : '',
                        icon: Icons.science_rounded,
                        color: AppColors.bloodCount,
                        onTap: healthProvider.fbcRecords.isNotEmpty
                            ? () => _showHealthAnalysisModal(
                                context,
                                'Blood Count Analysis',
                                healthProvider.fbcRecords.first,
                                'fbc',
                                user,
                              )
                            : null,
                      ),
                      HealthMetricCard(
                        title: 'Lipid Profile',
                        value: healthProvider.lipidRecords.isNotEmpty
                            ? healthProvider.lipidRecords.first.totalCholesterol
                                  .toStringAsFixed(0)
                            : '--',
                        unit: healthProvider.lipidRecords.isNotEmpty
                            ? 'mg/dL'
                            : '',
                        icon: Icons.favorite_rounded,
                        color: AppColors.lipidProfile,
                        onTap: healthProvider.lipidRecords.isNotEmpty
                            ? () => _showHealthAnalysisModal(
                                context,
                                'Lipid Profile Analysis',
                                healthProvider.lipidRecords.first,
                                'lipid',
                                user,
                              )
                            : null,
                      ),
                      HealthMetricCard(
                        title: 'Liver Profile',
                        value: healthProvider.liverRecords.isNotEmpty
                            ? healthProvider.liverRecords.first.sgpt
                                  .toStringAsFixed(0)
                            : '--',
                        unit: healthProvider.liverRecords.isNotEmpty
                            ? 'U/L'
                            : '',
                        icon: Icons.local_hospital_rounded,
                        color: AppColors.liverProfile,
                        onTap: healthProvider.liverRecords.isNotEmpty
                            ? () => _showHealthAnalysisModal(
                                context,
                                'Liver Profile Analysis',
                                healthProvider.liverRecords.first,
                                'liver',
                                user,
                              )
                            : null,
                      ),
                      HealthMetricCard(
                        title: 'Urine Report',
                        value: healthProvider.urineRecords.isNotEmpty
                            ? healthProvider.urineRecords.first.specificGravity
                                  .toStringAsFixed(3)
                            : '--',
                        unit: healthProvider.urineRecords.isNotEmpty
                            ? 'SG'
                            : '',
                        icon: Icons.opacity_rounded,
                        color: AppColors.urineReport,
                        onTap: healthProvider.urineRecords.isNotEmpty
                            ? () => _showHealthAnalysisModal(
                                context,
                                'Urine Report Analysis',
                                healthProvider.urineRecords.first,
                                'urine',
                                user,
                              )
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Health Alerts Section
                  ..._buildHealthAlerts(healthProvider, user),

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
                      '${tests.length} test(s) recorded - Tap items to view insights',
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
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/all-records');
                      },
                      borderRadius: AppSpacing.borderRadiusMd,
                      child: Container(
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

  List<Widget> _buildHealthAlerts(
    HealthRecordsProvider provider,
    dynamic user,
  ) {
    final alerts = <Widget>[];

    // Check for critical/abnormal values
    if (provider.bpRecords.isNotEmpty) {
      final analysis = health.HealthAnalysis.analyzeBloodPressure(
        provider.bpRecords.first,
      );
      if (analysis.status == health.HealthStatus.abnormal) {
        alerts.add(
          HealthAlertBanner(
            title: 'Critical Blood Pressure',
            message:
                '${provider.bpRecords.first.bpLevel} mmHg - ${analysis.recommendation}',
            color: Colors.red,
            icon: Icons.favorite_rounded,
          ),
        );
      }
    }

    if (provider.fbsRecords.isNotEmpty) {
      final analysis = health.HealthAnalysis.analyzeFBS(
        provider.fbsRecords.first.fbsLevel,
      );
      if (analysis.status == health.HealthStatus.abnormal ||
          analysis.status == health.HealthStatus.high) {
        alerts.add(
          HealthAlertBanner(
            title: 'Blood Sugar Alert',
            message:
                '${provider.fbsRecords.first.fbsLevel.toStringAsFixed(0)} mg/dL - ${analysis.recommendation}',
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
        provider.fbcRecords.first.haemoglobin,
        user.gender,
      );
      if (analysis.status == health.HealthStatus.abnormal ||
          analysis.status == health.HealthStatus.low) {
        alerts.add(
          HealthAlertBanner(
            title: 'Blood Count Alert',
            message:
                'Hemoglobin ${provider.fbcRecords.first.haemoglobin.toStringAsFixed(1)} g/dL - ${analysis.recommendation}',
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
        provider.lipidRecords.first.totalCholesterol,
      );
      if (analysis.status == health.HealthStatus.high ||
          analysis.status == health.HealthStatus.abnormal) {
        alerts.add(
          HealthAlertBanner(
            title: 'Cholesterol Alert',
            message:
                '${provider.lipidRecords.first.totalCholesterol.toStringAsFixed(0)} mg/dL - ${analysis.recommendation}',
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
        provider.liverRecords.first.sgpt,
      );
      if (analysis.status == health.HealthStatus.high ||
          analysis.status == health.HealthStatus.abnormal) {
        alerts.add(
          HealthAlertBanner(
            title: 'Liver Function Alert',
            message:
                'SGPT ${provider.liverRecords.first.sgpt.toStringAsFixed(0)} U/L - ${analysis.recommendation}',
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

  void _showHealthAnalysisModal(
    BuildContext context,
    String title,
    dynamic record,
    String type,
    User user,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getIconForType(type),
                        color: _getColorForType(type),
                        size: 28,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          title,
                          style: AppTypography.titleLarge.copyWith(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      _buildTestResultsSection(record, type, user, isDark),
                      const SizedBox(height: AppSpacing.xl),
                      _buildHealthAnalysisSection(record, type, user, isDark),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTestResultsSection(
    dynamic record,
    String type,
    User user,
    bool isDark,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latest Test Results',
              style: AppTypography.titleMedium.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Test Date: ${DateFormat('MMM d, yyyy').format(DateTime.parse(_getTestDate(record, type)))}',
              style: AppTypography.body2.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ..._buildTestValuesWidgets(record, type, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthAnalysisSection(
    dynamic record,
    String type,
    User user,
    bool isDark,
  ) {
    final analysisResults = _getHealthAnalysis(record, type, user);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Analysis',
              style: AppTypography.titleMedium.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...analysisResults.map(
              (result) => _buildAnalysisCard(result, isDark),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.info, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'This analysis is for informational purposes only. Please consult your healthcare provider for professional medical advice.',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisCard(health.HealthResult result, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: result.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: result.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: result.color,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  result.statusText,
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            result.recommendation,
            style: AppTypography.body2.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'bp':
        return Icons.favorite_rounded;
      case 'fbs':
        return Icons.water_drop_rounded;
      case 'fbc':
        return Icons.science_rounded;
      case 'lipid':
        return Icons.favorite_rounded;
      case 'liver':
        return Icons.local_hospital_rounded;
      case 'urine':
        return Icons.opacity_rounded;
      default:
        return Icons.analytics;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'bp':
        return AppColors.bloodPressure;
      case 'fbs':
        return AppColors.bloodSugar;
      case 'fbc':
        return AppColors.bloodCount;
      case 'lipid':
        return AppColors.lipidProfile;
      case 'liver':
        return AppColors.liverProfile;
      case 'urine':
        return AppColors.urineReport;
      default:
        return AppColors.primary;
    }
  }

  String _getTestDate(dynamic record, String type) {
    switch (type) {
      case 'bp':
        return (record as BloodPressure).testDate;
      case 'fbs':
        return (record as FastingBloodSugar).testDate;
      case 'fbc':
        return (record as FullBloodCount).testDate;
      case 'lipid':
        return (record as LipidProfile).testDate;
      case 'liver':
        return (record as LiverProfile).testDate;
      case 'urine':
        return (record as UrineReport).testDate;
      default:
        return DateTime.now().toIso8601String();
    }
  }

  List<Widget> _buildTestValuesWidgets(
    dynamic record,
    String type,
    bool isDark,
  ) {
    switch (type) {
      case 'bp':
        final bp = record as BloodPressure;
        return [
          _buildValueRow(
            'Blood Pressure',
            '${bp.systolic}/${bp.diastolic}',
            'mmHg',
            isDark,
          ),
        ];
      case 'fbs':
        final fbs = record as FastingBloodSugar;
        return [
          _buildValueRow(
            'Fasting Blood Sugar',
            fbs.fbsLevel.toStringAsFixed(1),
            'mg/dL',
            isDark,
          ),
        ];
      case 'fbc':
        final fbc = record as FullBloodCount;
        return [
          _buildValueRow(
            'Hemoglobin',
            fbc.haemoglobin.toStringAsFixed(1),
            'g/dL',
            isDark,
          ),
          _buildValueRow(
            'White Blood Cells',
            fbc.totalLeucocyteCount.toStringAsFixed(0),
            'cells/mcL',
            isDark,
          ),
          _buildValueRow(
            'Platelets',
            fbc.plateletCount.toStringAsFixed(0),
            'cells/mcL',
            isDark,
          ),
        ];
      case 'lipid':
        final lipid = record as LipidProfile;
        return [
          _buildValueRow(
            'Total Cholesterol',
            lipid.totalCholesterol.toStringAsFixed(0),
            'mg/dL',
            isDark,
          ),
          _buildValueRow(
            'HDL Cholesterol',
            lipid.hdl.toStringAsFixed(0),
            'mg/dL',
            isDark,
          ),
          _buildValueRow(
            'LDL Cholesterol',
            lipid.ldl.toStringAsFixed(0),
            'mg/dL',
            isDark,
          ),
          _buildValueRow(
            'Triglycerides',
            lipid.triglycerides.toStringAsFixed(0),
            'mg/dL',
            isDark,
          ),
        ];
      case 'liver':
        final liver = record as LiverProfile;
        return [
          _buildValueRow(
            'Total Protein',
            liver.proteinTotalSerum.toStringAsFixed(1),
            'g/dL',
            isDark,
          ),
          _buildValueRow(
            'Albumin',
            liver.albuminSerum.toStringAsFixed(1),
            'g/dL',
            isDark,
          ),
          _buildValueRow(
            'Bilirubin',
            liver.bilirubinTotalSerum.toStringAsFixed(1),
            'mg/dL',
            isDark,
          ),
          _buildValueRow(
            'SGPT/ALT',
            liver.sgpt.toStringAsFixed(0),
            'U/L',
            isDark,
          ),
        ];
      case 'urine':
        final urine = record as UrineReport;
        return [
          _buildValueRow(
            'Specific Gravity',
            urine.specificGravity.toStringAsFixed(3),
            '',
            isDark,
          ),
          _buildValueRow('Protein', urine.protein, '', isDark),
          _buildValueRow('Sugar', urine.sugar, '', isDark),
        ];
      default:
        return [];
    }
  }

  Widget _buildValueRow(String label, String value, String unit, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body2.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          Text(
            '$value $unit',
            style: AppTypography.body2.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<health.HealthResult> _getHealthAnalysis(
    dynamic record,
    String type,
    User user,
  ) {
    switch (type) {
      case 'bp':
        final bp = record as BloodPressure;
        return [
          health.HealthAnalysis.analyzeSystolic(bp.systolic),
          health.HealthAnalysis.analyzeDiastolic(bp.diastolic),
        ];
      case 'fbs':
        final fbs = record as FastingBloodSugar;
        return [health.HealthAnalysis.analyzeFBS(fbs.fbsLevel)];
      case 'fbc':
        final fbc = record as FullBloodCount;
        return [
          health.HealthAnalysis.analyzeHaemoglobin(
            fbc.haemoglobin,
            user.gender,
          ),
          health.HealthAnalysis.analyzeWBC(fbc.totalLeucocyteCount),
          health.HealthAnalysis.analyzePlatelets(fbc.plateletCount),
        ];
      case 'lipid':
        final lipid = record as LipidProfile;
        return [
          health.HealthAnalysis.analyzeTotalCholesterol(lipid.totalCholesterol),
          health.HealthAnalysis.analyzeHDL(lipid.hdl, user.gender),
          health.HealthAnalysis.analyzeLDL(lipid.ldl),
          health.HealthAnalysis.analyzeTriglycerides(lipid.triglycerides),
        ];
      case 'liver':
        final liver = record as LiverProfile;
        return [
          health.HealthAnalysis.analyzeSGPT(liver.sgpt),
          health.HealthAnalysis.analyzeAlbumin(liver.albuminSerum),
          health.HealthAnalysis.analyzeBilirubin(liver.bilirubinTotalSerum),
        ];
      case 'urine':
        final urine = record as UrineReport;
        return [
          health.HealthAnalysis.analyzeSpecificGravity(urine.specificGravity),
          health.HealthAnalysis.analyzeUrineProtein(urine.protein),
          health.HealthAnalysis.analyzeUrineSugar(urine.sugar),
        ];
      default:
        return [];
    }
  }
}
