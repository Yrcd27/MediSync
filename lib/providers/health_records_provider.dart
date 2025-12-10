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

  Future<void> loadAllRecords(int userId) async {
    _isLoading = true;
    notifyListeners();

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
      notifyListeners();
    }
  }

  // FBS Methods
  Future<void> loadFBSRecords(int userId) async {
    try {
      _fbsRecords = await _fbsService.getRecordsByUserId(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> addFBSRecord(FastingBloodSugar record, int userId) async {
    try {
      final newRecord = await _fbsService.addRecord(record, userId);
      _fbsRecords.add(newRecord);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateFBSRecord(FastingBloodSugar record) async {
    try {
      final updatedRecord = await _fbsService.updateRecord(record);
      final index = _fbsRecords.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _fbsRecords[index] = updatedRecord;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Blood Pressure Methods
  Future<void> loadBPRecords(int userId) async {
    try {
      _bpRecords = await _bpService.getRecordsByUserId(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> addBPRecord(BloodPressure record, int userId) async {
    try {
      final newRecord = await _bpService.addRecord(record, userId);
      _bpRecords.add(newRecord);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateBPRecord(BloodPressure record) async {
    try {
      final updatedRecord = await _bpService.updateRecord(record);
      final index = _bpRecords.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _bpRecords[index] = updatedRecord;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Full Blood Count Methods
  Future<void> loadFBCRecords(int userId) async {
    try {
      _fbcRecords = await _fbcService.getRecordsByUserId(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> addFBCRecord(FullBloodCount record, int userId) async {
    try {
      final newRecord = await _fbcService.addRecord(record, userId);
      _fbcRecords.add(newRecord);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateFBCRecord(FullBloodCount record) async {
    try {
      final updatedRecord = await _fbcService.updateRecord(record);
      final index = _fbcRecords.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _fbcRecords[index] = updatedRecord;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteFBCRecord(int recordId) async {
    try {
      await _fbcService.deleteRecord(recordId);
      _fbcRecords.removeWhere((r) => r.id == recordId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Lipid Profile Methods
  Future<void> loadLipidRecords(int userId) async {
    try {
      _lipidRecords = await _lipidService.getRecordsByUserId(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> addLipidRecord(LipidProfile record, int userId) async {
    try {
      final newRecord = await _lipidService.addRecord(record, userId);
      _lipidRecords.add(newRecord);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateLipidRecord(LipidProfile record) async {
    try {
      final updatedRecord = await _lipidService.updateRecord(record);
      final index = _lipidRecords.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _lipidRecords[index] = updatedRecord;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Liver Profile Methods
  Future<void> loadLiverRecords(int userId) async {
    try {
      _liverRecords = await _liverService.getRecordsByUserId(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> addLiverRecord(LiverProfile record, int userId) async {
    try {
      final newRecord = await _liverService.addRecord(record, userId);
      _liverRecords.add(newRecord);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateLiverRecord(LiverProfile record) async {
    try {
      final updatedRecord = await _liverService.updateRecord(record);
      final index = _liverRecords.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _liverRecords[index] = updatedRecord;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Urine Report Methods
  Future<void> loadUrineRecords(int userId) async {
    try {
      _urineRecords = await _urineService.getRecordsByUserId(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> addUrineRecord(UrineReport record, int userId) async {
    try {
      final newRecord = await _urineService.addRecord(record, userId);
      _urineRecords.add(newRecord);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateUrineRecord(UrineReport record) async {
    try {
      final updatedRecord = await _urineService.updateRecord(record);
      final index = _urineRecords.indexWhere((r) => r.id == record.id);
      if (index != -1) {
        _urineRecords[index] = updatedRecord;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Reports Methods
  Future<void> loadReports(int userId) async {
    try {
      _reports = await _reportService.getReportsByUserId(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
