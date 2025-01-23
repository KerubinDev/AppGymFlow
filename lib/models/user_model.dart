class UserModel {
  final String id;
  final String name;
  final String email;
  String? photoUrl;
  double? weight;
  double? height;
  String? goal;
  DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.weight,
    this.height,
    this.goal,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      goal: json['goal'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'weight': weight,
      'height': height,
      'goal': goal,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
} 