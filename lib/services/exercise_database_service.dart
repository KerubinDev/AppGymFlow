import 'dart:convert';
import 'package:flutter/services.dart';

class ExerciseDatabaseService {
  static const String _dbPath = 'assets/data/exercises_db.json';
  
  Future<List<Map<String, dynamic>>> getExercises() async {
    try {
      final String jsonString = await rootBundle.loadString(_dbPath);
      final Map<String, dynamic> data = json.decode(jsonString);
      
      List<Map<String, dynamic>> allExercises = [];
      for (var group in data['muscleGroups']) {
        if (group['exercises'] != null) {
          final exercises = List<Map<String, dynamic>>.from(group['exercises']);
          // Adiciona o grupo muscular a cada exercício
          for (var exercise in exercises) {
            exercise['muscleGroup'] = group['name'];
          }
          allExercises.addAll(exercises);
        }
      }
      
      return allExercises;
    } catch (e) {
      print('Erro ao carregar exercícios: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getExercisesByCategory(int categoryId) async {
    try {
      final String jsonString = await rootBundle.loadString(_dbPath);
      final Map<String, dynamic> data = json.decode(jsonString);
      
      List<Map<String, dynamic>> categoryExercises = [];
      for (var group in data['muscleGroups']) {
        if (group['exercises'] != null) {
          final exercises = List<Map<String, dynamic>>.from(group['exercises'])
              .where((e) => e['category'] == categoryId)
              .toList();
          
          // Adiciona o grupo muscular a cada exercício
          for (var exercise in exercises) {
            exercise['muscleGroup'] = group['name'];
          }
          categoryExercises.addAll(exercises);
        }
      }
      
      return categoryExercises;
    } catch (e) {
      print('Erro ao carregar exercícios por categoria: $e');
      rethrow;
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