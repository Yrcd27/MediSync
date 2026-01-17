import '../models/report.dart';
import '../core/services/api_service.dart';
import '../core/config/app_config.dart';

/// Service for aggregated Reports API operations
class ReportService {
  final ApiService _apiService = ApiService();

  /// Get all reports for a user (includes all linked test records)
  Future<List<Report>> getReportsByUserId(int userId) async {
    try {
      final response = await _apiService.get(AppConfig.getReportsByUserId(userId));
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data.map((json) => Report.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Delete a report
  Future<void> deleteReport(int reportId) async {
    try {
      await _apiService.delete(AppConfig.deleteReport(reportId));
    } catch (e) {
      throw Exception('Failed to delete report: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }
}
