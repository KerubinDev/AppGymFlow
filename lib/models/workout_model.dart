class WorkoutModel {
  final String id;
  final String userId;
  final String name;
  final List<ExerciseModel> exercises;
  final DateTime date;
  bool isCompleted;

  WorkoutModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.exercises,
    required this.date,
    this.isCompleted = false,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      exercises: (json['exercises'] as List)
          .map((e) => ExerciseModel.fromJson(e))
          .toList(),
      date: DateTime.parse(json['date']),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
} 