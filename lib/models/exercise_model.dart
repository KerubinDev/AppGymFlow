class ExerciseModel {
  final String id;
  final String name;
  int sets;
  int reps;
  double? weight;
  String? notes;
  bool isCompleted;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    this.weight,
    this.notes,
    this.isCompleted = false,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'],
      name: json['name'],
      sets: json['sets'],
      reps: json['reps'],
      weight: json['weight']?.toDouble(),
      notes: json['notes'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }
} 