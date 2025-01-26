import 'dart:convert';
import 'package:flutter/services.dart';

class ExerciseDatabaseService {
  static const String _dbPath = 'assets/data/exercises_db.json';
  
  Future<List<Map<String, dynamic>>> getExercises() async {
    try {
      print('Tentando carregar arquivo: $_dbPath'); // Debug
      final String jsonString = await rootBundle.loadString(_dbPath);
      print('Conteúdo carregado: ${jsonString.substring(0, 100)}...'); // Debug
      final Map<String, dynamic> data = json.decode(jsonString);
      
      List<Map<String, dynamic>> allExercises = [];
      for (var group in data['muscleGroups']) {
        allExercises.addAll(List<Map<String, dynamic>>.from(group['exercises']));
      }
      
      return allExercises;
    } catch (e, stackTrace) { // Adicionado stackTrace
      print('Erro detalhado: $e'); // Debug
      print('Stack trace: $stackTrace'); // Debug
      throw Exception('Erro ao carregar exercícios: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getExercisesByCategory(int categoryId) async {
    try {
      final String jsonString = await rootBundle.loadString(_dbPath);
      final Map<String, dynamic> data = json.decode(jsonString);
      
      List<Map<String, dynamic>> categoryExercises = [];
      for (var group in data['muscleGroups']) {
        final exercises = List<Map<String, dynamic>>.from(group['exercises']);
        categoryExercises.addAll(
          exercises.where((e) => e['category'] == categoryId)
        );
      }
      
      return categoryExercises;
    } catch (e) {
      throw Exception('Erro ao carregar exercícios: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMuscleGroups() async {
    try {
      final String jsonString = await rootBundle.loadString(_dbPath);
      final Map<String, dynamic> data = json.decode(jsonString);
      return List<Map<String, dynamic>>.from(data['muscleGroups']);
    } catch (e) {
      throw Exception('Erro ao carregar grupos musculares: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final String jsonString = await rootBundle.loadString(_dbPath);
      final Map<String, dynamic> data = json.decode(jsonString);
      return List<Map<String, dynamic>>.from(data['categories']);
    } catch (e) {
      throw Exception('Erro ao carregar categorias: $e');
    }
  }
} 