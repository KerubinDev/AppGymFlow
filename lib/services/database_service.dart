import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();
  final String _usersKey = 'users';
  final String _workoutsKey = 'workouts';
  
  DatabaseService._();
  factory DatabaseService() => _instance;

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // Métodos para Usuários
  Future<void> saveUser(UserModel user) async {
    final prefs = await _prefs;
    List<Map<String, dynamic>> users = [];
    
    final usersJson = prefs.getString(_usersKey);
    if (usersJson != null) {
      users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
    }
    
    users.add(user.toMap());
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  Future<UserModel?> getUser(String email, String password) async {
    final prefs = await _prefs;
    final usersJson = prefs.getString(_usersKey);
    if (usersJson != null) {
      final List<dynamic> users = jsonDecode(usersJson);
      final userMap = users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => null,
      );
      if (userMap != null) {
        return UserModel.fromMap(userMap as Map<String, dynamic>);
      }
    }
    return null;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final prefs = await _prefs;
    final usersJson = prefs.getString(_usersKey);
    if (usersJson != null) {
      final List<dynamic> users = jsonDecode(usersJson);
      final userMap = users.firstWhere(
        (u) => u['email'] == email,
        orElse: () => null,
      );
      if (userMap != null) {
        return UserModel.fromMap(userMap as Map<String, dynamic>);
      }
    }
    return null;
  }

  Future<UserModel?> getUserById(String id) async {
    final prefs = await _prefs;
    final usersJson = prefs.getString(_usersKey);
    if (usersJson != null) {
      final List<dynamic> users = jsonDecode(usersJson);
      final userMap = users.firstWhere(
        (u) => u['id'] == id,
        orElse: () => null,
      );
      if (userMap != null) {
        return UserModel.fromMap(userMap as Map<String, dynamic>);
      }
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    final prefs = await _prefs;
    final usersJson = prefs.getString(_usersKey);
    if (usersJson != null) {
      List<Map<String, dynamic>> users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
      final index = users.indexWhere((u) => u['id'] == user.id);
      if (index != -1) {
        users[index] = user.toMap();
        await prefs.setString(_usersKey, jsonEncode(users));
      }
    }
  }

  // Métodos para Workouts
  Future<void> saveWorkout(WorkoutModel workout) async {
    final prefs = await _prefs;
    final workouts = await getWorkouts();
    
    // Remover workout existente com mesmo ID antes de adicionar
    workouts.removeWhere((w) => w.id == workout.id);
    workouts.add(workout);
    
    await prefs.setString(_workoutsKey, jsonEncode(
      workouts.map((w) => w.toJson()).toList(),
    ));
  }

  Future<List<WorkoutModel>> getWorkouts() async {
    final prefs = await _prefs;
    final String? workoutsJson = prefs.getString(_workoutsKey);
    
    if (workoutsJson == null) return [];

    final List<dynamic> workoutsList = jsonDecode(workoutsJson);
    return workoutsList
        .map((w) => WorkoutModel.fromJson(w as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteWorkout(String id) async {
    final prefs = await _prefs;
    final workouts = await getWorkouts();
    workouts.removeWhere((w) => w.id == id);
    
    await prefs.setString(_workoutsKey, jsonEncode(
      workouts.map((w) => w.toJson()).toList(),
    ));
  }
} 