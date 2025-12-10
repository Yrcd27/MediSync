import '../models/lipid_profile.dart';
import '../core/services/api_service.dart';

class LipidProfileService {
  final ApiService _apiService = ApiService();

  Future<List<LipidProfile>> getRecordsByUserId(int userId) async {
    try {
      final response = await _apiService
          .get('/lipid/getLipidProfileRecordsByUserId/$userId');
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data.map((json) => LipidProfile.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch Lipid Profile records: $e');
    }
  }

  Future<LipidProfile> addRecord(LipidProfile record, int userId) async {
    try {
      final response = await _apiService.post(
          '/lipid/addLipidProfileRecord', record.toCreateJson(userId));
      final data = _apiService.handleResponse(response);
      return LipidProfile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add Lipid Profile record: $e');
    }
  }

  Future<LipidProfile> updateRecord(LipidProfile record) async {
    try {
      final response = await _apiService.put(
          '/lipid/updateLipidProfileRecord', record.toJson());
      final data = _apiService.handleResponse(response);
      return LipidProfile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update Lipid Profile record: $e');
    }
  }
}
