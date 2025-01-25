import 'package:dio/dio.dart';

class ExerciseApiService {
  final Dio _dio = Dio();
  static const String baseUrl = 'https://wger.de/api/v2';

  Future<List<Map<String, dynamic>>> getExercises() async {
    try {
      final response = await _dio.get(
        '$baseUrl/exercise/?language=2&limit=100',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
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
      final response = await _dio.get(
        '$baseUrl/exercise/?muscles=$muscleId&language=2&limit=100',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
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
      final response = await _dio.get(
        '$baseUrl/muscle/',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return List<Map<String, dynamic>>.from(data['results']);
      } else {
        throw Exception('Falha ao carregar músculos');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
} 