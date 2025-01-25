class ExerciseModel {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final double? weight;
  final String? notes;
  final bool isCompleted;

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
      id: json['id'] as String,
      name: json['name'] as String,
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      weight: json['weight'] as double?,
      notes: json['notes'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
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

  ExerciseModel copyWith({
    String? id,
    String? name,
    int? sets,
    int? reps,
    double? weight,
    String? notes,
    bool? isCompleted,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
} 