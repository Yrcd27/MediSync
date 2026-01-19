import 'package:flutter/material.dart';
import '../models/fasting_blood_sugar.dart';
import '../models/blood_pressure.dart';
import '../models/full_blood_count.dart';
import '../models/lipid_profile.dart';
import '../models/liver_profile.dart';
import '../models/urine_report.dart';
import '../models/report.dart';
import '../models/user.dart';
import '../services/fasting_blood_sugar_service.dart';
import '../services/blood_pressure_service.dart';
import '../services/full_blood_count_service.dart';
import '../services/lipid_profile_service.dart';
import '../services/liver_profile_service.dart';
import '../services/urine_report_service.dart';
import '../services/report_service.dart';
import '../core/constants/app_colors.dart';

/// Provider for managing all health records
class HealthRecordsProvider with ChangeNotifier {
  final FastingBloodSugarService _fbsService = FastingBloodSugarService();
  final BloodPressureService _bpService = BloodPressureService();
  final FullBloodCountService _fbcService = FullBloodCountService();
  final LipidProfileService _lipidService = LipidProfileService();
  final LiverProfileService _liverService = LiverProfileService();
  final UrineReportService _urineService = UrineReportService();
  final ReportService _reportService = ReportService();

  List<FastingBloodSugar> _fbsRecords = [];
  List<BloodPressure> _bpRecords = [];
  List<FullBloodCount> _fbcRecords = [];
  List<LipidProfile> _lipidRecords = [];
  List<LiverProfile> _liverRecords = [];
  List<UrineReport> _urineRecords = [];
  List<Report> _reports = [];

  bool _isLoading = false;
  bool _isBulkLoading = false;
  String? _errorMessage;

  // Getters
  List<FastingBloodSugar> get fbsRecords => _fbsRecords;
  List<BloodPressure> get bpRecords => _bpRecords;
  List<FullBloodCount> get fbcRecords => _fbcRecords;
  List<LipidProfile> get lipidRecords => _lipidRecords;
  List<LiverProfile> get liverRecords => _liverRecords;
  List<UrineReport> get urineRecords => _urineRecords;
  List<Report> get reports => _reports;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Generate daily reports by grouping all records by their test date
  List<Map<String, dynamic>> get dailyReports {
    final Map<String, Map<String, dynamic>> reportsByDate = {};

    // Group blood pressure records by date
    for (final record in _bpRecords) {
      final date = record.testDate;
      reportsByDate.putIfAbsent(date, () => {'date': date, 'tests': []});
      reportsByDate[date]!['tests'].add({
        'type': 'Blood Pressure',
        'icon': Icons.favorite_rounded,
        'color': AppColors.bloodPressure,
        'value': record.bpLevel,
        'unit': 'mmHg',
        'data': record,
      });
    }

    // Group blood sugar records by date
    for (final record in _fbsRecords) {
      final date = record.testDate;
      reportsByDate.putIfAbsent(date, () => {'date': date, 'tests': []});
      reportsByDate[date]!['tests'].add({
        'type': 'Blood Sugar',
        'icon': Icons.water_drop_rounded,
        'color': AppColors.bloodSugar,
        'value': '${record.fbsLevel.toStringAsFixed(0)} mg/dL',
        'unit': '',
        'data': record,
      });
    }

    // Group blood count records by date
    for (final record in _fbcRecords) {
      final date = record.testDate;
      reportsByDate.putIfAbsent(date, () => {'date': date, 'tests': []});
      reportsByDate[date]!['tests'].add({
        'type': 'Blood Count',
        'icon': Icons.science_rounded,
        'color': AppColors.bloodCount,
        'value': 'Hb ${record.haemoglobin.toStringAsFixed(1)} g/dL',
        'unit': '',
        'data': record,
      });
    }

    // Group lipid profile records by date
    for (final record in _lipidRecords) {
      final date = record.testDate;
      reportsByDate.putIfAbsent(date, () => {'date': date, 'tests': []});
      reportsByDate[date]!['tests'].add({
        'type': 'Lipid Profile',
        'icon': Icons.monitor_heart_rounded,
        'color': AppColors.lipidProfile,
        'value': 'TC ${record.totalCholesterol.toStringAsFixed(0)} mg/dL',
        'unit': '',
        'data': record,
      });
    }

    // Group liver profile records by date
    for (final record in _liverRecords) {
      final date = record.testDate;
      reportsByDate.putIfAbsent(date, () => {'date': date, 'tests': []});
      reportsByDate[date]!['tests'].add({
        'type': 'Liver Profile',
        'icon': Icons.local_hospital_rounded,
        'color': AppColors.liverProfile,
        'value': 'SGPT ${record.sgpt.toStringAsFixed(0)} U/L',
        'unit': '',
        'data': record,
      });
    }

    // Group urine report records by date
    for (final record in _urineRecords) {
      final date = record.testDate;
      reportsByDate.putIfAbsent(date, () => {'date': date, 'tests': []});
      reportsByDate[date]!['tests'].add({
        'type': 'Urine Report',
        'icon': Icons.opacity_rounded,
        'color': AppColors.urineReport,
        'value': 'SG ${record.specificGravity.toStringAsFixed(3)}',
        'unit': '',
        'data': record,
      });
    }

    // Convert to list and sort by date (most recent first)
    final reportsList = reportsByDate.values.toList();
    reportsList.sort((a, b) {
      final dateA = DateTime.tryParse(a['date'] as String) ?? DateTime.now();
      final dateB = DateTime.tryParse(b['date'] as String) ?? DateTime.now();
      return dateB.compareTo(dateA);
    });

    return reportsList;
  }

