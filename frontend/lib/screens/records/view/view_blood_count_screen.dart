import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/health_records_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/full_blood_count.dart';
import '../../../widgets/feedback/empty_state.dart';
import '../add/add_blood_count_screen.dart';

class ViewBloodCountScreen extends StatelessWidget {
  const ViewBloodCountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text('Blood Count (CBC)', style: AppTypography.title1),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddBloodCountScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<HealthRecordsProvider>(
        builder: (context, provider, _) {
          final records = provider.fbcRecords;

          if (records.isEmpty) {
            return EmptyState(
              icon: Icons.science_rounded,
              message: 'No Blood Count Records',
              description: 'Start tracking your CBC results',
              actionLabel: 'Add Record',
              onAction: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddBloodCountScreen()),
              ),
            );
          }

          // Data is already sorted by provider (newest first)
          return RefreshIndicator(
            onRefresh: () async {
              final user = context.read<AuthProvider>().currentUser;
              if (user != null) await provider.loadFBCRecords(user.id);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(records, isDark),
                  const SizedBox(height: AppSpacing.xl),
                  _buildChartSection(records, isDark),
                  const SizedBox(height: AppSpacing.xl),
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

  Widget _buildSummaryCard(List<FullBloodCount> records, bool isDark) {
    final latest = records.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.bloodCount.withOpacity(0.15),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: Icon(
                  Icons.science_rounded,
                  color: AppColors.bloodCount,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Latest Hemoglobin', style: AppTypography.label1),
                    Text(
                      '${latest.haemoglobin.toStringAsFixed(1)} g/dL',
                      style: AppTypography.headline2,
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
                'WBC',
                '${(latest.totalLeucocyteCount / 1000).toStringAsFixed(1)}K',
                isDark,
              ),
              _buildStatItem(
                'Platelets',
                '${(latest.plateletCount / 1000).toStringAsFixed(0)}K',
                isDark,
              ),
              _buildStatItem('Records', '${records.length}', isDark),
            ],
          ),
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
            style: AppTypography.title3.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }

  Widget _buildChartSection(List<FullBloodCount> records, bool isDark) {
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
          Text('Hemoglobin Trend', style: AppTypography.title3),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: 8,
                maxY: 20,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    final isLowReference = value == 12;
                    final isHighReference = value == 17.5;
                    final isReference = isLowReference || isHighReference;
                    return FlLine(
                      color: isReference
                          ? (isLowReference
                                    ? AppColors.error
                                    : AppColors.warning)
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
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(1)}',
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
                        final date = DateFormat(
                          'MMM dd, yyyy',
                        ).format(DateTime.parse(record.testDate));
                        final hemoglobin = record.haemoglobin.toStringAsFixed(
                          1,
                        );
                        String status = 'Normal';
                        if (record.haemoglobin < 12) {
                          status = 'Low (Anemia)';
                        } else if (record.haemoglobin > 17.5) {
                          status = 'High';
                        }

                        return LineTooltipItem(
                          'Hemoglobin: $hemoglobin g/dL\nStatus: $status\n$date',
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
                          (e) => FlSpot(e.key.toDouble(), e.value.haemoglobin),
                        )
                        .toList(),
                    isCurved: true,
                    color: AppColors.bloodCount,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.bloodCount.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(
    BuildContext context,
    FullBloodCount record,
    bool isDark,
    HealthRecordsProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border(left: BorderSide(color: AppColors.bloodCount, width: 4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hb: ${record.haemoglobin.toStringAsFixed(1)} g/dL',
                  style: AppTypography.title3,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'WBC: ${record.totalLeucocyteCount.toStringAsFixed(0)} | PLT: ${record.plateletCount.toStringAsFixed(0)}',
                  style: AppTypography.caption,
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
