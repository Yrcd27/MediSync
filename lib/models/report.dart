import 'user.dart';
import 'blood_pressure.dart';
import 'fasting_blood_sugar.dart';
import 'full_blood_count.dart';
import 'lipid_profile.dart';
import 'liver_profile.dart';
import 'urine_report.dart';

/// Report model matching backend Report entity exactly
/// Backend fields: id, report_date, fbc_id, liver_id, urine_id, fbs_id, lipid_id, bp_id, user_id
/// Note: Backend does NOT have a summary field - summary is computed on frontend
class Report {
  final int id;
  final String reportDate; // Backend uses LocalDate, sent as ISO string (YYYY-MM-DD)
  final FullBloodCount? fullBloodCount;
  final LiverProfile? liverProfile;
  final UrineReport? urineReport;
  final FastingBloodSugar? fastingBloodSugar;
  final LipidProfile? lipidProfile;
  final BloodPressure? bloodPressure;
  final User? user;

  Report({
    required this.id,
    required this.reportDate,
    this.fullBloodCount,
    this.liverProfile,
    this.urineReport,
    this.fastingBloodSugar,
    this.lipidProfile,
    this.bloodPressure,
    this.user,
  });

  /// Generate a summary description based on the test types included
  String get summary {
    final tests = <String>[];
    if (bloodPressure != null) tests.add('Blood Pressure');
    if (fastingBloodSugar != null) tests.add('FBS');
    if (fullBloodCount != null) tests.add('FBC');
    if (lipidProfile != null) tests.add('Lipid');
    if (liverProfile != null) tests.add('Liver');
    if (urineReport != null) tests.add('Urine');

    if (tests.isEmpty) return 'Health Report - $reportDate';
    return '${tests.join(", ")} Report - $reportDate';
  }

  /// Count of tests included in this report
  int get testCount {
    int count = 0;
    if (bloodPressure != null) count++;
    if (fastingBloodSugar != null) count++;
    if (fullBloodCount != null) count++;
    if (lipidProfile != null) count++;
    if (liverProfile != null) count++;
    if (urineReport != null) count++;
    return count;
  }

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as int,
      reportDate: json['reportDate'] as String? ?? '',
      fullBloodCount: json['fullBloodCount'] != null
          ? FullBloodCount.fromJson(json['fullBloodCount'] as Map<String, dynamic>)
          : null,
      liverProfile: json['liverProfile'] != null
          ? LiverProfile.fromJson(json['liverProfile'] as Map<String, dynamic>)
          : null,
      urineReport: json['urineReport'] != null
          ? UrineReport.fromJson(json['urineReport'] as Map<String, dynamic>)
          : null,
      fastingBloodSugar: json['fastingBloodSugar'] != null
          ? FastingBloodSugar.fromJson(json['fastingBloodSugar'] as Map<String, dynamic>)
          : null,
      lipidProfile: json['lipidProfile'] != null
          ? LipidProfile.fromJson(json['lipidProfile'] as Map<String, dynamic>)
          : null,
      bloodPressure: json['bloodPressure'] != null
          ? BloodPressure.fromJson(json['bloodPressure'] as Map<String, dynamic>)
          : null,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportDate': reportDate,
      'fullBloodCount': fullBloodCount?.toJson(),
      'liverProfile': liverProfile?.toJson(),
      'urineReport': urineReport?.toJson(),
      'fastingBloodSugar': fastingBloodSugar?.toJson(),
      'lipidProfile': lipidProfile?.toJson(),
      'bloodPressure': bloodPressure?.toJson(),
      'user': user?.toJson(),
    };
  }

  Report copyWith({
    int? id,
    String? reportDate,
    FullBloodCount? fullBloodCount,
    LiverProfile? liverProfile,
    UrineReport? urineReport,
    FastingBloodSugar? fastingBloodSugar,
    LipidProfile? lipidProfile,
    BloodPressure? bloodPressure,
    User? user,
  }) {
    return Report(
      id: id ?? this.id,
      reportDate: reportDate ?? this.reportDate,
      fullBloodCount: fullBloodCount ?? this.fullBloodCount,
      liverProfile: liverProfile ?? this.liverProfile,
      urineReport: urineReport ?? this.urineReport,
      fastingBloodSugar: fastingBloodSugar ?? this.fastingBloodSugar,
      lipidProfile: lipidProfile ?? this.lipidProfile,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'Report(id: $id, date: $reportDate, tests: $testCount)';
  }
}
