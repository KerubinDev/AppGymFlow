import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';
import '../models/exercise_model.dart';
import '../services/database_service.dart';

class WorkoutProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<WorkoutModel> _workouts = [];

  List<WorkoutModel> get workouts => _workouts;

  Future<void> loadWorkouts() async {
    _workouts = await _db.getWorkouts();
    notifyListeners();
  }

  Future<void> addWorkout(WorkoutModel workout) async {
    await _db.saveWorkout(workout);
    await loadWorkouts();
  }

  Future<void> updateWorkout(WorkoutModel workout) async {
    await _db.saveWorkout(workout);
    await loadWorkouts();
  }

  Future<void> deleteWorkout(String workoutId) async {
    await _db.deleteWorkout(workoutId);
    await loadWorkouts();
  }

  Future<void> toggleExerciseStatus(String workoutId, String exerciseId) async {
    final workoutIndex = _workouts.indexWhere((w) => w.id == workoutId);
    if (workoutIndex != -1) {
      final workout = _workouts[workoutIndex];
      final updatedExercises = [...workout.exercises];
      final exerciseIndex = updatedExercises.indexWhere((e) => e.id == exerciseId);
      
      if (exerciseIndex != -1) {
        final exercise = updatedExercises[exerciseIndex];
        updatedExercises[exerciseIndex] = exercise.copyWith(
          isCompleted: !exercise.isCompleted,
        );
        
        final updatedWorkout = workout.copyWith(
          exercises: updatedExercises,
        );
        
        await updateWorkout(updatedWorkout);
      }
    }
  }
} 