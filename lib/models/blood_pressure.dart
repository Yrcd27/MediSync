import 'user.dart';

class BloodPressure {
  final int id;
  final String testDate;
  final int systolic;
  final int diastolic;
  final String? imageUrl;
  final User user;

  BloodPressure({
    required this.id,
    required this.testDate,
    required this.systolic,
    required this.diastolic,
    this.imageUrl,
    required this.user,
  });

  factory BloodPressure.fromJson(Map<String, dynamic> json) {
    return BloodPressure(
      id: json['id'] as int,
      testDate: json['testDate'] as String,
      systolic: json['systolic'] as int,
      diastolic: json['diastolic'] as int,
      imageUrl: json['imageUrl'] as String?,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testDate': testDate,
      'systolic': systolic,
      'diastolic': diastolic,
      'imageUrl': imageUrl,
      'user': user.toJson(),
    };
  }

  Map<String, dynamic> toCreateJson(int userId) {
    return {
      'testDate': testDate,
      'systolic': systolic,
      'diastolic': diastolic,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }
}
