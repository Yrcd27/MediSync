import 'app_logger.dart';

/// Centralized exception handler for the application
class ExceptionHandler {
  ExceptionHandler._();

  /// Extract a clean error message from any exception
  static String getMessage(dynamic exception) {
    if (exception is Exception) {
      return exception.toString().replaceAll('Exception: ', '');
    }
    return exception.toString();
  }

  /// Log an error with context
  static void log(String context, dynamic error, [StackTrace? stackTrace]) {
    AppLogger.error(
      'Error in $context',
      tag: 'ExceptionHandler',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Handle and log an exception, returning a user-friendly message
  static String handle(
    String context,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    log(context, error, stackTrace);
    return getMessage(error);
  }
}
