import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/health_records_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/blood_pressure.dart';
import '../../../widgets/feedback/empty_state.dart';
import '../add/add_blood_pressure_screen.dart';

class ViewBloodPressureScreen extends StatelessWidget {
  const ViewBloodPressureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text('Blood Pressure', style: AppTypography.title1),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddBloodPressureScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<HealthRecordsProvider>(
        builder: (context, provider, _) {
          final records = provider.bpRecords;

          if (records.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_rounded,
              message: 'No Blood Pressure Records',
              description: 'Start tracking your blood pressure',
              actionLabel: 'Add Record',
              onAction: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddBloodPressureScreen(),
                ),
              ),
            );
          }

          // Data is already sorted by provider (newest first)
          return RefreshIndicator(
            onRefresh: () async {
              final user = context.read<AuthProvider>().currentUser;
              if (user != null) await provider.loadBPRecords(user.id);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Card
                  _buildSummaryCard(records, isDark),
                  const SizedBox(height: AppSpacing.xl),

                  // Chart Section
                  _buildChartSection(records, isDark),
                  const SizedBox(height: AppSpacing.xl),

                  // Records List
                  Text('All Records', style: AppTypography.title2),
                  const SizedBox(height: AppSpacing.md),
                  ...records.map(
                    (r) => _buildRecordCard(context, r, isDark, provider),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(List<BloodPressure> records, bool isDark) {
    final latest = records.first;
    final avgSystolic =
        records.map((r) => r.systolic).reduce((a, b) => a + b) / records.length;
    final avgDiastolic =
        records.map((r) => r.diastolic).reduce((a, b) => a + b) /
        records.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.bloodPressure.withOpacity(0.15),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  color: AppColors.bloodPressure,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Latest Reading', style: AppTypography.label1),
                    Text(
                      latest.bpLevel,
                      style: AppTypography.headline2.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _buildStatItem(
                'Average',
                '${avgSystolic.toStringAsFixed(0)}/${avgDiastolic.toStringAsFixed(0)}',
                isDark,
              ),
              _buildStatItem('Records', '${records.length}', isDark),
              _buildStatItem(
                'Date',
                DateFormat('MMM dd').format(DateTime.parse(latest.testDate)),
                isDark,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.title3.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }

  Widget _buildChartSection(List<BloodPressure> records, bool isDark) {
    final chartRecords = records.take(10).toList().reversed.toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trend (Last ${chartRecords.length} readings)',
            style: AppTypography.title3,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: 50,
                maxY: 200,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    // Highlight reference lines
                    final isReference = [120, 130, 140].contains(value.toInt());
                    return FlLine(
                      color: isReference
                          ? (value == 120
                                    ? AppColors.success
                                    : value == 130
                                    ? AppColors.warning
                                    : AppColors.error)
                                .withOpacity(0.6)
                          : (isDark ? AppColors.darkBorder : AppColors.border)
                                .withOpacity(0.3),
                      strokeWidth: isReference ? 2 : 1,
                      dashArray: isReference ? [5, 5] : null,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: AppTypography.caption.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: (chartRecords.length / 4).ceil().toDouble(),
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < chartRecords.length) {
                          return Text(
                            DateFormat('MM/dd').format(
                              DateTime.parse(chartRecords[index].testDate),
                            ),
                            style: AppTypography.caption.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                              fontSize: 9,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: isDark
                        ? AppColors.darkSurface
                        : AppColors.surface,
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final record = chartRecords[spot.x.toInt()];
                        final isSystemic = spot.barIndex == 0;
                        final value = isSystemic
                            ? record.systolic
                            : record.diastolic;
                        final label = isSystemic ? 'Systolic' : 'Diastolic';
                        final date = DateFormat(
                          'MMM dd, yyyy',
                        ).format(DateTime.parse(record.testDate));

                        return LineTooltipItem(
                          '$label: ${value.toStringAsFixed(0)} mmHg\n$date',
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
                    spots: chartRecords
                        .asMap()
                        .entries
                        .map(
                          (e) => FlSpot(
                            e.key.toDouble(),
                            e.value.systolic.toDouble(),
                          ),
                        )
                        .toList(),
                    isCurved: true,
                    color: AppColors.bloodPressure,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.bloodPressure.withOpacity(0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: chartRecords
                        .asMap()
                        .entries
                        .map(
                          (e) => FlSpot(
                            e.key.toDouble(),
                            e.value.diastolic.toDouble(),
                          ),
                        )
                        .toList(),
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Systolic', AppColors.bloodPressure),
              const SizedBox(width: AppSpacing.xl),
              _buildLegendItem('Diastolic', AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: AppTypography.caption),
      ],
    );
  }

  Widget _buildRecordCard(
    BuildContext context,
    BloodPressure record,
    bool isDark,
    HealthRecordsProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border(
          left: BorderSide(color: AppColors.bloodPressure, width: 4),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.bpLevel, style: AppTypography.title3),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Systolic: ${record.systolic} mmHg | Diastolic: ${record.diastolic} mmHg',
                  style: AppTypography.body2,
                ),
                Text(
                  DateFormat(
                    'MMM dd, yyyy',
                  ).format(DateTime.parse(record.testDate)),
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