  /// Load all records for a user
  Future<void> loadAllRecords(int userId) async {
    _isLoading = true;
    _isBulkLoading = true;
    _errorMessage = null;

    // Defer notifyListeners to avoid setState during build
    Future.microtask(() => notifyListeners());

    try {
      await Future.wait([
        loadFBSRecords(userId),
        loadBPRecords(userId),
        loadFBCRecords(userId),
        loadLipidRecords(userId),
        loadLiverRecords(userId),
        loadUrineRecords(userId),
        loadReports(userId),
      ]);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      _isBulkLoading = false;
      notifyListeners();
    }
  }

  // ============= FBS Methods =============
  Future<void> loadFBSRecords(int userId) async {
    try {
      _fbsRecords = await _fbsService.getRecordsByUserId(userId);
      // Sort by test date (newest first), then by ID (highest first) for same date
      _fbsRecords.sort((a, b) {
        final dateComparison = b.testDate.compareTo(a.testDate);
        if (dateComparison != 0) return dateComparison;
        return b.id.compareTo(a.id);
      });
      if (!_isBulkLoading) notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      if (!_isBulkLoading) notifyListeners();
    }
  }

  Future<bool> addFBSRecord(FastingBloodSugar record, User user) async {
    try {
      final newRecord = await _fbsService.addRecord(record, user);
      _fbsRecords.add(newRecord);
      // Re-sort after adding new record (by date, then by ID)
      _fbsRecords.sort((a, b) {
        final dateComparison = b.testDate.compareTo(a.testDate);
        if (dateComparison != 0) return dateComparison;
        return b.id.compareTo(a.id);
      });
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateFBSRecord(FastingBloodSugar record) async {
    try {
      final updatedRecord = await _fbsService.updateRecord(record);
      final index = _fbsRecords.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _fbsRecords[index] = updatedRecord;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteFBSRecord(int recordId) async {
    try {
      await _fbsService.deleteRecord(recordId);
      _fbsRecords.removeWhere((r) => r.id == recordId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ============= Blood Pressure Methods =============
  Future<void> loadBPRecords(int userId) async {
    try {
      _bpRecords = await _bpService.getRecordsByUserId(userId);
      // Sort by test date (newest first), then by ID (highest first) for same date
      _bpRecords.sort((a, b) {
        final dateComparison = b.testDate.compareTo(a.testDate);
        if (dateComparison != 0) return dateComparison;
        return b.id.compareTo(a.id);
      });
      if (!_isBulkLoading) notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      if (!_isBulkLoading) notifyListeners();
    }
  }

  Future<bool> addBPRecord(BloodPressure record, int userId) async {
    try {
      final newRecord = await _bpService.addRecord(record, userId);
      _bpRecords.add(newRecord);
      // Re-sort after adding new record (by date, then by ID)
      _bpRecords.sort((a, b) {
        final dateComparison = b.testDate.compareTo(a.testDate);
        if (dateComparison != 0) return dateComparison;
        return b.id.compareTo(a.id);
      });
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBPRecord(BloodPressure record) async {
    try {
      final updatedRecord = await _bpService.updateRecord(record);
      final index = _bpRecords.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _bpRecords[index] = updatedRecord;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBPRecord(int recordId) async {
    try {
      await _bpService.deleteRecord(recordId);
      _bpRecords.removeWhere((r) => r.id == recordId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ============= FBC Methods =============
  Future<void> loadFBCRecords(int userId) async {
    try {
      _fbcRecords = await _fbcService.getRecordsByUserId(userId);
      // Sort by test date (newest first), then by ID (highest first) for same date
      _fbcRecords.sort((a, b) {
        final dateComparison = b.testDate.compareTo(a.testDate);
        if (dateComparison != 0) return dateComparison;
        return b.id.compareTo(a.id);
      });
      if (!_isBulkLoading) notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      if (!_isBulkLoading) notifyListeners();
    }
  }

  Future<bool> addFBCRecord(FullBloodCount record, int userId) async {
    try {
      final newRecord = await _fbcService.addRecord(record, userId);
      _fbcRecords.add(newRecord);
      // Re-sort after adding new record (by date, then by ID)
      _fbcRecords.sort((a, b) {
        final dateComparison = b.testDate.compareTo(a.testDate);
        if (dateComparison != 0) return dateComparison;
        return b.id.compareTo(a.id);
      });
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateFBCRecord(FullBloodCount record) async {
    try {
      final updatedRecord = await _fbcService.updateRecord(record);
      final index = _fbcRecords.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _fbcRecords[index] = updatedRecord;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteFBCRecord(int recordId) async {
    try {
      await _fbcService.deleteRecord(recordId);
      _fbcRecords.removeWhere((r) => r.id == recordId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ============= Lipid Profile Methods =============
  Future<void> loadLipidRecords(int userId) async {
    try {
      _lipidRecords = await _lipidService.getRecordsByUserId(userId);
      // Sort by test date (newest first), then by ID (highest first) for same date
      _lipidRecords.sort((a, b) {
        final dateComparison = b.testDate.compareTo(a.testDate);
        if (dateComparison != 0) return dateComparison;
        return b.id.compareTo(a.id);
      });
      if (!_isBulkLoading) notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      if (!_isBulkLoading) notifyListeners();
    }
  }

  Future<bool> addLipidRecord(LipidProfile record, int userId) async {
    try {
      final newRecord = await _lipidService.addRecord(record, userId);
      _lipidRecords.add(newRecord);
      // Re-sort after adding new record (by date, then by ID)
      _lipidRecords.sort((a, b) {
        final dateComparison = b.testDate.compareTo(a.testDate);
        if (dateComparison != 0) return dateComparison;
        return b.id.compareTo(a.id);
      });
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateLipidRecord(LipidProfile record) async {
    try {
      final updatedRecord = await _lipidService.updateRecord(record);
      final index = _lipidRecords.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _lipidRecords[index] = updatedRecord;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteLipidRecord(int recordId) async {
    try {
      await _lipidService.deleteRecord(recordId);
      _lipidRecords.removeWhere((r) => r.id == recordId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ============= Liver Profile Methods =============
  Future<void> loadLiverRecords(int userId) async {
    try {
      _liverRecords = await _liverService.getRecordsByUserId(userId);
      // Sort by test date (newest first), then by ID (highest first) for same date
      _liverRecords.sort((a, b) {
        final dateComparison = b.testDate.compareTo(a.testDate);
        if (dateComparison != 0) return dateComparison;
        return b.id.compareTo(a.id);
      });
      if (!_isBulkLoading) notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      if (!_isBulkLoading) notifyListeners();
    }
  }

  Future<bool> addLiverRecord(LiverProfile record, int userId) async {
    try {
      final newRecord = await _liverService.addRecord(record, userId);
      _liverRecords.add(newRecord);
      // Re-sort after adding new record (by date, then by ID)
      _liverRecords.sort((a, b) {
        final dateComparison = b.testDate.compareTo(a.testDate);
        if (dateComparison != 0) return dateComparison;
        return b.id.compareTo(a.id);
      });
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateLiverRecord(LiverProfile record) async {
    try {
      final updatedRecord = await _liverService.updateRecord(record);
      final index = _liverRecords.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _liverRecords[index] = updatedRecord;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteLiverRecord(int recordId) async {
    try {
      await _liverService.deleteRecord(recordId);
      _liverRecords.removeWhere((r) => r.id == recordId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ============= Urine Report Methods =============
  Future<void> loadUrineRecords(int userId) async {
    try {
      _urineRecords = await _urineService.getRecordsByUserId(userId);
      // Sort by test date (newest first), then by ID (highest first) for same date
      _urineRecords.sort((a, b) {
        final dateComparison = b.testDate.compareTo(a.testDate);
        if (dateComparison != 0) return dateComparison;
        return b.id.compareTo(a.id);
      });
      if (!_isBulkLoading) notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      if (!_isBulkLoading) notifyListeners();
    }
  }

  Future<bool> addUrineRecord(UrineReport record, int userId) async {
    try {
      final newRecord = await _urineService.addRecord(record, userId);
      _urineRecords.add(newRecord);
      // Re-sort after adding new record (by date, then by ID)
      _urineRecords.sort((a, b) {
        final dateComparison = b.testDate.compareTo(a.testDate);
        if (dateComparison != 0) return dateComparison;
        return b.id.compareTo(a.id);
      });
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUrineRecord(UrineReport record) async {
    try {
      final updatedRecord = await _urineService.updateRecord(record);
      final index = _urineRecords.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _urineRecords[index] = updatedRecord;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteUrineRecord(int recordId) async {
    try {
      await _urineService.deleteRecord(recordId);
      _urineRecords.removeWhere((r) => r.id == recordId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ============= Reports Methods =============
  Future<void> loadReports(int userId) async {
    try {
      _reports = await _reportService.getReportsByUserId(userId);
      if (!_isBulkLoading) notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      if (!_isBulkLoading) notifyListeners();
    }
  }

  Future<bool> deleteReport(int reportId) async {
    try {
      await _reportService.deleteReport(reportId);
      _reports.removeWhere((r) => r.id == reportId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all records (used on logout)
  void clearRecords() {
    _fbsRecords = [];
    _bpRecords = [];
    _fbcRecords = [];
    _lipidRecords = [];
    _liverRecords = [];
    _urineRecords = [];
    _reports = [];
    notifyListeners();
  }
}
