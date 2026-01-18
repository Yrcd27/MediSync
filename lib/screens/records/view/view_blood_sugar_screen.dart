import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/health_records_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/fasting_blood_sugar.dart';
import '../../../widgets/feedback/empty_state.dart';
import '../add/add_blood_sugar_screen.dart';

class ViewBloodSugarScreen extends StatelessWidget {
  const ViewBloodSugarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text('Blood Sugar', style: AppTypography.title1),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddBloodSugarScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<HealthRecordsProvider>(
        builder: (context, provider, _) {
          final records = provider.fbsRecords;

          if (records.isEmpty) {
            return EmptyState(
              icon: Icons.water_drop_rounded,
              message: 'No Blood Sugar Records',
              description: 'Start tracking your fasting blood sugar',
              actionLabel: 'Add Record',
              onAction: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddBloodSugarScreen()),
              ),
            );
          }

          // Data is already sorted by provider (newest first)
          return RefreshIndicator(
            onRefresh: () async {
              final user = context.read<AuthProvider>().currentUser;
              if (user != null) await provider.loadFBSRecords(user.id);
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

  Widget _buildSummaryCard(List<FastingBloodSugar> records, bool isDark) {
    final latest = records.first;
    final avg =
        records.map((r) => r.fbsLevel).reduce((a, b) => a + b) / records.length;

    String status = 'Normal';
    Color statusColor = AppColors.success;
    if (latest.fbsLevel >= 126) {
      status = 'Diabetic';
      statusColor = AppColors.error;
    } else if (latest.fbsLevel >= 100) {
      status = 'Pre-diabetic';
      statusColor = AppColors.warning;
    }

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
                  color: AppColors.bloodSugar.withOpacity(0.15),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: Icon(
                  Icons.water_drop_rounded,
                  color: AppColors.bloodSugar,
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
                      '${latest.fbsLevel.toStringAsFixed(0)} mg/dL',
                      style: AppTypography.headline2,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
                child: Text(
                  status,
                  style: AppTypography.label2.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _buildStatItem(
                'Average',
                '${avg.toStringAsFixed(0)} mg/dL',
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
            style: AppTypography.title3.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }

  Widget _buildChartSection(List<FastingBloodSugar> records, bool isDark) {
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
                maxY: 250,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) {
                    final isReference = [100, 126].contains(value.toInt());
                    return FlLine(
                      color: isReference
                          ? (value == 100 ? AppColors.warning : AppColors.error)
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
                      reservedSize: 50,
                      interval: 25,
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
                        final date = DateFormat(
                          'MMM dd, yyyy',
                        ).format(DateTime.parse(record.testDate));
                        final fbsLevel = record.fbsLevel.toStringAsFixed(0);
                        String status = 'Normal';
                        if (record.fbsLevel >= 126) {
                          status = 'Diabetic';
                        } else if (record.fbsLevel >= 100) {
                          status = 'Pre-diabetic';
                        }

                        return LineTooltipItem(
                          'FBS: $fbsLevel mg/dL\nStatus: $status\n$date',
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
                        .map((e) => FlSpot(e.key.toDouble(), e.value.fbsLevel))
                        .toList(),
                    isCurved: true,
                    color: AppColors.bloodSugar,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.bloodSugar.withOpacity(0.1),
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
    FastingBloodSugar record,
    bool isDark,
    HealthRecordsProvider provider,
  ) {
    Color statusColor = AppColors.success;
    String status = 'Normal';
    if (record.fbsLevel >= 126) {
      statusColor = AppColors.error;
      status = 'Diabetic';
    } else if (record.fbsLevel >= 100) {
      statusColor = AppColors.warning;
      status = 'Pre-diabetic';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border(left: BorderSide(color: statusColor, width: 4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record.fbsLevel.toStringAsFixed(0)} mg/dL',
                  style: AppTypography.title2,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  DateFormat(
                    'MMM dd, yyyy',
                  ).format(DateTime.parse(record.testDate)),
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: AppSpacing.borderRadiusFull,
            ),
            child: Text(
              status,
              style: AppTypography.label2.copyWith(color: statusColor),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Record'),
                    content: const Text('Are you sure?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(
                          'Delete',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) await provider.deleteFBSRecord(record.id);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }
}
