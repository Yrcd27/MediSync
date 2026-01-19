import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../constants/app_spacing.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryLight,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
        outline: AppColors.border,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTypography.title1,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: AppSpacing.iconMd,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: AppSpacing.elevationSm,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeightMd),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          elevation: 0,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeightMd),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.buttonMedium,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTypography.label1,
        hintStyle: AppTypography.body2.copyWith(color: AppColors.textTertiary),
        errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        labelStyle: AppTypography.label2,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
        elevation: 8,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
        titleTextStyle: AppTypography.title1,
        contentTextStyle: AppTypography.body1,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTypography.body2.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusSm),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTypography.label1,
        unselectedLabelStyle: AppTypography.label1,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: AppSpacing.iconMd,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.headline1,
        displayMedium: AppTypography.headline2,
        displaySmall: AppTypography.headline3,
        headlineLarge: AppTypography.headline1,
        headlineMedium: AppTypography.headline2,
        headlineSmall: AppTypography.headline3,
        titleLarge: AppTypography.title1,
        titleMedium: AppTypography.title2,
        titleSmall: AppTypography.title3,
        bodyLarge: AppTypography.body1,
        bodyMedium: AppTypography.body2,
        labelLarge: AppTypography.label1,
        labelMedium: AppTypography.label2,
        labelSmall: AppTypography.caption,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.darkBackground,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        primaryContainer: AppColors.primary,
        secondary: AppColors.secondaryLight,
        secondaryContainer: AppColors.secondary,
        surface: AppColors.darkSurface,
        error: AppColors.error,
        onPrimary: AppColors.darkBackground,
        onSecondary: AppColors.darkBackground,
        onSurface: AppColors.darkTextPrimary,
        onError: Colors.white,
        outline: AppColors.darkBorder,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTypography.title1.copyWith(
          color: AppColors.darkTextPrimary,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: AppSpacing.elevationSm,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        labelStyle: AppTypography.label1.copyWith(
          color: AppColors.darkTextSecondary,
        ),
        hintStyle: AppTypography.body2.copyWith(
          color: AppColors.darkTextSecondary,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      textTheme: TextTheme(
        displayLarge: AppTypography.headline1.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        displayMedium: AppTypography.headline2.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        displaySmall: AppTypography.headline3.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        titleLarge: AppTypography.title1.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        titleMedium: AppTypography.title2.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        titleSmall: AppTypography.title3.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        bodyLarge: AppTypography.body1.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        bodyMedium: AppTypography.body2.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        labelLarge: AppTypography.label1.copyWith(
          color: AppColors.darkTextSecondary,
        ),
        labelMedium: AppTypography.label2.copyWith(
          color: AppColors.darkTextSecondary,
        ),
      ),
    );
  }
}
