import 'user.dart';

/// Fasting Blood Sugar model matching backend FastingBloodSugar entity exactly
/// Backend fields: id, test_date, fbs_level, image_url, user_id
class FastingBloodSugar {
  final int id;
  final String
  testDate; // Backend uses LocalDate, sent as ISO string (YYYY-MM-DD)
  final double fbsLevel; // Blood sugar level in mg/dL
  final String? imageUrl;
  final User? user;

  FastingBloodSugar({
    required this.id,
    required this.testDate,
    required this.fbsLevel,
    this.imageUrl,
    this.user,
  });

  factory FastingBloodSugar.fromJson(Map<String, dynamic> json) {
    return FastingBloodSugar(
      id: json['id'] as int,
      testDate: json['testDate'] as String? ?? '',
      fbsLevel: (json['fbsLevel'] as num?)?.toDouble() ?? 0.0,
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
      'fbsLevel': fbsLevel,
      'imageUrl': imageUrl,
    };
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }

  /// For creating a new record - backend expects full user object
  Map<String, dynamic> toCreateJson(User user) {
    return {
      'testDate': testDate,
      'fbsLevel': fbsLevel,
      'imageUrl': imageUrl,
      'user': user.toJson(),
    };
  }

  /// For updating a record
  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'testDate': testDate,
      'fbsLevel': fbsLevel,
      'imageUrl': imageUrl,
      'user': user != null ? {'id': user!.id} : null,
    };
  }

  FastingBloodSugar copyWith({
    int? id,
    String? testDate,
    double? fbsLevel,
    String? imageUrl,
    User? user,
  }) {
    return FastingBloodSugar(
      id: id ?? this.id,
      testDate: testDate ?? this.testDate,
      fbsLevel: fbsLevel ?? this.fbsLevel,
      imageUrl: imageUrl ?? this.imageUrl,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'FastingBloodSugar(id: $id, date: $testDate, level: $fbsLevel mg/dL)';
  }
}
