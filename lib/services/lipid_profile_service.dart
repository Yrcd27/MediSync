import '../models/lipid_profile.dart';
import '../core/services/api_service.dart';
import '../core/config/app_config.dart';
import '../core/utils/app_logger.dart';
import '../core/utils/exception_handler.dart';

/// Service for Lipid Profile records API operations
class LipidProfileService {
  final ApiService _apiService = ApiService();

  /// Get all Lipid Profile records for a user
  Future<List<LipidProfile>> getRecordsByUserId(int userId) async {
    try {
      final response = await _apiService.get(
        AppConfig.getLipidRecordsByUserId(userId),
      );
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data
          .map((json) => LipidProfile.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch Lipid Profile records',
        tag: 'LipidService',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Add a new Lipid Profile record
  Future<LipidProfile> addRecord(LipidProfile record, int userId) async {
    try {
      final response = await _apiService.post(
        AppConfig.addLipidRecord,
        record.toCreateJson(userId),
      );
      final data = _apiService.handleResponse(response);
      return LipidProfile.fromJson(data);
    } catch (e, stackTrace) {
      ExceptionHandler.log('add (Lipid Profile)', e, stackTrace);
      throw Exception(ExceptionHandler.getMessage(e));
    }
  }

  /// Update an existing Lipid Profile record
  Future<LipidProfile> updateRecord(LipidProfile record) async {
    try {
      final response = await _apiService.put(
        AppConfig.updateLipidRecord,
        record.toUpdateJson(),
      );
      final data = _apiService.handleResponse(response);
      return LipidProfile.fromJson(data);
    } catch (e, stackTrace) {
      ExceptionHandler.log('update (Lipid Profile)', e, stackTrace);
      throw Exception(ExceptionHandler.getMessage(e));
    }
  }

  /// Delete a Lipid Profile record
  Future<void> deleteRecord(int recordId) async {
    try {
      await _apiService.delete(AppConfig.deleteLipidRecord(recordId));
    } catch (e, stackTrace) {
      ExceptionHandler.log('delete (Lipid Profile)', e, stackTrace);
      throw Exception(ExceptionHandler.getMessage(e));
    }
  }
}
