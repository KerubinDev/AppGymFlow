import 'package:flutter/material.dart';
import '../models/exercise_model.dart';

class ExerciseListTile extends StatelessWidget {
  final ExerciseModel exercise;
  final VoidCallback onDelete;

  const ExerciseListTile({
    Key? key,
    required this.exercise,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(exercise.name),
        subtitle: Text(
          '${exercise.sets} séries x ${exercise.reps} repetições' +
              (exercise.weight != null ? ' • ${exercise.weight}kg' : ''),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
} 