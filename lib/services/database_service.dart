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
    final users = await _getUsers();
    users[user.id] = user;
    
    await prefs.setString(_usersKey, jsonEncode(
      users.map((key, value) => MapEntry(key, value.toMap()))
    ));
  }

  Future<UserModel?> getUser(String email, String password) async {
    final users = await _getUsers();
    try {
      return users.values.firstWhere(
        (user) => user.email == email && user.password == password
      );
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> getUserById(String id) async {
    final users = await _getUsers();
    return users[id];
  }

  Future<void> updateUser(UserModel user) async {
    await saveUser(user);
  }

  Future<Map<String, UserModel>> _getUsers() async {
    final prefs = await _prefs;
    final String? usersJson = prefs.getString(_usersKey);
    
    if (usersJson == null) return {};

    final Map<String, dynamic> usersMap = jsonDecode(usersJson);
    return usersMap.map((key, value) => MapEntry(
      key,
      UserModel.fromMap(value as Map<String, dynamic>),
    ));
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