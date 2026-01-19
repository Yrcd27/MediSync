import 'user.dart';

/// Blood Pressure model matching backend BloodPressure entity exactly
/// Backend fields: id, test_date, bp_level (String format: "120/80"), image_url, user_id
class BloodPressure {
  final int id;
  final String
  testDate; // Backend uses LocalDate, sent as ISO string (YYYY-MM-DD)
  final String bpLevel; // Format: "systolic/diastolic" e.g., "120/80"
  final String? imageUrl;
  final User? user;

  BloodPressure({
    required this.id,
    required this.testDate,
    required this.bpLevel,
    this.imageUrl,
    this.user,
  });

  /// Parse systolic value from bpLevel string
  int get systolic {
    if (bpLevel.isEmpty || !bpLevel.contains('/')) return 0;
    final parts = bpLevel.split('/');
    if (parts.isEmpty) return 0;
    return int.tryParse(parts[0].trim()) ?? 0;
  }

  /// Parse diastolic value from bpLevel string
  int get diastolic {
    if (bpLevel.isEmpty || !bpLevel.contains('/')) return 0;
    final parts = bpLevel.split('/');
    if (parts.length < 2) return 0;
    return int.tryParse(parts[1].trim()) ?? 0;
  }

  factory BloodPressure.fromJson(Map<String, dynamic> json) {
    return BloodPressure(
      id: json['id'] as int,
      testDate: json['testDate'] as String? ?? '',
      bpLevel: json['bpLevel'] as String? ?? '0/0',
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
      'bpLevel': bpLevel,
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
      'bpLevel': bpLevel,
      'imageUrl': imageUrl,
      'user': {'id': userId},
    };
  }

  /// For updating a record
  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'testDate': testDate,
      'bpLevel': bpLevel,
      'imageUrl': imageUrl,
      'user': user != null ? {'id': user!.id} : null,
    };
  }

  /// Create from systolic and diastolic values
  factory BloodPressure.create({
    int id = 0,
    required String testDate,
    required int systolic,
    required int diastolic,
    String? imageUrl,
    User? user,
  }) {
    return BloodPressure(
      id: id,
      testDate: testDate,
      bpLevel: '$systolic/$diastolic',
      imageUrl: imageUrl,
      user: user,
    );
  }

  BloodPressure copyWith({
    int? id,
    String? testDate,
    String? bpLevel,
    String? imageUrl,
    User? user,
  }) {
    return BloodPressure(
      id: id ?? this.id,
      testDate: testDate ?? this.testDate,
      bpLevel: bpLevel ?? this.bpLevel,
      imageUrl: imageUrl ?? this.imageUrl,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'BloodPressure(id: $id, date: $testDate, bp: $bpLevel)';
  }
}
