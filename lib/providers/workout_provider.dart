import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';
import '../models/exercise_model.dart';

class WorkoutProvider with ChangeNotifier {
  final List<WorkoutModel> _workouts = [];

  List<WorkoutModel> get workouts => _workouts;

  Future<void> addWorkout(WorkoutModel workout) async {
    _workouts.add(workout);
    notifyListeners();
  }

  Future<void> updateWorkout(WorkoutModel workout) async {
    final index = _workouts.indexWhere((w) => w.id == workout.id);
    if (index != -1) {
      _workouts[index] = workout;
      notifyListeners();
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    _workouts.removeWhere((w) => w.id == workoutId);
    notifyListeners();
  }

  Future<void> toggleExerciseStatus(String workoutId, String exerciseId) async {
    final workoutIndex = _workouts.indexWhere((w) => w.id == workoutId);
    if (workoutIndex != -1) {
      final workout = _workouts[workoutIndex];
      final exerciseIndex = workout.exercises.indexWhere((e) => e.id == exerciseId);
      if (exerciseIndex != -1) {
        final exercise = workout.exercises[exerciseIndex];
        final updatedExercise = ExerciseModel(
          id: exercise.id,
          name: exercise.name,
          sets: exercise.sets,
          reps: exercise.reps,
          weight: exercise.weight,
          notes: exercise.notes,
          isCompleted: !exercise.isCompleted,
        );
        final updatedExercises = List<ExerciseModel>.from(workout.exercises);
        updatedExercises[exerciseIndex] = updatedExercise;
        
        _workouts[workoutIndex] = WorkoutModel(
          id: workout.id,
          userId: workout.userId,
          name: workout.name,
          exercises: updatedExercises,
          date: workout.date,
          isCompleted: workout.isCompleted,
        );
        notifyListeners();
      }
    }
  }
} 