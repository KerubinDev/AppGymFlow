import 'package:flutter/material.dart';
import '../models/exercise_model.dart';

class ExerciseListItem extends StatelessWidget {
  final ExerciseModel exercise;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExerciseListItem({
    Key? key,
    required this.exercise,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(exercise.name),
        subtitle: Text(
          '${exercise.sets} séries x ${exercise.reps} repetições' +
              (exercise.weight != null ? ' • ${exercise.weight}kg' : ''),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirmar exclusão'),
                    content: const Text(
                      'Tem certeza que deseja excluir este exercício?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onDelete();
                        },
                        child: const Text('Excluir'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 