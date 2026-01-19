import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF2D7DD2);
  static const Color primaryLight = Color(0xFF5BA4E8);
  static const Color primaryDark = Color(0xFF1A5A9E);

  // Secondary Colors
  static const Color secondary = Color(0xFF45B7D1);
  static const Color secondaryLight = Color(0xFF7DD3E8);
  static const Color secondaryDark = Color(0xFF2A8FA8);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);

  // Health Metric Colors
  static const Color bloodPressure = Color(0xFFE91E63);
  static const Color bloodSugar = Color(0xFFFF5722);
  static const Color bloodCount = Color(0xFF9C27B0);
  static const Color lipidProfile = Color(0xFF4CAF50);
  static const Color liverProfile = Color(0xFFFFB300);
  static const Color urineReport = Color(0xFF00BCD4);

  // Neutral Colors - Light Mode
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Neutral Colors - Dark Mode
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF2D2D44);
  static const Color darkSurfaceVariant = Color(0xFF3D3D5C);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF4B5563);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );

  // Health Status Colors
  static Color getHealthStatusColor(HealthStatus status) {
    switch (status) {
      case HealthStatus.normal:
        return success;
      case HealthStatus.warning:
        return warning;
      case HealthStatus.critical:
        return error;
      case HealthStatus.low:
        return info;
    }
  }
}

enum HealthStatus { normal, warning, critical, low }
