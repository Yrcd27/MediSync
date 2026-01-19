import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

class ReportCard extends StatelessWidget {
  final String title;
  final String date;
  final String? description;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ReportCard({
    super.key,
    required this.title,
    required this.date,
    this.description,
    required this.icon,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSpacing.elevationSm,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusMd,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      date,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description!,
                        style: AppTypography.body2.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.error,
                  iconSize: AppSpacing.iconSm,
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
