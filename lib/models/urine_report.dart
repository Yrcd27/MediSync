import 'user.dart';

/// Urine Report model matching backend UrineReport entity exactly
/// Backend fields: id, test_date, color, appearance, protein, sugar, specific_gravity, image_url, user_id
class UrineReport {
  final int id;
  final String testDate; // Backend uses LocalDate, sent as ISO string (YYYY-MM-DD)
  final String color; // e.g., "Pale Yellow", "Dark Yellow"
  final String appearance; // e.g., "Clear", "Cloudy"
  final String protein; // e.g., "Negative", "Trace", "+", "++"
  final String sugar; // e.g., "Negative", "Trace", "+", "++"
  final double specificGravity; // Normal: 1.005-1.030
  final String? imageUrl;
  final User? user;

  UrineReport({
    required this.id,
    required this.testDate,
    required this.color,
    required this.appearance,
    required this.protein,
    required this.sugar,
    required this.specificGravity,
    this.imageUrl,
    this.user,
  });

  factory UrineReport.fromJson(Map<String, dynamic> json) {
    return UrineReport(
      id: json['id'] as int,
      testDate: json['testDate'] as String? ?? '',
      color: json['color'] as String? ?? '',
      appearance: json['appearance'] as String? ?? '',
      protein: json['protein'] as String? ?? '',
      sugar: json['sugar'] as String? ?? '',
      specificGravity: (json['specificGravity'] as num?)?.toDouble() ?? 0.0,
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
      'color': color,
      'appearance': appearance,
      'protein': protein,
      'sugar': sugar,
      'specificGravity': specificGravity,
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
      'color': color,
      'appearance': appearance,
      'protein': protein,
      'sugar': sugar,
      'specificGravity': specificGravity,
      'imageUrl': imageUrl,
      'user': {'id': userId},
    };
  }

  /// For updating a record
  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'testDate': testDate,
      'color': color,
      'appearance': appearance,
      'protein': protein,
      'sugar': sugar,
      'specificGravity': specificGravity,
      'imageUrl': imageUrl,
      'user': user != null ? {'id': user!.id} : null,
    };
  }

  UrineReport copyWith({
    int? id,
    String? testDate,
    String? color,
    String? appearance,
    String? protein,
    String? sugar,
    double? specificGravity,
    String? imageUrl,
    User? user,
  }) {
    return UrineReport(
      id: id ?? this.id,
      testDate: testDate ?? this.testDate,
      color: color ?? this.color,
      appearance: appearance ?? this.appearance,
      protein: protein ?? this.protein,
      sugar: sugar ?? this.sugar,
      specificGravity: specificGravity ?? this.specificGravity,
      imageUrl: imageUrl ?? this.imageUrl,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'UrineReport(id: $id, date: $testDate, color: $color, SG: $specificGravity)';
  }
}
