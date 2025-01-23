import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/workout_model.dart';
import '../models/exercise_model.dart';
import '../providers/workout_provider.dart';
import '../widgets/exercise_list_item.dart';
import '../config/routes.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final List<ExerciseModel> _exercises = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final WorkoutModel? workout =
          ModalRoute.of(context)?.settings.arguments as WorkoutModel?;
      if (workout != null) {
        _nameController.text = workout.name;
        setState(() {
          _selectedDate = workout.date;
          _exercises.addAll(workout.exercises);
        });
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveWorkout() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final workoutProvider =
            Provider.of<WorkoutProvider>(context, listen: false);
        final workout = WorkoutModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: 'user_id', // TODO: Get from AuthProvider
          name: _nameController.text,
          exercises: _exercises,
          date: _selectedDate,
        );
        await workoutProvider.addWorkout(workout);
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar treino: ${e.toString()}')),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Treino'),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveWorkout,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Treino',
                      prefixIcon: Icon(Icons.fitness_center),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um nome para o treino';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Data',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: _exercises.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum exercício adicionado',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _exercises.length,
                      itemBuilder: (context, index) {
                        return ExerciseListItem(
                          exercise: _exercises[index],
                          onEdit: () {
                            Navigator.pushNamed(
                              context,
                              Routes.exercise,
                              arguments: _exercises[index],
                            ).then((updatedExercise) {
                              if (updatedExercise != null) {
                                setState(() {
                                  _exercises[index] = updatedExercise as ExerciseModel;
                                });
                              }
                            });
                          },
                          onDelete: () {
                            setState(() {
                              _exercises.removeAt(index);
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.exercise).then((exercise) {
            if (exercise != null) {
              setState(() {
                _exercises.add(exercise as ExerciseModel);
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
} 