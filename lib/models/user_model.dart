class UserModel {
  final String id;
  final String name;
  final String email;
  final String password; // Em produção, usar hash
  double? weight;
  double? height;
  String? goal;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.weight,
    this.height,
    this.goal,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    double? weight,
    double? height,
    String? goal,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      goal: goal ?? this.goal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'weight': weight,
      'height': height,
      'goal': goal,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      weight: map['weight'],
      height: map['height'],
      goal: map['goal'],
    );
  }
} 