import '../models/fasting_blood_sugar.dart';
import '../core/services/api_service.dart';

class FastingBloodSugarService {
  final ApiService _apiService = ApiService();

  Future<List<FastingBloodSugar>> getRecordsByUserId(int userId) async {
    try {
      final response = await _apiService
          .get('/fbs/getFastingBloodSugarRecordsByUserId/$userId');
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data.map((json) => FastingBloodSugar.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch FBS records: $e');
    }
  }

  Future<FastingBloodSugar> addRecord(
      FastingBloodSugar record, int userId) async {
    try {
      final response = await _apiService.post(
          '/fbs/addFastingBloodSugarRecord', record.toCreateJson(userId));
      final data = _apiService.handleResponse(response);
      return FastingBloodSugar.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add FBS record: $e');
    }
  }

  Future<FastingBloodSugar> updateRecord(FastingBloodSugar record) async {
    try {
      final response = await _apiService.put(
          '/fbs/updateFastingBloodSugarRecord', record.toJson());
      final data = _apiService.handleResponse(response);
      return FastingBloodSugar.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update FBS record: $e');
    }
  }
}
