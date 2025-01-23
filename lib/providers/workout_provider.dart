import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_model.dart';

class WorkoutProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<WorkoutModel> _workouts = [];

  List<WorkoutModel> get workouts => _workouts;

  Future<void> fetchWorkouts(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('workouts')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      _workouts = snapshot.docs
          .map((doc) => WorkoutModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching workouts: $e');
      rethrow;
    }
  }

  Future<void> addWorkout(WorkoutModel workout) async {
    try {
      final docRef = await _firestore.collection('workouts').add(workout.toJson());
      final newWorkout = WorkoutModel.fromJson({
        'id': docRef.id,
        ...workout.toJson(),
      });
      _workouts.insert(0, newWorkout);
      notifyListeners();
    } catch (e) {
      print('Error adding workout: $e');
      rethrow;
    }
  }

  Future<void> updateWorkout(WorkoutModel workout) async {
    try {
      await _firestore
          .collection('workouts')
          .doc(workout.id)
          .update(workout.toJson());

      final index = _workouts.indexWhere((w) => w.id == workout.id);
      if (index != -1) {
        _workouts[index] = workout;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating workout: $e');
      rethrow;
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      await _firestore.collection('workouts').doc(workoutId).delete();
      _workouts.removeWhere((w) => w.id == workoutId);
      notifyListeners();
    } catch (e) {
      print('Error deleting workout: $e');
      rethrow;
    }
  }
} 