import '../models/full_blood_count.dart';
import '../core/services/api_service.dart';
import '../core/config/app_config.dart';

/// Service for Full Blood Count records API operations
class FullBloodCountService {
  final ApiService _apiService = ApiService();

  /// Get all FBC records for a user
  Future<List<FullBloodCount>> getRecordsByUserId(int userId) async {
    try {
      final response = await _apiService.get(AppConfig.getFBCRecordsByUserId(userId));
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data.map((json) => FullBloodCount.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add a new FBC record
  Future<FullBloodCount> addRecord(FullBloodCount record, int userId) async {
    try {
      final response = await _apiService.post(
        AppConfig.addFBCRecord,
        record.toCreateJson(userId),
      );
      final data = _apiService.handleResponse(response);
      return FullBloodCount.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add FBC record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }

  /// Update an existing FBC record
  Future<FullBloodCount> updateRecord(FullBloodCount record) async {
    try {
      final response = await _apiService.put(
        AppConfig.updateFBCRecord,
        record.toUpdateJson(),
      );
      final data = _apiService.handleResponse(response);
      return FullBloodCount.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update FBC record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }

  /// Delete an FBC record
  Future<void> deleteRecord(int recordId) async {
    try {
      await _apiService.delete(AppConfig.deleteFBCRecord(recordId));
    } catch (e) {
      throw Exception('Failed to delete FBC record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }
}
