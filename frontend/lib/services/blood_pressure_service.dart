import '../models/blood_pressure.dart';
import '../core/services/api_service.dart';
import '../core/config/app_config.dart';
import '../core/utils/app_logger.dart';
import '../core/utils/exception_handler.dart';

/// Service for Blood Pressure records API operations
class BloodPressureService {
  final ApiService _apiService = ApiService();

  /// Get all blood pressure records for a user
  Future<List<BloodPressure>> getRecordsByUserId(int userId) async {
    try {
      final response = await _apiService.get(
        AppConfig.getBPRecordsByUserId(userId),
      );
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data
          .map((json) => BloodPressure.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to fetch blood pressure records',
        tag: 'BPService',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Add a new blood pressure record
  Future<BloodPressure> addRecord(BloodPressure record, int userId) async {
    try {
      final response = await _apiService.post(
        AppConfig.addBPRecord,
        record.toCreateJson(userId),
      );
      final data = _apiService.handleResponse(response);
      return BloodPressure.fromJson(data);
    } catch (e, stackTrace) {
      ExceptionHandler.log('addRecord (BloodPressure)', e, stackTrace);
      throw Exception(ExceptionHandler.getMessage(e));
    }
  }

  /// Update an existing blood pressure record
  Future<BloodPressure> updateRecord(BloodPressure record) async {
    try {
      final response = await _apiService.put(
        AppConfig.updateBPRecord,
        record.toUpdateJson(),
      );
      final data = _apiService.handleResponse(response);
      return BloodPressure.fromJson(data);
    } catch (e, stackTrace) {
      ExceptionHandler.log('updateRecord (BloodPressure)', e, stackTrace);
      throw Exception(ExceptionHandler.getMessage(e));
    }
  }

  /// Delete a blood pressure record
  Future<void> deleteRecord(int recordId) async {
    try {
      await _apiService.delete(AppConfig.deleteBPRecord(recordId));
    } catch (e, stackTrace) {
      ExceptionHandler.log('deleteRecord (BloodPressure)', e, stackTrace);
      throw Exception(ExceptionHandler.getMessage(e));
    }
  }
}
