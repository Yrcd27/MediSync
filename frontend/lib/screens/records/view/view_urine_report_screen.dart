import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/health_records_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/urine_report.dart';
import '../../../widgets/feedback/empty_state.dart';
import '../../../utils/health_analysis.dart' as health;
import '../add/add_urine_report_screen.dart';

class ViewUrineReportScreen extends StatelessWidget {
  const ViewUrineReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text('Urine Report', style: AppTypography.title1),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddUrineReportScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<HealthRecordsProvider>(
        builder: (context, provider, _) {
          final records = provider.urineRecords;

          if (records.isEmpty) {
            return EmptyState(
              icon: Icons.opacity_rounded,
              message: 'No Urine Reports',
              description: 'Start tracking your urinalysis results',
              actionLabel: 'Add Record',
              onAction: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddUrineReportScreen()),
              ),
            );
          }

          // Data is already sorted by provider (newest first)
          return RefreshIndicator(
            onRefresh: () async {
              final user = context.read<AuthProvider>().currentUser;
              if (user != null) await provider.loadUrineRecords(user.id);
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

  Widget _buildSummaryCard(List<UrineReport> records, bool isDark) {
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
                  color: AppColors.urineReport.withOpacity(0.15),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: Icon(
                  Icons.opacity_rounded,
                  color: AppColors.urineReport,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Specific Gravity', style: AppTypography.label1),
                    Text(
                      latest.specificGravity.toStringAsFixed(3),
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
              _buildStatItem('Color', latest.color, isDark),
              _buildStatItem('Protein', latest.protein, isDark),
              _buildStatItem('Sugar', latest.sugar, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, bool isDark) {
    Color valueColor = AppColors.success;
    if (value != 'Negative' &&
        value != 'Pale Yellow' &&
        value != 'Yellow' &&
        value != 'Clear') {
      valueColor = AppColors.warning;
    }
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.label1.copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }

  Widget _buildChartSection(List<UrineReport> records, bool isDark) {
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
          Text('Urine Analysis Trends', style: AppTypography.title3),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    );
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
                          style: AppTypography.caption.copyWith(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < chartRecords.length) {
                          return Text(
                            DateFormat('MM/dd').format(
                              DateTime.parse(chartRecords[index].testDate),
                            ),
                            style: AppTypography.caption.copyWith(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: AppTypography.caption.copyWith(fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (chartRecords.length - 1).toDouble(),
                minY: 1.000,
                maxY: 1.040,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: isDark
                        ? AppColors.darkSurface
                        : AppColors.surface,
                    tooltipBorder: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        final record = chartRecords[spot.x.toInt()];
                        final date = DateFormat(
                          'MMM dd, yyyy',
                        ).format(DateTime.parse(record.testDate));

                        String label = '';
                        String status = '';
                        Color lineColor = AppColors.primary;

                        label =
                            'Specific Gravity: ${record.specificGravity.toStringAsFixed(3)}';
                        final sgData =
                            health.HealthAnalysis.analyzeSpecificGravity(
                              record.specificGravity,
                            );
                        status = sgData.statusText;
                        lineColor = AppColors.urineReport;

                        return LineTooltipItem(
                          '$label\n$status\n$date',
                          TextStyle(
                            color: lineColor,
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
                          (e) =>
                              FlSpot(e.key.toDouble(), e.value.specificGravity),
                        )
                        .toList(),
                    isCurved: true,
                    color: AppColors.urineReport,
                    barWidth: 3,
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
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.urineReport.withOpacity(0.1),
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
              _buildLegendItem('Specific Gravity', AppColors.urineReport),
              const SizedBox(width: AppSpacing.lg),
              Text(
                'Normal Range: 1.005 - 1.030',
                style: AppTypography.caption.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
    UrineReport record,
    bool isDark,
    HealthRecordsProvider provider,
  ) {
    bool hasAbnormal =
        record.protein != 'Negative' || record.sugar != 'Negative';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border(
          left: BorderSide(
            color: hasAbnormal ? AppColors.warning : AppColors.urineReport,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SG: ${record.specificGravity.toStringAsFixed(3)}',
                  style: AppTypography.title3,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${record.color} | ${record.appearance}',
                  style: AppTypography.body2,
                ),
                Text(
                  'Protein: ${record.protein} | Sugar: ${record.sugar}',
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
