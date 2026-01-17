import '../models/liver_profile.dart';
import '../core/services/api_service.dart';
import '../core/config/app_config.dart';

/// Service for Liver Profile records API operations
class LiverProfileService {
  final ApiService _apiService = ApiService();

  /// Get all Liver Profile records for a user
  Future<List<LiverProfile>> getRecordsByUserId(int userId) async {
    try {
      final response = await _apiService.get(AppConfig.getLiverRecordsByUserId(userId));
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data.map((json) => LiverProfile.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add a new Liver Profile record
  Future<LiverProfile> addRecord(LiverProfile record, int userId) async {
    try {
      final response = await _apiService.post(
        AppConfig.addLiverRecord,
        record.toCreateJson(userId),
      );
      final data = _apiService.handleResponse(response);
      return LiverProfile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add Liver Profile record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }

  /// Update an existing Liver Profile record
  Future<LiverProfile> updateRecord(LiverProfile record) async {
    try {
      final response = await _apiService.put(
        AppConfig.updateLiverRecord,
        record.toUpdateJson(),
      );
      final data = _apiService.handleResponse(response);
      return LiverProfile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update Liver Profile record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }

  /// Delete a Liver Profile record
  Future<void> deleteRecord(int recordId) async {
    try {
      await _apiService.delete(AppConfig.deleteLiverRecord(recordId));
    } catch (e) {
      throw Exception('Failed to delete Liver Profile record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }
}
