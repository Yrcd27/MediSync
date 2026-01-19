import 'user.dart';

/// Lipid Profile model matching backend LipidProfile entity exactly
/// Backend fields: id, test_date, total_cholesterol, hdl, ldl, vldl, triglycerides, image_url, user_id
class LipidProfile {
  final int id;
  final String testDate; // Backend uses LocalDate, sent as ISO string (YYYY-MM-DD)
  final double totalCholesterol; // Total cholesterol in mg/dL
  final double hdl; // HDL (good cholesterol) in mg/dL
  final double ldl; // LDL (bad cholesterol) in mg/dL
  final double vldl; // VLDL in mg/dL
  final double triglycerides; // Triglycerides in mg/dL
  final String? imageUrl;
  final User? user;

  LipidProfile({
    required this.id,
    required this.testDate,
    required this.totalCholesterol,
    required this.hdl,
    required this.ldl,
    required this.vldl,
    required this.triglycerides,
    this.imageUrl,
    this.user,
  });

  factory LipidProfile.fromJson(Map<String, dynamic> json) {
    return LipidProfile(
      id: json['id'] as int,
      testDate: json['testDate'] as String? ?? '',
      totalCholesterol: (json['totalCholesterol'] as num?)?.toDouble() ?? 0.0,
      hdl: (json['hdl'] as num?)?.toDouble() ?? 0.0,
      ldl: (json['ldl'] as num?)?.toDouble() ?? 0.0,
      vldl: (json['vldl'] as num?)?.toDouble() ?? 0.0,
      triglycerides: (json['triglycerides'] as num?)?.toDouble() ?? 0.0,
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
      'totalCholesterol': totalCholesterol,
      'hdl': hdl,
      'ldl': ldl,
      'vldl': vldl,
      'triglycerides': triglycerides,
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
      'totalCholesterol': totalCholesterol,
      'hdl': hdl,
      'ldl': ldl,
      'vldl': vldl,
      'triglycerides': triglycerides,
      'imageUrl': imageUrl,
      'user': {'id': userId},
    };
  }

  /// For updating a record
  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'testDate': testDate,
      'totalCholesterol': totalCholesterol,
      'hdl': hdl,
      'ldl': ldl,
      'vldl': vldl,
      'triglycerides': triglycerides,
      'imageUrl': imageUrl,
      'user': user != null ? {'id': user!.id} : null,
    };
  }

  LipidProfile copyWith({
    int? id,
    String? testDate,
    double? totalCholesterol,
    double? hdl,
    double? ldl,
    double? vldl,
    double? triglycerides,
    String? imageUrl,
    User? user,
  }) {
    return LipidProfile(
      id: id ?? this.id,
      testDate: testDate ?? this.testDate,
      totalCholesterol: totalCholesterol ?? this.totalCholesterol,
      hdl: hdl ?? this.hdl,
      ldl: ldl ?? this.ldl,
      vldl: vldl ?? this.vldl,
      triglycerides: triglycerides ?? this.triglycerides,
      imageUrl: imageUrl ?? this.imageUrl,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'LipidProfile(id: $id, date: $testDate, TC: $totalCholesterol, HDL: $hdl, LDL: $ldl)';
  }
}
