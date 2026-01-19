import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onActionPressed;
  final String? actionLabel;
  final IconData? actionIcon;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onActionPressed,
    this.actionLabel,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.title2),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: AppTypography.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onActionPressed != null) ...[
            const SizedBox(width: AppSpacing.md),
            InkWell(
              onTap: onActionPressed,
              borderRadius: AppSpacing.borderRadiusSm,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (actionLabel != null) ...[
                      Text(
                        actionLabel!,
                        style: AppTypography.label2.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (actionIcon != null)
                        const SizedBox(width: AppSpacing.xs),
                    ],
                    if (actionIcon != null)
                      Icon(
                        actionIcon,
                        color: AppColors.primary,
                        size: AppSpacing.iconSm,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
