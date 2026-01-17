import '../models/fasting_blood_sugar.dart';
import '../core/services/api_service.dart';
import '../core/config/app_config.dart';

/// Service for Fasting Blood Sugar records API operations
class FastingBloodSugarService {
  final ApiService _apiService = ApiService();

  /// Get all FBS records for a user
  Future<List<FastingBloodSugar>> getRecordsByUserId(int userId) async {
    try {
      final response = await _apiService.get(AppConfig.getFBSRecordsByUserId(userId));
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data.map((json) => FastingBloodSugar.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add a new FBS record
  Future<FastingBloodSugar> addRecord(FastingBloodSugar record, int userId) async {
    try {
      final response = await _apiService.post(
        AppConfig.addFBSRecord,
        record.toCreateJson(userId),
      );
      final data = _apiService.handleResponse(response);
      return FastingBloodSugar.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add FBS record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }

  /// Update an existing FBS record
  Future<FastingBloodSugar> updateRecord(FastingBloodSugar record) async {
    try {
      final response = await _apiService.put(
        AppConfig.updateFBSRecord,
        record.toUpdateJson(),
      );
      final data = _apiService.handleResponse(response);
      return FastingBloodSugar.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update FBS record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }

  /// Delete an FBS record
  Future<void> deleteRecord(int recordId) async {
    try {
      await _apiService.delete(AppConfig.deleteFBSRecord(recordId));
    } catch (e) {
      throw Exception('Failed to delete FBS record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }
}
