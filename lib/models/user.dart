class User {
  final int id;
  final String name;
  final String email;
  final String? password;
  final String dateOfBirth;
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
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      dateOfBirth: json['dateOfBirth'] as String,
      gender: json['gender'] as String,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      bloodGroup: json['bloodGroup'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'height': height,
      'weight': weight,
      'bloodGroup': bloodGroup,
    };
    // Only include password if it's not null (will be added separately in updateUser)
    if (password != null) {
      json['password'] = password!;
    }
    return json;
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
}
