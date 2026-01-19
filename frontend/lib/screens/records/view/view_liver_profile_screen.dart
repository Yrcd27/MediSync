import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/health_records_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/liver_profile.dart';
import '../../../widgets/feedback/empty_state.dart';
import '../../../utils/health_analysis.dart' as health;
import '../add/add_liver_profile_screen.dart';

class ViewLiverProfileScreen extends StatelessWidget {
  const ViewLiverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text('Liver Profile', style: AppTypography.title1),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddLiverProfileScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<HealthRecordsProvider>(
        builder: (context, provider, _) {
          final records = provider.liverRecords;

          if (records.isEmpty) {
            return EmptyState(
              icon: Icons.local_hospital_rounded,
              message: 'No Liver Profile Records',
              description: 'Start tracking your liver function tests',
              actionLabel: 'Add Record',
              onAction: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddLiverProfileScreen(),
                ),
              ),
            );
          }

          // Data is already sorted by provider (newest first)
          return RefreshIndicator(
            onRefresh: () async {
              final user = context.read<AuthProvider>().currentUser;
              if (user != null) await provider.loadLiverRecords(user.id);
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

  Widget _buildSummaryCard(List<LiverProfile> records, bool isDark) {
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
                  color: AppColors.liverProfile.withOpacity(0.15),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: Icon(
                  Icons.local_hospital_rounded,
                  color: AppColors.liverProfile,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SGPT (ALT)', style: AppTypography.label1),
                    Text(
                      '${latest.sgpt.toStringAsFixed(0)} U/L',
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
                'Protein',
                latest.proteinTotalSerum.toStringAsFixed(1),
                isDark,
              ),
              _buildStatItem(
                'Albumin',
                latest.albuminSerum.toStringAsFixed(1),
                isDark,
              ),
              _buildStatItem(
                'Bilirubin',
                latest.bilirubinTotalSerum.toStringAsFixed(1),
                isDark,
              ),
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

  Widget _buildChartSection(List<LiverProfile> records, bool isDark) {
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
          Text('Liver Enzyme Trends', style: AppTypography.title3),
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
                      reservedSize: 45,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: AppTypography.caption.copyWith(fontSize: 11),
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
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (chartRecords.length - 1).toDouble(),
                minY: 0,
                maxY: 120,
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
                            'SGPT (ALT): ${record.sgpt.toStringAsFixed(0)} U/L';
                        final statusData = health.HealthAnalysis.getSGPTStatus(
                          record.sgpt,
                        );
                        status = statusData['status'] as String;
                        lineColor = AppColors.liverProfile;

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
                        .map((e) => FlSpot(e.key.toDouble(), e.value.sgpt))
                        .toList(),
                    isCurved: true,
                    color: AppColors.liverProfile,
                    barWidth: 3,
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
                ],
              ),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildLegendItem('SGPT (ALT)', AppColors.liverProfile)],
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
    LiverProfile record,
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
          left: BorderSide(color: AppColors.liverProfile, width: 4),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SGPT: ${record.sgpt.toStringAsFixed(0)} U/L',
                  style: AppTypography.title3,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Protein: ${record.proteinTotalSerum.toStringAsFixed(1)} | Bilirubin: ${record.bilirubinTotalSerum.toStringAsFixed(1)}',
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
