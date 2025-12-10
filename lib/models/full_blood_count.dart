import 'user.dart';

class FullBloodCount {
  final int id;
  final String testDate;
  final double hemoglobin;
  final double wbcCount;
  final double rbcCount;
  final double plateletCount;
  final double hematocrit;
  final double mcv;
  final double mch;
  final double mchc;
  final String? imageUrl;
  final User user;

  FullBloodCount({
    required this.id,
    required this.testDate,
    required this.hemoglobin,
    required this.wbcCount,
    required this.rbcCount,
    required this.plateletCount,
    required this.hematocrit,
    required this.mcv,
    required this.mch,
    required this.mchc,
    this.imageUrl,
    required this.user,
  });

  factory FullBloodCount.fromJson(Map<String, dynamic> json) {
    return FullBloodCount(
      id: json['id'] as int,
      testDate: json['testDate'] as String,
      hemoglobin: (json['hemoglobin'] as num).toDouble(),
      wbcCount: (json['wbcCount'] as num).toDouble(),
      rbcCount: (json['rbcCount'] as num).toDouble(),
      plateletCount: (json['plateletCount'] as num).toDouble(),
      hematocrit: (json['hematocrit'] as num).toDouble(),
      mcv: (json['mcv'] as num).toDouble(),
      mch: (json['mch'] as num).toDouble(),
      mchc: (json['mchc'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testDate': testDate,
      'hemoglobin': hemoglobin,
      'wbcCount': wbcCount,
      'rbcCount': rbcCount,
      'plateletCount': plateletCount,
      'hematocrit': hematocrit,
      'mcv': mcv,
      'mch': mch,
      'mchc': mchc,
      'imageUrl': imageUrl,
      'user': user.toJson(),
    };
  }

  Map<String, dynamic> toCreateJson(int userId) {
    return {
      'testDate': testDate,
      'hemoglobin': hemoglobin,
      'wbcCount': wbcCount,
      'rbcCount': rbcCount,
      'plateletCount': plateletCount,
      'hematocrit': hematocrit,
      'mcv': mcv,
      'mch': mch,
      'mchc': mchc,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }
}
