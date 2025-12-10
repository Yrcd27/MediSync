import 'user.dart';

class FastingBloodSugar {
  final int id;
  final String testDate;
  final double fbsLevel;
  final String? imageUrl;
  final User user;

  FastingBloodSugar({
    required this.id,
    required this.testDate,
    required this.fbsLevel,
    this.imageUrl,
    required this.user,
  });

  factory FastingBloodSugar.fromJson(Map<String, dynamic> json) {
    return FastingBloodSugar(
      id: json['id'] as int,
      testDate: json['testDate'] as String,
      fbsLevel: (json['fbsLevel'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testDate': testDate,
      'fbsLevel': fbsLevel,
      'imageUrl': imageUrl,
      'user': user.toJson(),
    };
  }

  Map<String, dynamic> toCreateJson(int userId) {
    return {
      'testDate': testDate,
      'fbsLevel': fbsLevel,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }
}
