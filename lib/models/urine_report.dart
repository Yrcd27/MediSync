import 'user.dart';

class UrineReport {
  final int id;
  final String testDate;
  final String color;
  final String appearance;
  final double ph;
  final double specificGravity;
  final String protein;
  final String glucose;
  final String ketones;
  final String blood;
  final String microscopicExam;
  final String? imageUrl;
  final User user;

  UrineReport({
    required this.id,
    required this.testDate,
    required this.color,
    required this.appearance,
    required this.ph,
    required this.specificGravity,
    required this.protein,
    required this.glucose,
    required this.ketones,
    required this.blood,
    required this.microscopicExam,
    this.imageUrl,
    required this.user,
  });

  factory UrineReport.fromJson(Map<String, dynamic> json) {
    return UrineReport(
      id: json['id'] as int,
      testDate: json['testDate'] as String,
      color: json['color'] as String,
      appearance: json['appearance'] as String,
      ph: (json['ph'] as num).toDouble(),
      specificGravity: (json['specificGravity'] as num).toDouble(),
      protein: json['protein'] as String,
      glucose: json['glucose'] as String,
      ketones: json['ketones'] as String,
      blood: json['blood'] as String,
      microscopicExam: json['microscopicExam'] as String,
      imageUrl: json['imageUrl'] as String?,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testDate': testDate,
      'color': color,
      'appearance': appearance,
      'ph': ph,
      'specificGravity': specificGravity,
      'protein': protein,
      'glucose': glucose,
      'ketones': ketones,
      'blood': blood,
      'microscopicExam': microscopicExam,
      'imageUrl': imageUrl,
      'user': user.toJson(),
    };
  }

  Map<String, dynamic> toCreateJson(int userId) {
    return {
      'testDate': testDate,
      'color': color,
      'appearance': appearance,
      'ph': ph,
      'specificGravity': specificGravity,
      'protein': protein,
      'glucose': glucose,
      'ketones': ketones,
      'blood': blood,
      'microscopicExam': microscopicExam,
      'imageUrl': imageUrl,
      'userId': userId,
    };
  }
}
