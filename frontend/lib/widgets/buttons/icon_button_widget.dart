import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  final String? tooltip;

  const IconButtonWidget({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: size ?? AppSpacing.iconLg + AppSpacing.md,
      height: size ?? AppSpacing.iconLg + AppSpacing.md,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: iconColor ?? AppColors.textPrimary,
          size: (size ?? AppSpacing.iconLg) - AppSpacing.sm,
        ),
        padding: EdgeInsets.zero,
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
