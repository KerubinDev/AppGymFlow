import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import '../models/exercise_model.dart';
import '../providers/workout_provider.dart';
import 'workout_screen.dart';

class WorkoutDetailsScreen extends StatelessWidget {
  final WorkoutModel workout;

  const WorkoutDetailsScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutScreen(workout: workout),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data: ${workout.date.day}/${workout.date.month}/${workout.date.year}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Exercícios: ${workout.exercises.length}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Lista de Exercícios',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...workout.exercises.map((exercise) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(exercise.name),
                  subtitle: Text(
                    '${exercise.sets} séries x ${exercise.reps} repetições' +
                        (exercise.weight != null ? ' • ${exercise.weight}kg' : ''),
                  ),
                  trailing: Checkbox(
                    value: exercise.isCompleted,
                    onChanged: (value) {
                      if (value != null) {
                        final provider = Provider.of<WorkoutProvider>(
                          context,
                          listen: false,
                        );
                        provider.toggleExerciseStatus(workout.id, exercise.id);
                      }
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }
} 