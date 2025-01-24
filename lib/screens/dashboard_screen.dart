import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../widgets/workout_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Treinos'),
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          final workouts = workoutProvider.workouts;
          
          if (workouts.isEmpty) {
            return const Center(
              child: Text('Nenhum treino cadastrado'),
            );
          }

          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              return WorkoutCard(workout: workouts[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar adição de treino
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Em desenvolvimento')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 