import '../models/full_blood_count.dart';
import '../core/services/api_service.dart';

class FullBloodCountService {
  final ApiService _apiService = ApiService();

  Future<List<FullBloodCount>> getRecordsByUserId(int userId) async {
    try {
      final response = await _apiService
          .get('/fbc/getFullBloodCountRecordsByUserId/$userId');
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data.map((json) => FullBloodCount.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch FBC records: $e');
    }
  }

  Future<FullBloodCount> addRecord(FullBloodCount record, int userId) async {
    try {
      final response = await _apiService.post(
          '/fbc/addFullBloodCountRecord', record.toCreateJson(userId));
      final data = _apiService.handleResponse(response);
      return FullBloodCount.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add FBC record: $e');
    }
  }

  Future<FullBloodCount> updateRecord(FullBloodCount record) async {
    try {
      final response = await _apiService.put(
          '/fbc/updateFullBloodCountRecord', record.toJson());
      final data = _apiService.handleResponse(response);
      return FullBloodCount.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update FBC record: $e');
    }
  }

  Future<void> deleteRecord(int recordId) async {
    try {
      await _apiService.delete('/fbc/deleteFullBloodCountRecord/$recordId');
    } catch (e) {
      throw Exception('Failed to delete FBC record: $e');
    }
  }
}
