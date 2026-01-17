import 'package:flutter/material.dart';
import '../models/fasting_blood_sugar.dart';
import '../models/blood_pressure.dart';
import '../models/full_blood_count.dart';
import '../models/lipid_profile.dart';
import '../models/liver_profile.dart';
import '../models/urine_report.dart';
import '../models/report.dart';
import '../services/fasting_blood_sugar_service.dart';
import '../services/blood_pressure_service.dart';
import '../services/full_blood_count_service.dart';
import '../services/lipid_profile_service.dart';
import '../services/liver_profile_service.dart';
import '../services/urine_report_service.dart';
import '../services/report_service.dart';

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
      if (!_isBulkLoading) notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      if (!_isBulkLoading) notifyListeners();
    }
  }

  Future<bool> addFBSRecord(FastingBloodSugar record, int userId) async {
    try {
      final newRecord = await _fbsService.addRecord(record, userId);
      _fbsRecords.add(newRecord);
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
