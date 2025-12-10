import '../models/report.dart';
import '../core/services/api_service.dart';

class ReportService {
  final ApiService _apiService = ApiService();

  Future<List<Report>> getReportsByUserId(int userId) async {
    try {
      final response =
          await _apiService.get('/reports/getReportsByUserId/$userId');
      final List<dynamic> data = _apiService.handleListResponse(response);
      return data.map((json) => Report.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch reports: $e');
    }
  }
}
