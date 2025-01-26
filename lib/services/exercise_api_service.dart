import 'package:dio/dio.dart';

class ExerciseApiService {
  final Dio _dio = Dio();
  static const String baseUrl = 'https://wger.de/api/v2';

  Future<List<Map<String, dynamic>>> getExercises() async {
    try {
      final response = await _dio.get(
        '$baseUrl/exercise/?language=13&limit=100',
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
        '$baseUrl/exercise/?muscles=$muscleId&language=13&limit=100',
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

  // Mapa de tradução para os grupos musculares
  static const Map<String, String> muscleTranslations = {
    'Anterior deltoid': 'Deltóide Anterior',
    'Biceps brachii': 'Bíceps',
    'Biceps femoris': 'Bíceps Femoral',
    'Brachialis': 'Braquial',
    'Gastrocnemius': 'Panturrilha',
    'Gluteus maximus': 'Glúteos',
    'Latissimus dorsi': 'Dorsal',
    'Obliquus externus abdominis': 'Abdômen',
    'Pectoralis major': 'Peitoral',
    'Quadriceps femoris': 'Quadríceps',
    'Rectus abdominis': 'Abdômen Reto',
    'Serratus anterior': 'Serrátil',
    'Soleus': 'Sóleo',
    'Trapezius': 'Trapézio',
    'Triceps brachii': 'Tríceps'
  };

  Future<List<Map<String, dynamic>>> getMuscles() async {
    try {
      final response = await _dio.get(
        '$baseUrl/muscle/',
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final muscles = List<Map<String, dynamic>>.from(data['results']);
        
        // Traduzir os nomes dos músculos
        return muscles.map((muscle) {
          return {
            ...muscle,
            'name': muscleTranslations[muscle['name']] ?? muscle['name'],
          };
        }).toList();
      } else {
        throw Exception('Falha ao carregar músculos');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
} 