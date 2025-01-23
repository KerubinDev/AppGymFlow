import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout_model.dart';
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
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.workout,
            arguments: workout,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    workout.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Chip(
                    label: Text(
                      workout.isCompleted ? 'Concluído' : 'Pendente',
                      style: TextStyle(
                        color: workout.isCompleted ? Colors.white : Colors.black87,
                      ),
                    ),
                    backgroundColor: workout.isCompleted
                        ? Colors.green
                        : Colors.grey[300],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Data: ${DateFormat('dd/MM/yyyy').format(workout.date)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Exercícios: ${workout.exercises.length}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (workout.exercises.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: workout.exercises
                      .take(3)
                      .map((e) => Chip(
                            label: Text(e.name),
                            backgroundColor: Colors.grey[200],
                          ))
                      .toList(),
                ),
                if (workout.exercises.length > 3)
                  Text(
                    '+ ${workout.exercises.length - 3} exercícios',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 