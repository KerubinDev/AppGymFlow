import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/workout_model.dart';
import '../models/exercise_model.dart';
import '../providers/workout_provider.dart';
import '../config/routes.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final WorkoutModel workout;

  const WorkoutDetailsScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  bool _isLoading = false;

  Future<void> _toggleExerciseStatus(ExerciseModel exercise) async {
    setState(() => _isLoading = true);
    try {
      final index = widget.workout.exercises.indexOf(exercise);
      final updatedExercises = List<ExerciseModel>.from(widget.workout.exercises);
      updatedExercises[index] = ExerciseModel(
        id: exercise.id,
        name: exercise.name,
        sets: exercise.sets,
        reps: exercise.reps,
        weight: exercise.weight,
        notes: exercise.notes,
        isCompleted: !exercise.isCompleted,
      );

      final updatedWorkout = WorkoutModel(
        id: widget.workout.id,
        userId: widget.workout.userId,
        name: widget.workout.name,
        exercises: updatedExercises,
        date: widget.workout.date,
        isCompleted: updatedExercises.every((e) => e.isCompleted),
      );

      await Provider.of<WorkoutProvider>(context, listen: false)
          .updateWorkout(updatedWorkout);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar exercício: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.workout,
                arguments: widget.workout,
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Card(
                    margin: const EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informações',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _InfoRow(
                            icon: Icons.calendar_today,
                            label: 'Data',
                            value: DateFormat('dd/MM/yyyy')
                                .format(widget.workout.date),
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(
                            icon: Icons.fitness_center,
                            label: 'Exercícios',
                            value: widget.workout.exercises.length.toString(),
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(
                            icon: Icons.check_circle,
                            label: 'Status',
                            value: widget.workout.isCompleted
                                ? 'Concluído'
                                : 'Em andamento',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final exercise = widget.workout.exercises[index];
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: exercise.isCompleted,
                              onChanged: (value) => _toggleExerciseStatus(exercise),
                            ),
                            title: Text(exercise.name),
                            subtitle: Text(
                              '${exercise.sets} séries x ${exercise.reps} repetições' +
                                  (exercise.weight != null
                                      ? ' • ${exercise.weight}kg'
                                      : ''),
                            ),
                            trailing: exercise.notes != null
                                ? IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Observações'),
                                          content: Text(exercise.notes!),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Fechar'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : null,
                          ),
                        );
                      },
                      childCount: widget.workout.exercises.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
} 