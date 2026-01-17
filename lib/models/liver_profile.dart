import 'user.dart';

/// Liver Profile model matching backend LiverProfile entity exactly
/// Backend fields: id, test_date, protein_total_serum, albumin_serum, bilirubin_total_serum, sgpt, image_url, user_id
class LiverProfile {
  final int id;
  final String testDate; // Backend uses LocalDate, sent as ISO string (YYYY-MM-DD)
  final double proteinTotalSerum; // Total protein in g/dL
  final double albuminSerum; // Albumin in g/dL
  final double bilirubinTotalSerum; // Total bilirubin in mg/dL
  final double sgpt; // SGPT/ALT in U/L
  final String? imageUrl;
  final User? user;

  LiverProfile({
    required this.id,
    required this.testDate,
    required this.proteinTotalSerum,
    required this.albuminSerum,
    required this.bilirubinTotalSerum,
    required this.sgpt,
    this.imageUrl,
    this.user,
  });

  factory LiverProfile.fromJson(Map<String, dynamic> json) {
    return LiverProfile(
      id: json['id'] as int,
      testDate: json['testDate'] as String? ?? '',
      proteinTotalSerum: (json['proteinTotalSerum'] as num?)?.toDouble() ?? 0.0,
      albuminSerum: (json['albuminSerum'] as num?)?.toDouble() ?? 0.0,
      bilirubinTotalSerum: (json['bilirubinTotalSerum'] as num?)?.toDouble() ?? 0.0,
      sgpt: (json['sgpt'] as num?)?.toDouble() ?? 0.0,
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
      'proteinTotalSerum': proteinTotalSerum,
      'albuminSerum': albuminSerum,
      'bilirubinTotalSerum': bilirubinTotalSerum,
      'sgpt': sgpt,
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
      'proteinTotalSerum': proteinTotalSerum,
      'albuminSerum': albuminSerum,
      'bilirubinTotalSerum': bilirubinTotalSerum,
      'sgpt': sgpt,
      'imageUrl': imageUrl,
      'user': {'id': userId},
    };
  }

  /// For updating a record
  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'testDate': testDate,
      'proteinTotalSerum': proteinTotalSerum,
      'albuminSerum': albuminSerum,
      'bilirubinTotalSerum': bilirubinTotalSerum,
      'sgpt': sgpt,
      'imageUrl': imageUrl,
      'user': user != null ? {'id': user!.id} : null,
    };
  }

  LiverProfile copyWith({
    int? id,
    String? testDate,
    double? proteinTotalSerum,
    double? albuminSerum,
    double? bilirubinTotalSerum,
    double? sgpt,
    String? imageUrl,
    User? user,
  }) {
    return LiverProfile(
      id: id ?? this.id,
      testDate: testDate ?? this.testDate,
      proteinTotalSerum: proteinTotalSerum ?? this.proteinTotalSerum,
      albuminSerum: albuminSerum ?? this.albuminSerum,
      bilirubinTotalSerum: bilirubinTotalSerum ?? this.bilirubinTotalSerum,
      sgpt: sgpt ?? this.sgpt,
      imageUrl: imageUrl ?? this.imageUrl,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'LiverProfile(id: $id, date: $testDate, SGPT: $sgpt, Bilirubin: $bilirubinTotalSerum)';
  }
}
