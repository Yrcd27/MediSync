import 'user.dart';

class LipidProfile {
  final int id;
  final String testDate;
  final double totalCholesterol;
  final double hdl;
  final double ldl;
  final double triglycerides;
  final String? imageUrl;
  final User user;

  LipidProfile({
    required this.id,
    required this.testDate,
    required this.totalCholesterol,
    required this.hdl,
    required this.ldl,
    required this.triglycerides,
    this.imageUrl,
    required this.user,
  });

  factory LipidProfile.fromJson(Map<String, dynamic> json) {
    return LipidProfile(
      id: json['id'] as int,
      testDate: json['testDate'] as String,
      totalCholesterol: (json['totalCholesterol'] as num).toDouble(),
      hdl: (json['hdl'] as num).toDouble(),
      ldl: (json['ldl'] as num).toDouble(),
      triglycerides: (json['triglycerides'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testDate': testDate,
      'totalCholesterol': totalCholesterol,
      'hdl': hdl,
      'ldl': ldl,
      'triglycerides': triglycerides,
      'imageUrl': imageUrl,
      'user': user.toJson(),
    };
  }

  Map<String, dynamic> toCreateJson(int userId) {
    return {
      'testDate': testDate,
      'totalCholesterol': totalCholesterol,
      'hdl': hdl,
      'ldl': ldl,
      'triglycerides': triglycerides,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }
}
