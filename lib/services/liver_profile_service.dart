import '../models/liver_profile.dart';
import '../core/services/api_service.dart';

class LiverProfileService {
  final ApiService _apiService = ApiService();

  Future<List<LiverProfile>> getRecordsByUserId(int userId) async {
    try {
      final response = await _apiService
          .get('/liver/getLiverProfileRecordsByUserId/$userId');
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data.map((json) => LiverProfile.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch Liver Profile records: $e');
    }
  }

  Future<LiverProfile> addRecord(LiverProfile record, int userId) async {
    try {
      final response = await _apiService.post(
          '/liver/addLiverProfileRecord', record.toCreateJson(userId));
      final data = _apiService.handleResponse(response);
      return LiverProfile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add Liver Profile record: $e');
    }
  }

  Future<LiverProfile> updateRecord(LiverProfile record) async {
    try {
      final response = await _apiService.put(
          '/liver/updateLiverProfileRecord', record.toJson());
      final data = _apiService.handleResponse(response);
      return LiverProfile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update Liver Profile record: $e');
    }
  }
}
