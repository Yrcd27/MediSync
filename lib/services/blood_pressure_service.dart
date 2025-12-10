import '../models/blood_pressure.dart';
import '../core/services/api_service.dart';

class BloodPressureService {
  final ApiService _apiService = ApiService();

  Future<List<BloodPressure>> getRecordsByUserId(int userId) async {
    try {
      final response =
          await _apiService.get('/bp/getBloodPressureRecordsByUserId/$userId');
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data.map((json) => BloodPressure.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch BP records: $e');
    }
  }

  Future<BloodPressure> addRecord(BloodPressure record, int userId) async {
    try {
      final response = await _apiService.post(
          '/bp/addBloodPressureRecord', record.toCreateJson(userId));
      final data = _apiService.handleResponse(response);
      return BloodPressure.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add BP record: $e');
    }
  }

  Future<BloodPressure> updateRecord(BloodPressure record) async {
    try {
      final response = await _apiService.put(
          '/bp/updateBloodPressureRecord', record.toJson());
      final data = _apiService.handleResponse(response);
      return BloodPressure.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update BP record: $e');
    }
  }
}
