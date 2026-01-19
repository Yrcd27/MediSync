import '../models/fasting_blood_sugar.dart';
import '../models/user.dart';
import '../core/services/api_service.dart';
import '../core/config/app_config.dart';
import '../core/utils/app_logger.dart';
import '../core/utils/exception_handler.dart';

/// Service for Fasting Blood Sugar records API operations
class FastingBloodSugarService {
  final ApiService _apiService = ApiService();

  /// Get all FBS records for a user
  Future<List<FastingBloodSugar>> getRecordsByUserId(int userId) async {
    try {
      final response = await _apiService.get(
        AppConfig.getFBSRecordsByUserId(userId),
      );
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data
          .map(
            (json) => FastingBloodSugar.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch FBS records',
        tag: 'FBSService',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Add a new FBS record
  Future<FastingBloodSugar> addRecord(
    FastingBloodSugar record,
    User user,
  ) async {
    try {
      final response = await _apiService.post(
        AppConfig.addFBSRecord,
        record.toCreateJson(user),
      );
      final data = _apiService.handleResponse(response);
      return FastingBloodSugar.fromJson(data);
    } catch (e, stackTrace) {
      ExceptionHandler.log('addRecord (FBS)', e, stackTrace);
      throw Exception(ExceptionHandler.getMessage(e));
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
    } catch (e, stackTrace) {
      ExceptionHandler.log('updateRecord (FBS)', e, stackTrace);
      throw Exception(ExceptionHandler.getMessage(e));
    }
  }

  /// Delete an FBS record
  Future<void> deleteRecord(int recordId) async {
    try {
      await _apiService.delete(AppConfig.deleteFBSRecord(recordId));
    } catch (e, stackTrace) {
      ExceptionHandler.log('deleteRecord (FBS)', e, stackTrace);
      throw Exception(ExceptionHandler.getMessage(e));
    }
  }
}
