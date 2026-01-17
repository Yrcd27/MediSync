import '../models/blood_pressure.dart';
import '../core/services/api_service.dart';
import '../core/config/app_config.dart';

/// Service for Blood Pressure records API operations
class BloodPressureService {
  final ApiService _apiService = ApiService();

  /// Get all blood pressure records for a user
  Future<List<BloodPressure>> getRecordsByUserId(int userId) async {
    try {
      final response = await _apiService.get(AppConfig.getBPRecordsByUserId(userId));
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data.map((json) => BloodPressure.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      // Return empty list if no records found
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
    } catch (e) {
      throw Exception('Failed to add blood pressure record: ${e.toString().replaceAll("Exception: ", "")}');
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
    } catch (e) {
      throw Exception('Failed to update blood pressure record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }

  /// Delete a blood pressure record
  Future<void> deleteRecord(int recordId) async {
    try {
      await _apiService.delete(AppConfig.deleteBPRecord(recordId));
    } catch (e) {
      throw Exception('Failed to delete blood pressure record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }

  /// Get a single blood pressure record by ID
  Future<BloodPressure> getRecordById(int recordId) async {
    try {
      final response = await _apiService.get(AppConfig.getBPRecord(recordId));
      final data = _apiService.handleResponse(response);
      return BloodPressure.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch blood pressure record: ${e.toString().replaceAll("Exception: ", "")}');
    }
  }
}
