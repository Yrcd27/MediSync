import '../models/urine_report.dart';
import '../core/services/api_service.dart';

class UrineReportService {
  final ApiService _apiService = ApiService();

  Future<List<UrineReport>> getRecordsByUserId(int userId) async {
    try {
      final response =
          await _apiService.get('/urine/getUrineReportRecordsByUserId/$userId');
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data.map((json) => UrineReport.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch Urine Report records: $e');
    }
  }

  Future<UrineReport> addRecord(UrineReport record, int userId) async {
    try {
      final response = await _apiService.post(
          '/urine/addUrineReportRecord', record.toCreateJson(userId));
      final data = _apiService.handleResponse(response);
      return UrineReport.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add Urine Report record: $e');
    }
  }

  Future<UrineReport> updateRecord(UrineReport record) async {
    try {
      final response = await _apiService.put(
          '/urine/updateUrineReportRecord', record.toJson());
      final data = _apiService.handleResponse(response);
      return UrineReport.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update Urine Report record: $e');
    }
  }
}
