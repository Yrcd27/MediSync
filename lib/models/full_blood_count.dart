import 'user.dart';

/// Full Blood Count model matching backend FullBloodCount entity exactly
/// Backend fields: id, test_date, haemoglobin, total_leucocyte_count, platelet_count, image_url, user_id
class FullBloodCount {
  final int id;
  final String testDate; // Backend uses LocalDate, sent as ISO string (YYYY-MM-DD)
  final double haemoglobin; // Hemoglobin in g/dL (British spelling to match backend)
  final double totalLeucocyteCount; // WBC count in cells/mcL
  final double plateletCount; // Platelet count in cells/mcL
  final String? imageUrl;
  final User? user;

  FullBloodCount({
    required this.id,
    required this.testDate,
    required this.haemoglobin,
    required this.totalLeucocyteCount,
    required this.plateletCount,
    this.imageUrl,
    this.user,
  });

  factory FullBloodCount.fromJson(Map<String, dynamic> json) {
    return FullBloodCount(
      id: json['id'] as int,
      testDate: json['testDate'] as String? ?? '',
      haemoglobin: (json['haemoglobin'] as num?)?.toDouble() ?? 0.0,
      totalLeucocyteCount: (json['totalLeucocyteCount'] as num?)?.toDouble() ?? 0.0,
      plateletCount: (json['plateletCount'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String?,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'testDate': testDate,
      'haemoglobin': haemoglobin,
      'totalLeucocyteCount': totalLeucocyteCount,
      'plateletCount': plateletCount,
      'imageUrl': imageUrl,
    };
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }

  /// For creating a new record - backend expects user object with id
  Map<String, dynamic> toCreateJson(int userId) {
    return {
      'testDate': testDate,
      'haemoglobin': haemoglobin,
      'totalLeucocyteCount': totalLeucocyteCount,
      'plateletCount': plateletCount,
      'imageUrl': imageUrl,
      'user': {'id': userId},
    };
  }

  /// For updating a record
  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'testDate': testDate,
      'haemoglobin': haemoglobin,
      'totalLeucocyteCount': totalLeucocyteCount,
      'plateletCount': plateletCount,
      'imageUrl': imageUrl,
      'user': user != null ? {'id': user!.id} : null,
    };
  }

  FullBloodCount copyWith({
    int? id,
    String? testDate,
    double? haemoglobin,
    double? totalLeucocyteCount,
    double? plateletCount,
    String? imageUrl,
    User? user,
  }) {
    return FullBloodCount(
      id: id ?? this.id,
      testDate: testDate ?? this.testDate,
      haemoglobin: haemoglobin ?? this.haemoglobin,
      totalLeucocyteCount: totalLeucocyteCount ?? this.totalLeucocyteCount,
      plateletCount: plateletCount ?? this.plateletCount,
      imageUrl: imageUrl ?? this.imageUrl,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'FullBloodCount(id: $id, date: $testDate, Hb: $haemoglobin, WBC: $totalLeucocyteCount, PLT: $plateletCount)';
  }
}
