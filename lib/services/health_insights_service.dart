import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service for managing health insights and alerts
/// Provides persistence for insights, dismissed alerts, and health trends
class HealthInsightsService {
  static const String _insightsKey = 'health_insights';
  static const String _dismissedAlertsKey = 'dismissed_alerts';
  static const String _trendsKey = 'health_trends';

  /// Store a new health insight
  ///
  /// [userId] - The user's ID
  /// [metricType] - Type of metric (e.g., 'blood_pressure', 'blood_sugar')
  /// [status] - Current status of the metric ('normal', 'high', 'low', 'abnormal')
  /// [message] - Insight message
  /// [recommendation] - Health recommendation
  Future<void> storeInsight({
    required String userId,
    required String metricType,
    required String status,
    required String message,
    required String recommendation,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final insights = await _getInsights(userId);

    final insight = {
      'metricType': metricType,
      'status': status,
      'message': message,
      'recommendation': recommendation,
      'timestamp': DateTime.now().toIso8601String(),
    };

    insights.add(insight);

    // Keep only last 50 insights to avoid too much storage
    if (insights.length > 50) {
      insights.removeRange(0, insights.length - 50);
    }

    await prefs.setString('${_insightsKey}_$userId', json.encode(insights));
  }

  /// Get all insights for a user
  ///
  /// [userId] - The user's ID
  /// [limit] - Maximum number of insights to return (default: 10)
  Future<List<Map<String, dynamic>>> getInsights(
    String userId, {
    int limit = 10,
  }) async {
    final insights = await _getInsights(userId);

    // Sort by timestamp (most recent first)
    insights.sort((a, b) {
      final timeA = DateTime.parse(a['timestamp'] as String);
      final timeB = DateTime.parse(b['timestamp'] as String);
      return timeB.compareTo(timeA);
    });

    return insights.take(limit).toList();
  }

  /// Get insights for a specific metric type
  ///
  /// [userId] - The user's ID
  /// [metricType] - Type of metric to filter by
  /// [limit] - Maximum number of insights to return (default: 5)
  Future<List<Map<String, dynamic>>> getInsightsByMetric(
    String userId,
    String metricType, {
    int limit = 5,
  }) async {
    final insights = await _getInsights(userId);

    final filtered = insights
        .where((insight) => insight['metricType'] == metricType)
        .toList();

    // Sort by timestamp (most recent first)
    filtered.sort((a, b) {
      final timeA = DateTime.parse(a['timestamp'] as String);
      final timeB = DateTime.parse(b['timestamp'] as String);
      return timeB.compareTo(timeA);
    });

    return filtered.take(limit).toList();
  }

  /// Dismiss an alert
  ///
  /// [userId] - The user's ID
  /// [alertId] - Unique identifier for the alert
  Future<void> dismissAlert(String userId, String alertId) async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = await _getDismissedAlerts(userId);

    dismissed.add({
      'alertId': alertId,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await prefs.setString(
      '${_dismissedAlertsKey}_$userId',
      json.encode(dismissed),
    );
  }

  /// Check if an alert has been dismissed
  ///
  /// [userId] - The user's ID
  /// [alertId] - Unique identifier for the alert
  /// [withinHours] - Check if dismissed within the last N hours (default: 24)
  Future<bool> isAlertDismissed(
    String userId,
    String alertId, {
    int withinHours = 24,
  }) async {
    final dismissed = await _getDismissedAlerts(userId);
    final cutoffTime = DateTime.now().subtract(Duration(hours: withinHours));

    for (final alert in dismissed) {
      if (alert['alertId'] == alertId) {
        final timestamp = DateTime.parse(alert['timestamp'] as String);
        if (timestamp.isAfter(cutoffTime)) {
          return true;
        }
      }
    }

    return false;
  }

  /// Track health trend for a metric
  ///
  /// [userId] - The user's ID
  /// [metricType] - Type of metric
  /// [value] - Current metric value
  /// [status] - Current status
  Future<void> trackTrend({
    required String userId,
    required String metricType,
    required double value,
    required String status,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final trends = await _getTrends(userId);

    final trendKey = metricType;
    if (!trends.containsKey(trendKey)) {
      trends[trendKey] = [];
    }

    final dataPoint = {
      'value': value,
      'status': status,
      'timestamp': DateTime.now().toIso8601String(),
    };

    trends[trendKey]!.add(dataPoint);

    // Keep only last 30 data points per metric
    if (trends[trendKey]!.length > 30) {
      trends[trendKey] = trends[trendKey]!.sublist(
        trends[trendKey]!.length - 30,
      );
    }

    await prefs.setString('${_trendsKey}_$userId', json.encode(trends));
  }

  /// Get trend analysis for a metric
  ///
  /// [userId] - The user's ID
  /// [metricType] - Type of metric
  /// Returns a map with 'improving', 'stable', or 'worsening' trend
  Future<Map<String, dynamic>?> getTrendAnalysis(
    String userId,
    String metricType,
  ) async {
    final trends = await _getTrends(userId);
    final metricTrend = trends[metricType];

    if (metricTrend == null || metricTrend.length < 3) {
      return null; // Not enough data
    }

    // Sort by timestamp
    metricTrend.sort((a, b) {
      final timeA = DateTime.parse(a['timestamp'] as String);
      final timeB = DateTime.parse(b['timestamp'] as String);
      return timeA.compareTo(timeB);
    });

    // Analyze last 3 readings
    final recent = metricTrend.sublist(
      metricTrend.length > 3 ? metricTrend.length - 3 : 0,
    );

    final statusPriority = {'normal': 0, 'low': 1, 'high': 2, 'abnormal': 3};

    int improvingCount = 0;
    int worseningCount = 0;

    for (int i = 1; i < recent.length; i++) {
      final prevStatus = recent[i - 1]['status'] as String;
      final currStatus = recent[i]['status'] as String;

      final prevPriority = statusPriority[prevStatus] ?? 1;
      final currPriority = statusPriority[currStatus] ?? 1;

      if (currPriority < prevPriority) {
        improvingCount++;
      } else if (currPriority > prevPriority) {
        worseningCount++;
      }
    }

    String trend;
    if (improvingCount > worseningCount) {
      trend = 'improving';
    } else if (worseningCount > improvingCount) {
      trend = 'worsening';
    } else {
      trend = 'stable';
    }

    return {
      'trend': trend,
      'dataPoints': recent.length,
      'latestValue': recent.last['value'],
      'latestStatus': recent.last['status'],
    };
  }

  /// Clear all insights for a user
  Future<void> clearInsights(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_insightsKey}_$userId');
  }

  /// Clear dismissed alerts older than specified days
  Future<void> clearOldDismissedAlerts(String userId, {int days = 7}) async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = await _getDismissedAlerts(userId);
    final cutoffTime = DateTime.now().subtract(Duration(days: days));

    final recent = dismissed.where((alert) {
      final timestamp = DateTime.parse(alert['timestamp'] as String);
      return timestamp.isAfter(cutoffTime);
    }).toList();

    await prefs.setString(
      '${_dismissedAlertsKey}_$userId',
      json.encode(recent),
    );
  }

  // Private helper methods

  Future<List<Map<String, dynamic>>> _getInsights(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final insightsJson = prefs.getString('${_insightsKey}_$userId');

    if (insightsJson == null) {
      return [];
    }

    final List<dynamic> decoded = json.decode(insightsJson);
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> _getDismissedAlerts(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final alertsJson = prefs.getString('${_dismissedAlertsKey}_$userId');

    if (alertsJson == null) {
      return [];
    }

    final List<dynamic> decoded = json.decode(alertsJson);
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<Map<String, List<Map<String, dynamic>>>> _getTrends(
    String userId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final trendsJson = prefs.getString('${_trendsKey}_$userId');

    if (trendsJson == null) {
      return {};
    }

    final Map<String, dynamic> decoded = json.decode(trendsJson);
    final Map<String, List<Map<String, dynamic>>> trends = {};

    decoded.forEach((key, value) {
      trends[key] = (value as List).cast<Map<String, dynamic>>();
    });

    return trends;
  }
}
