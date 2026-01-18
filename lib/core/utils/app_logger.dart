import 'package:flutter/foundation.dart';

/// Simple logger utility for the application
/// Uses Flutter's debugPrint in debug mode, silenced in release mode
class AppLogger {
  AppLogger._();

  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('🔍 $prefix$message');
    }
  }

  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('ℹ️ $prefix$message');
    }
  }

  static void warning(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('⚠️ $prefix$message');
    }
  }

  static void error(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('❌ $prefix$message');
      if (error != null) {
        debugPrint('   Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('   Stack trace: $stackTrace');
      }
    }
  }

  static void success(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('✅ $prefix$message');
    }
  }
}
