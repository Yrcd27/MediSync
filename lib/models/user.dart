/// User model matching backend User entity exactly
/// Backend fields: id, name, email, pwd, dob, gender, height, weight, blood_group
class User {
  final int id;
  final String name;
  final String email;
  final String? password; // Only used for registration/login, not returned by backend
  final String dateOfBirth; // Backend uses LocalDate, sent as ISO string
  final String gender;
  final double height;
  final double weight;
  final String bloodGroup;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    required this.dateOfBirth,
    required this.gender,
    required this.height,
    required this.weight,
    required this.bloodGroup,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String?, // Usually null from backend due to @JsonProperty(WRITE_ONLY)
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      bloodGroup: json['bloodGroup'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'height': height,
      'weight': weight,
      'bloodGroup': bloodGroup,
    };
  }

  /// For registration - includes password
  Map<String, dynamic> toRegistrationJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'height': height,
      'weight': weight,
      'bloodGroup': bloodGroup,
    };
  }

  /// For update - includes id and password
  Map<String, dynamic> toUpdateJson(String currentPassword) {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': currentPassword,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'height': height,
      'weight': weight,
      'bloodGroup': bloodGroup,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? dateOfBirth,
    String? gender,
    double? height,
    double? weight,
    String? bloodGroup,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bloodGroup: bloodGroup ?? this.bloodGroup,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, gender: $gender)';
  }
}
