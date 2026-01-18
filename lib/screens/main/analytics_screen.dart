import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/feedback/empty_state.dart';
import '../../providers/health_records_provider.dart';

enum TimeRange { week, month, threeMonths, year, all }

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  TimeRange _selectedRange = TimeRange.month;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: CustomAppBar(title: 'Analytics', showBackButton: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Consumer<HealthRecordsProvider>(
          builder: (context, healthProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Range Filter
                _buildTimeRangeFilter(context),
                SizedBox(height: AppSpacing.xl),

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

                // Full Blood Count Trends
                _buildChartSection(
                  context,
                  'Blood Count Trends',
                  Icons.water_drop_rounded,
                  AppColors.bloodCount,
                  _buildFBCChart(context, healthProvider),
                ),

                SizedBox(height: AppSpacing.xl),

                // Lipid Profile Trends
                _buildChartSection(
                  context,
                  'Lipid Profile Trends',
                  Icons.medication_rounded,
                  AppColors.lipidProfile,
                  _buildLipidChart(context, healthProvider),
                ),

                SizedBox(height: AppSpacing.xl),

                // Liver Profile Trends
                _buildChartSection(
                  context,
                  'Liver Function Trends',
                  Icons.local_hospital_rounded,
                  AppColors.liverProfile,
                  _buildLiverChart(context, healthProvider),
                ),

                SizedBox(height: AppSpacing.xl),

                // Urine Report Trends
                _buildChartSection(
                  context,
                  'Urine Analysis Trends',
                  Icons.science_rounded,
                  AppColors.urineReport,
                  _buildUrineChart(context, healthProvider),
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

  Widget _buildTimeRangeFilter(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildRangeButton(context, 'Week', TimeRange.week),
          _buildRangeButton(context, 'Month', TimeRange.month),
          _buildRangeButton(context, '3M', TimeRange.threeMonths),
          _buildRangeButton(context, 'Year', TimeRange.year),
          _buildRangeButton(context, 'All', TimeRange.all),
        ],
      ),
    );
  }

  Widget _buildRangeButton(
    BuildContext context,
    String label,
    TimeRange range,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedRange == range;

    return GestureDetector(
      onTap: () => setState(() => _selectedRange = range),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkBackground : Colors.transparent),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
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
    final filteredRecords = _filterRecordsByTimeRange(
      provider.fbsRecords.map((r) => DateTime.parse(r.testDate)).toList(),
      provider.fbsRecords,
    );

    if (filteredRecords.isEmpty) {
      return const EmptyState(
        icon: Icons.show_chart_rounded,
        message: 'No blood sugar data available',
        description: 'Start tracking to see trends',
      );
    }

    // Reverse data for chronological display (oldest to newest from left to right)
    final chartRecords = filteredRecords.reversed.toList();
    final spots = chartRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.fbsLevel);
    }).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    fontSize: 11,
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
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (chartRecords.length - 1).toDouble(),
        minY: 70,
        maxY: 180,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: isDark ? AppColors.darkSurface : AppColors.surface,
            tooltipBorder: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final record = chartRecords[spot.x.toInt()];
                final value = record.fbsLevel.toInt();

                String status;
                if (value < 100) {
                  status = 'Normal';
                } else if (value < 126) {
                  status = 'Pre-diabetic';
                } else {
                  status = 'Diabetic';
                }

                return LineTooltipItem(
                  'FBS: ${value} mg/dL\n$status',
                  TextStyle(
                    color: spot.bar.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
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
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildBPChart(BuildContext context, HealthRecordsProvider provider) {
    final filteredRecords = _filterRecordsByTimeRange(
      provider.bpRecords.map((r) => DateTime.parse(r.testDate)).toList(),
      provider.bpRecords,
    );

    if (filteredRecords.isEmpty) {
      return const EmptyState(
        icon: Icons.show_chart_rounded,
        message: 'No blood pressure data available',
        description: 'Start tracking to see trends',
      );
    }

    // Reverse data for chronological display (oldest to newest from left to right)
    final chartRecords = filteredRecords.reversed.toList();
    final systolicSpots = chartRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.systolic.toDouble());
    }).toList();

    final diastolicSpots = chartRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.diastolic.toDouble());
    }).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    fontSize: 11,
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
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (chartRecords.length - 1).toDouble(),
        minY: 50,
        maxY: 200,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: isDark ? AppColors.darkSurface : AppColors.surface,
            tooltipBorder: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final record = chartRecords[spot.x.toInt()];
                final label = spot.barIndex == 0 ? 'Systolic' : 'Diastolic';
                final value = spot.barIndex == 0
                    ? record.systolic
                    : record.diastolic;

                String status = '';
                if (spot.barIndex == 0) {
                  status = value < 120
                      ? 'Normal'
                      : value < 130
                      ? 'Elevated'
                      : value < 140
                      ? 'Stage 1 High'
                      : 'Stage 2 High';
                } else {
                  status = value < 80
                      ? 'Normal'
                      : value < 85
                      ? 'Elevated'
                      : value < 90
                      ? 'Stage 1 High'
                      : 'Stage 2 High';
                }

                return LineTooltipItem(
                  '$label: ${value.toStringAsFixed(0)} mmHg\\n$status',
                  TextStyle(
                    color: spot.bar.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 120,
              color: AppColors.success,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
            HorizontalLine(
              y: 130,
              color: AppColors.warning,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
            HorizontalLine(
              y: 140,
              color: AppColors.error,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ],
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
                  strokeColor: Colors.white,
                );
              },
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
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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

  Widget _buildFBCChart(BuildContext context, HealthRecordsProvider provider) {
    final filteredRecords = _filterRecordsByTimeRange(
      provider.fbcRecords.map((r) => DateTime.parse(r.testDate)).toList(),
      provider.fbcRecords,
    );

    if (filteredRecords.isEmpty) {
      return const EmptyState(
        icon: Icons.show_chart_rounded,
        message: 'No blood count data available',
        description: 'Start tracking to see trends',
      );
    }

    // Reverse data for chronological display (oldest to newest from left to right)
    final chartRecords = filteredRecords.reversed.toList();
    final hemoglobinSpots = chartRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.haemoglobin);
    }).toList();

    final wbcSpots = chartRecords.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.totalLeucocyteCount / 1000,
      );
    }).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 5,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    fontSize: 11,
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
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (chartRecords.length - 1).toDouble(),
        minY: 8,
        maxY: 20,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: isDark ? AppColors.darkSurface : AppColors.surface,
            tooltipBorder: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final record = chartRecords[spot.x.toInt()];

                if (spot.barIndex == 0) {
                  final hb = record.haemoglobin;
                  String status;
                  if (hb < 12) {
                    status = 'Low';
                  } else if (hb <= 17.5) {
                    status = 'Normal';
                  } else {
                    status = 'High';
                  }

                  return LineTooltipItem(
                    'Hemoglobin: ${hb.toStringAsFixed(1)} g/dL\n$status',
                    TextStyle(
                      color: spot.bar.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                } else {
                  final wbc = record.totalLeucocyteCount;
                  String status;
                  if (wbc < 4000) {
                    status = 'Low';
                  } else if (wbc <= 11000) {
                    status = 'Normal';
                  } else {
                    status = 'High';
                  }

                  return LineTooltipItem(
                    'WBC: ${(wbc / 1000).toStringAsFixed(1)}k\n$status',
                    TextStyle(
                      color: spot.bar.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: hemoglobinSpots,
            isCurved: true,
            color: AppColors.bloodCount,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.bloodCount,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
          LineChartBarData(
            spots: wbcSpots,
            isCurved: true,
            color: AppColors.primary.withOpacity(0.6),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.primary.withOpacity(0.6),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildLipidChart(
    BuildContext context,
    HealthRecordsProvider provider,
  ) {
    final filteredRecords = _filterRecordsByTimeRange(
      provider.lipidRecords.map((r) => DateTime.parse(r.testDate)).toList(),
      provider.lipidRecords,
    );

    if (filteredRecords.isEmpty) {
      return const EmptyState(
        icon: Icons.show_chart_rounded,
        message: 'No lipid profile data available',
        description: 'Start tracking to see trends',
      );
    }

    // Reverse data for chronological display (oldest to newest from left to right)
    final chartRecords = filteredRecords.reversed.toList();
    final totalCholSpots = chartRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.totalCholesterol);
    }).toList();

    final hdlSpots = chartRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.hdl);
    }).toList();

    final ldlSpots = chartRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.ldl);
    }).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    fontSize: 11,
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
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (chartRecords.length - 1).toDouble(),
        minY: 0,
        maxY: 300,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: isDark ? AppColors.darkSurface : AppColors.surface,
            tooltipBorder: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final record = chartRecords[spot.x.toInt()];

                if (spot.barIndex == 0) {
                  final tc = record.totalCholesterol;
                  String status;
                  if (tc < 200) {
                    status = 'Desirable';
                  } else if (tc < 240) {
                    status = 'Borderline high';
                  } else {
                    status = 'High';
                  }

                  return LineTooltipItem(
                    'Total Cholesterol: ${tc.toStringAsFixed(0)} mg/dL\n$status',
                    TextStyle(
                      color: spot.bar.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                } else if (spot.barIndex == 1) {
                  final hdl = record.hdl;
                  String status;
                  if (hdl >= 60) {
                    status = 'Protective';
                  } else if (hdl >= 40) {
                    status = 'Acceptable';
                  } else {
                    status = 'Low';
                  }

                  return LineTooltipItem(
                    'HDL: ${hdl.toStringAsFixed(0)} mg/dL\n$status',
                    TextStyle(
                      color: spot.bar.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                } else {
                  final ldl = record.ldl;
                  String status;
                  if (ldl < 100) {
                    status = 'Optimal';
                  } else if (ldl < 130) {
                    status = 'Near optimal';
                  } else if (ldl < 160) {
                    status = 'Borderline high';
                  } else {
                    status = 'High';
                  }

                  return LineTooltipItem(
                    'LDL: ${ldl.toStringAsFixed(0)} mg/dL\n$status',
                    TextStyle(
                      color: spot.bar.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: totalCholSpots,
            isCurved: true,
            color: AppColors.lipidProfile,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.lipidProfile,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
          LineChartBarData(
            spots: hdlSpots,
            isCurved: true,
            color: AppColors.success,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.success,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
          LineChartBarData(
            spots: ldlSpots,
            isCurved: true,
            color: AppColors.warning,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.warning,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildLiverChart(
    BuildContext context,
    HealthRecordsProvider provider,
  ) {
    final filteredRecords = _filterRecordsByTimeRange(
      provider.liverRecords.map((r) => DateTime.parse(r.testDate)).toList(),
      provider.liverRecords,
    );

    if (filteredRecords.isEmpty) {
      return const EmptyState(
        icon: Icons.show_chart_rounded,
        message: 'No liver profile data available',
        description: 'Start tracking to see trends',
      );
    }

    // Reverse data for chronological display (oldest to newest from left to right)
    final chartRecords = filteredRecords.reversed.toList();
    final sgptSpots = chartRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.sgpt);
    }).toList();

    final proteinSpots = chartRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.proteinTotalSerum);
    }).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    fontSize: 11,
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
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (chartRecords.length - 1).toDouble(),
        minY: 0,
        maxY: 100,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: isDark ? AppColors.darkSurface : AppColors.surface,
            tooltipBorder: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final record = chartRecords[spot.x.toInt()];

                if (spot.barIndex == 0) {
                  final sgpt = record.sgpt;
                  String status;
                  if (sgpt <= 56) {
                    status = 'Normal';
                  } else {
                    status = 'Elevated';
                  }

                  return LineTooltipItem(
                    'SGPT: ${sgpt.toStringAsFixed(0)} U/L\n$status',
                    TextStyle(
                      color: spot.bar.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                } else {
                  final protein = record.proteinTotalSerum;
                  String status;
                  if (protein >= 6.0 && protein <= 8.3) {
                    status = 'Normal';
                  } else if (protein < 6.0) {
                    status = 'Low';
                  } else {
                    status = 'High';
                  }

                  return LineTooltipItem(
                    'Total Protein: ${protein.toStringAsFixed(1)} g/dL\n$status',
                    TextStyle(
                      color: spot.bar.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: sgptSpots,
            isCurved: true,
            color: AppColors.liverProfile,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.liverProfile,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
          LineChartBarData(
            spots: proteinSpots,
            isCurved: true,
            color: AppColors.warning,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.warning,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildUrineChart(
    BuildContext context,
    HealthRecordsProvider provider,
  ) {
    final filteredRecords = _filterRecordsByTimeRange(
      provider.urineRecords.map((r) => DateTime.parse(r.testDate)).toList(),
      provider.urineRecords,
    );

    if (filteredRecords.isEmpty) {
      return const EmptyState(
        icon: Icons.show_chart_rounded,
        message: 'No urine report data available',
        description: 'Start tracking to see trends',
      );
    }

    // Reverse data for chronological display (oldest to newest from left to right)
    final chartRecords = filteredRecords.reversed.toList();
    final sgSpots = chartRecords.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.specificGravity);
    }).toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: 0.005,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(3),
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    fontSize: 10,
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
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (chartRecords.length - 1).toDouble(),
        minY: 1.000,
        maxY: 1.035,
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: isDark ? AppColors.darkSurface : AppColors.surface,
            tooltipBorder: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.border,
            ),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final record = chartRecords[spot.x.toInt()];
                final sg = record.specificGravity;

                String status;
                if (sg >= 1.005 && sg <= 1.030) {
                  status = 'Normal';
                } else if (sg < 1.005) {
                  status = 'Low';
                } else {
                  status = 'High';
                }

                return LineTooltipItem(
                  'Specific Gravity: ${sg.toStringAsFixed(3)}\\n$status',
                  TextStyle(
                    color: spot.bar.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: sgSpots,
            isCurved: true,
            color: AppColors.urineReport,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.urineReport,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  List<T> _filterRecordsByTimeRange<T>(List<DateTime> dates, List<T> records) {
    if (dates.isEmpty || records.isEmpty) return [];

    final now = DateTime.now();
    DateTime cutoffDate;

    switch (_selectedRange) {
      case TimeRange.week:
        cutoffDate = now.subtract(const Duration(days: 7));
        break;
      case TimeRange.month:
        cutoffDate = now.subtract(const Duration(days: 30));
        break;
      case TimeRange.threeMonths:
        cutoffDate = now.subtract(const Duration(days: 90));
        break;
      case TimeRange.year:
        cutoffDate = now.subtract(const Duration(days: 365));
        break;
      case TimeRange.all:
        return records;
    }

    final filtered = <T>[];
    for (int i = 0; i < dates.length; i++) {
      if (dates[i].isAfter(cutoffDate)) {
        filtered.add(records[i]);
      }
    }
    return filtered;
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
    final latest = provider.bpRecords.first;
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
