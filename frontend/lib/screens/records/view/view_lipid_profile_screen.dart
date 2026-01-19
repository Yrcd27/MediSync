import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/health_records_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/lipid_profile.dart';
import '../../../widgets/feedback/empty_state.dart';
import '../../../utils/health_analysis.dart' as health;
import '../add/add_lipid_profile_screen.dart';

class ViewLipidProfileScreen extends StatelessWidget {
  const ViewLipidProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text('Lipid Profile', style: AppTypography.title1),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddLipidProfileScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<HealthRecordsProvider>(
        builder: (context, provider, _) {
          final records = provider.lipidRecords;

          if (records.isEmpty) {
            return EmptyState(
              icon: Icons.monitor_heart_rounded,
              message: 'No Lipid Profile Records',
              description: 'Start tracking your cholesterol levels',
              actionLabel: 'Add Record',
              onAction: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddLipidProfileScreen(),
                ),
              ),
            );
          }

          // Data is already sorted by provider (newest first)
          final user = context.read<AuthProvider>().currentUser;
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadLipidRecords(user.id);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(records, isDark),
                  const SizedBox(height: AppSpacing.xl),
                  _buildChartSection(records, user.gender, isDark),
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

  Widget _buildSummaryCard(List<LipidProfile> records, bool isDark) {
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
                  color: AppColors.lipidProfile.withOpacity(0.15),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: Icon(
                  Icons.monitor_heart_rounded,
                  color: AppColors.lipidProfile,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Cholesterol', style: AppTypography.label1),
                    Text(
                      '${latest.totalCholesterol.toStringAsFixed(0)} mg/dL',
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
                'HDL',
                latest.hdl.toStringAsFixed(0),
                AppColors.success,
                isDark,
              ),
              _buildStatItem(
                'LDL',
                latest.ldl.toStringAsFixed(0),
                AppColors.error,
                isDark,
              ),
              _buildStatItem(
                'TG',
                latest.triglycerides.toStringAsFixed(0),
                AppColors.warning,
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.title2.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }

  Widget _buildChartSection(
    List<LipidProfile> records,
    String userGender,
    bool isDark,
  ) {
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
          Text('Cholesterol Trends', style: AppTypography.title3),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 250,
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
                      reservedSize: 40,
                      interval: 50,
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
                maxY: 300,
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

                        if (spot.barIndex == 0) {
                          label =
                              'Total Cholesterol: ${record.totalCholesterol.toStringAsFixed(0)} mg/dL';
                          final statusData =
                              health.HealthAnalysis.getTotalCholesterolStatus(
                                record.totalCholesterol,
                              );
                          status = statusData['status'] as String;
                          lineColor = AppColors.lipidProfile;
                        } else if (spot.barIndex == 1) {
                          label = 'LDL: ${record.ldl.toStringAsFixed(0)} mg/dL';
                          final statusData = health.HealthAnalysis.getLDLStatus(
                            record.ldl,
                          );
                          status = statusData['status'] as String;
                          lineColor = AppColors.error;
                        } else {
                          label = 'HDL: ${record.hdl.toStringAsFixed(0)} mg/dL';
                          final statusData = health.HealthAnalysis.getHDLStatus(
                            record.hdl,
                            userGender,
                          );
                          status = statusData['status'] as String;
                          lineColor = AppColors.success;
                        }

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
                          (e) => FlSpot(
                            e.key.toDouble(),
                            e.value.totalCholesterol,
                          ),
                        )
                        .toList(),
                    isCurved: true,
                    color: AppColors.lipidProfile,
                    barWidth: 3,
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
                    spots: chartRecords
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value.ldl))
                        .toList(),
                    isCurved: true,
                    color: AppColors.error,
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: AppColors.error,
                          strokeWidth: 1.5,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                  ),
                  LineChartBarData(
                    spots: chartRecords
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value.hdl))
                        .toList(),
                    isCurved: true,
                    color: AppColors.success,
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: AppColors.success,
                          strokeWidth: 1.5,
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
            children: [
              _buildLegendItem('TC', AppColors.lipidProfile),
              const SizedBox(width: AppSpacing.lg),
              _buildLegendItem('LDL', AppColors.error),
              const SizedBox(width: AppSpacing.lg),
              _buildLegendItem('HDL', AppColors.success),
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
    LipidProfile record,
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
          left: BorderSide(color: AppColors.lipidProfile, width: 4),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TC: ${record.totalCholesterol.toStringAsFixed(0)} mg/dL',
                  style: AppTypography.title3,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'HDL: ${record.hdl.toStringAsFixed(0)} | LDL: ${record.ldl.toStringAsFixed(0)} | TG: ${record.triglycerides.toStringAsFixed(0)}',
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
