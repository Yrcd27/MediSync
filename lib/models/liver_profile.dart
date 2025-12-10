import 'user.dart';

class LiverProfile {
  final int id;
  final String testDate;
  final double alt;
  final double ast;
  final double alp;
  final double totalBilirubin;
  final double directBilirubin;
  final double albumin;
  final String? imageUrl;
  final User user;

  LiverProfile({
    required this.id,
    required this.testDate,
    required this.alt,
    required this.ast,
    required this.alp,
    required this.totalBilirubin,
    required this.directBilirubin,
    required this.albumin,
    this.imageUrl,
    required this.user,
  });

  factory LiverProfile.fromJson(Map<String, dynamic> json) {
    return LiverProfile(
      id: json['id'] as int,
      testDate: json['testDate'] as String,
      alt: (json['alt'] as num).toDouble(),
      ast: (json['ast'] as num).toDouble(),
      alp: (json['alp'] as num).toDouble(),
      totalBilirubin: (json['totalBilirubin'] as num).toDouble(),
      directBilirubin: (json['directBilirubin'] as num).toDouble(),
      albumin: (json['albumin'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testDate': testDate,
      'alt': alt,
      'ast': ast,
      'alp': alp,
      'totalBilirubin': totalBilirubin,
      'directBilirubin': directBilirubin,
      'albumin': albumin,
      'imageUrl': imageUrl,
      'user': user.toJson(),
    };
  }

  Map<String, dynamic> toCreateJson(int userId) {
    return {
      'testDate': testDate,
      'alt': alt,
      'ast': ast,
      'alp': alp,
      'totalBilirubin': totalBilirubin,
      'directBilirubin': directBilirubin,
      'albumin': albumin,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }
}
