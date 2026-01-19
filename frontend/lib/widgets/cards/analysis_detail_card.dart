import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../utils/health_analysis.dart' as health;

class AnalysisDetailCard extends StatelessWidget {
  final health.HealthResult analysis;
  final String metricName;
  final String value;
  final String unit;

  const AnalysisDetailCard({
    super.key,
    required this.analysis,
    required this.metricName,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: analysis.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: analysis.color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: analysis.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  _getStatusIcon(analysis.status),
                  color: analysis.color,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metricName,
                      style: AppTypography.label1.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            value,
                            style: AppTypography.headline2.copyWith(
                              color: analysis.color,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              unit,
                              style: AppTypography.body2.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
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
                  color: analysis.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Text(
                  analysis.statusText,
                  style: AppTypography.labelSmall.copyWith(
                    color: analysis.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 18,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    analysis.recommendation,
                    style: AppTypography.body2.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(health.HealthStatus status) {
    switch (status) {
      case health.HealthStatus.normal:
        return Icons.check_circle_rounded;
      case health.HealthStatus.low:
        return Icons.arrow_downward_rounded;
      case health.HealthStatus.high:
        return Icons.arrow_upward_rounded;
      case health.HealthStatus.abnormal:
        return Icons.warning_rounded;
    }
  }
}
