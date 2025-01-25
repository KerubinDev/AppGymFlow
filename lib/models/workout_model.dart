import 'exercise_model.dart';

class WorkoutModel {
  final String id;
  final String userId;
  final String name;
  final List<ExerciseModel> exercises;
  final DateTime date;
  final bool isCompleted;

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
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      exercises: (json['exercises'] as List)
          .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: DateTime.parse(json['date'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
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

  WorkoutModel copyWith({
    String? id,
    String? userId,
    String? name,
    List<ExerciseModel>? exercises,
    DateTime? date,
    bool? isCompleted,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
} 