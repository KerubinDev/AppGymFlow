import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout_model.dart';
import '../models/exercise_model.dart';
import '../config/routes.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutModel workout;

  const WorkoutCard({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(workout.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exercícios: ${workout.exercises.length}'),
            if (workout.exercises.isNotEmpty)
              Wrap(
                spacing: 8,
                children: workout.exercises
                    .take(3)
                    .map((ExerciseModel e) => Chip(
                          label: Text(e.name),
                          backgroundColor: Colors.grey[200],
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
} 