import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../providers/health_records_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: CustomAppBar(title: 'Analytics', showBackButton: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Consumer<HealthRecordsProvider>(
          builder: (context, healthProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Blood Sugar Trends
                _buildChartSection(
                  context,
                  'Blood Sugar Trends',
                  Icons.bloodtype_rounded,
                  AppColors.bloodSugar,
                  _buildFBSChart(context, healthProvider),
                ),

                SizedBox(height: AppSpacing.xl),

                // Blood Pressure Trends
                _buildChartSection(
                  context,
                  'Blood Pressure Trends',
                  Icons.favorite_rounded,
                  AppColors.bloodPressure,
                  _buildBPChart(context, healthProvider),
                ),

                SizedBox(height: AppSpacing.xl),

                // Statistics Cards
                Text(
                  'Health Statistics',
                  style: AppTypography.headlineSmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.lg),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.5,
                  children: [
                    _buildStatCard(
                      context,
                      'Avg FBS',
                      _calculateAvgFBS(healthProvider),
                      'mg/dL',
                      AppColors.bloodSugar,
                    ),
                    _buildStatCard(
                      context,
                      'Latest BP',
                      _getLatestBP(healthProvider),
                      'mmHg',
                      AppColors.bloodPressure,
                    ),
                    _buildStatCard(
                      context,
                      'Total Records',
                      _getTotalRecords(healthProvider).toString(),
                      'entries',
                      AppColors.primary,
                    ),
                    _buildStatCard(
                      context,
                      'This Month',
                      _getThisMonthRecords(healthProvider).toString(),
                      'new records',
                      AppColors.success,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChartSection(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget chart,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(icon, color: color, size: AppSpacing.iconMd),
              ),
              SizedBox(width: AppSpacing.md),
              Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          SizedBox(height: 200, child: chart),
        ],
      ),
    );
  }

  Widget _buildFBSChart(BuildContext context, HealthRecordsProvider provider) {
    if (provider.fbsRecords.isEmpty) {
      return const EmptyState(
        icon: Icons.show_chart_rounded,
        message: 'No blood sugar data available',
        description: 'Start tracking to see trends',
      );
    }

    final spots = provider.fbsRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.fbsLevel);
    }).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: (isDark ? AppColors.darkBorder : AppColors.border)
                  .withOpacity(0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: (isDark ? AppColors.darkBorder : AppColors.border)
                  .withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.bloodSugar,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.bloodSugar,
                  strokeWidth: 2,
                  strokeColor: isDark
                      ? AppColors.darkSurface
                      : AppColors.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.bloodSugar.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBPChart(BuildContext context, HealthRecordsProvider provider) {
    if (provider.bpRecords.isEmpty) {
      return const EmptyState(
        icon: Icons.show_chart_rounded,
        message: 'No blood pressure data available',
        description: 'Start tracking to see trends',
      );
    }

    final systolicSpots = provider.bpRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.systolic.toDouble());
    }).toList();

    final diastolicSpots = provider.bpRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.diastolic.toDouble());
    }).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: (isDark ? AppColors.darkBorder : AppColors.border)
                  .withOpacity(0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: (isDark ? AppColors.darkBorder : AppColors.border)
                  .withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: systolicSpots,
            isCurved: true,
            color: AppColors.bloodPressure,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.bloodPressure,
                  strokeWidth: 2,
                  strokeColor: isDark
                      ? AppColors.darkSurface
                      : AppColors.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.bloodPressure.withOpacity(0.1),
            ),
          ),
          LineChartBarData(
            spots: diastolicSpots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.primary,
                  strokeWidth: 2,
                  strokeColor: isDark
                      ? AppColors.darkSurface
                      : AppColors.surface,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String unit,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTypography.labelMedium.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.headlineMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            unit,
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _calculateAvgFBS(HealthRecordsProvider provider) {
    if (provider.fbsRecords.isEmpty) return '--';
    final total = provider.fbsRecords.fold<double>(
      0,
      (sum, record) => sum + record.fbsLevel,
    );
    return (total / provider.fbsRecords.length).toStringAsFixed(1);
  }

  String _getLatestBP(HealthRecordsProvider provider) {
    if (provider.bpRecords.isEmpty) return '--/--';
    final latest = provider.bpRecords.last;
    return '${latest.systolic}/${latest.diastolic}';
  }

  int _getTotalRecords(HealthRecordsProvider provider) {
    return provider.fbsRecords.length +
        provider.bpRecords.length +
        provider.fbcRecords.length +
        provider.lipidRecords.length +
        provider.liverRecords.length +
        provider.urineRecords.length;
  }

  int _getThisMonthRecords(HealthRecordsProvider provider) {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);

    int count = 0;

    // Count FBS records from this month
    count += provider.fbsRecords.where((record) {
      final recordDate = DateTime.parse(record.testDate);
      return recordDate.isAfter(thisMonth);
    }).length;

    // Count BP records from this month
    count += provider.bpRecords.where((record) {
      final recordDate = DateTime.parse(record.testDate);
      return recordDate.isAfter(thisMonth);
    }).length;

    return count;
  }
}
