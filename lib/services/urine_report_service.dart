import '../models/urine_report.dart';
import '../core/services/api_service.dart';
import '../core/config/app_config.dart';

/// Service for Urine Report records API operations
class UrineReportService {
  final ApiService _apiService = ApiService();

  /// Get all Urine Report records for a user
  Future<List<UrineReport>> getRecordsByUserId(int userId) async {
    try {
      final response = await _apiService.get(AppConfig.getUrineRecordsByUserId(userId));
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data.map((json) => UrineReport.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add a new Urine Report record
  Future<UrineReport> addRecord(UrineReport record, int userId) async {
    try {
      final response = await _apiService.post(
        AppConfig.addUrineRecord,
        record.toCreateJson(userId),
      );
      final data = _apiService.handleResponse(response);
      return UrineReport.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add Urine Report record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }

  /// Update an existing Urine Report record
  Future<UrineReport> updateRecord(UrineReport record) async {
    try {
      final response = await _apiService.put(
        AppConfig.updateUrineRecord,
        record.toUpdateJson(),
      );
      final data = _apiService.handleResponse(response);
      return UrineReport.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update Urine Report record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }

  /// Delete a Urine Report record
  Future<void> deleteRecord(int recordId) async {
    try {
      await _apiService.delete(AppConfig.deleteUrineRecord(recordId));
    } catch (e) {
      throw Exception('Failed to delete Urine Report record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }
}
