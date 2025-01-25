import 'dart:convert';
import 'package:http/http.dart' as http;

class ExerciseApiService {
  static const String baseUrl = 'https://wger.de/api/v2';

  Future<List<Map<String, dynamic>>> getExercises() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exercise/?language=2&limit=100'), // 2 = inglês
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['results']);
      } else {
        throw Exception('Falha ao carregar exercícios');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getExercisesByMuscle(int muscleId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exercise/?muscles=$muscleId&language=2&limit=100'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['results']);
      } else {
        throw Exception('Falha ao carregar exercícios');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMuscles() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/muscle/'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['results']);
      } else {
        throw Exception('Falha ao carregar músculos');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
} 