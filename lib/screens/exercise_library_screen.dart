import 'package:flutter/material.dart';
import '../services/exercise_database_service.dart';
import '../models/exercise_model.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  final ExerciseDatabaseService _db = ExerciseDatabaseService();
  List<Map<String, dynamic>> _exercises = [];
  List<Map<String, dynamic>> _muscleGroups = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedMuscleGroup;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final muscleGroups = await _db.getMuscleGroups();
      List<Map<String, dynamic>> exercises;
      
      if (_selectedMuscleGroup != null) {
        final groupId = int.parse(_selectedMuscleGroup!);
        final selectedGroup = muscleGroups.firstWhere((g) => g['id'] == groupId);
        exercises = List<Map<String, dynamic>>.from(selectedGroup['exercises']);
      } else {
        exercises = [];
        for (var group in muscleGroups) {
          if (group['exercises'] != null) {
            final groupExercises = List<Map<String, dynamic>>.from(group['exercises']);
            for (var exercise in groupExercises) {
              exercise['muscleGroup'] = group['name'];
            }
            exercises.addAll(groupExercises);
          }
        }
      }

      setState(() {
        _muscleGroups = muscleGroups;
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

  List<Map<String, dynamic>> _getFilteredExercises() {
    return _exercises.where((exercise) {
      final name = exercise['name'].toString().toLowerCase();
      final searchMatch = name.contains(_searchQuery.toLowerCase());
      
      if (_selectedMuscleGroup == null) {
        return searchMatch;
      }
      
      final groupId = int.parse(_selectedMuscleGroup!);
      final exerciseGroupId = exercise['category'];
      return searchMatch && exerciseGroupId == groupId;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredExercises = _getFilteredExercises();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca de Exercícios'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar exercício',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Todos'),
                  selected: _selectedMuscleGroup == null,
                  onSelected: (selected) {
                    setState(() => _selectedMuscleGroup = null);
                    _loadData();
                  },
                  selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
                const SizedBox(width: 8),
                ..._muscleGroups.map((muscle) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(muscle['name']),
                      selected: _selectedMuscleGroup == muscle['id'].toString(),
                      onSelected: (selected) {
                        setState(() => _selectedMuscleGroup = muscle['id'].toString());
                        _loadData();
                      },
                      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
                padding: const EdgeInsets.all(16),
                itemCount: filteredExercises.length,
                itemBuilder: (context, index) {
                  final exercise = filteredExercises[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        exercise['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'Grupo: ${exercise['muscleGroup'] ?? 'Não especificado'}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            exercise['description'] ?? 'Sem descrição disponível',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle),
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () => _addExerciseToWorkout(exercise),
                      ),
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