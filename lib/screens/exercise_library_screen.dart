import 'package:flutter/material.dart';
import '../services/exercise_api_service.dart';
import '../models/exercise_model.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final ExerciseApiService _api = ExerciseApiService();
  List<Map<String, dynamic>> _exercises = [];
  List<Map<String, dynamic>> _muscles = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int? _selectedMuscleId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final muscles = await _api.getMuscles();
      List<Map<String, dynamic>> exercises;
      
      if (_selectedMuscleId != null) {
        exercises = await _api.getExercisesByMuscle(_selectedMuscleId!);
      } else {
        exercises = await _api.getExercises();
      }

      setState(() {
        _muscles = muscles;
        _exercises = exercises;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar exercícios: $e')),
        );
      }
    }
  }

  void _addExerciseToWorkout(Map<String, dynamic> exercise) {
    final newExercise = ExerciseModel(
      id: DateTime.now().toString(),
      name: exercise['name'],
      sets: 3,
      reps: 12,
    );

    Navigator.pop(context, newExercise);
  }

  @override
  Widget build(BuildContext context) {
    final filteredExercises = _exercises.where((exercise) {
      return exercise['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca de Exercícios'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar exercício',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Todos'),
                  selected: _selectedMuscleId == null,
                  onSelected: (selected) {
                    setState(() => _selectedMuscleId = null);
                    _loadData();
                  },
                ),
                const SizedBox(width: 8),
                ..._muscles.map((muscle) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(muscle['name']),
                      selected: _selectedMuscleId == muscle['id'],
                      onSelected: (selected) {
                        setState(() => _selectedMuscleId = muscle['id']);
                        _loadData();
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          if (_isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: filteredExercises.length,
                itemBuilder: (context, index) {
                  final exercise = filteredExercises[index];
                  return ListTile(
                    title: Text(exercise['name']),
                    subtitle: Text(
                      exercise['description'] ?? 'Sem descrição disponível',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _addExerciseToWorkout(exercise),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
} 