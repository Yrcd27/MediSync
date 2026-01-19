import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

enum SnackBarType { success, error, info, warning }

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final colorMap = {
      SnackBarType.success: AppColors.success,
      SnackBarType.error: AppColors.error,
      SnackBarType.info: AppColors.info,
      SnackBarType.warning: AppColors.warning,
    };

    final iconMap = {
      SnackBarType.success: Icons.check_circle_outline,
      SnackBarType.error: Icons.error_outline,
      SnackBarType.info: Icons.info_outline,
      SnackBarType.warning: Icons.warning_amber_outlined,
    };

    final color = colorMap[type]!;
    final icon = iconMap[type]!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                style: AppTypography.body2.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
        action: onAction != null && actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
        duration: duration,
      ),
    );
  }
}
