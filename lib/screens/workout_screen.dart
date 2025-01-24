import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import '../models/exercise_model.dart';
import '../providers/workout_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/exercise_list_item.dart';
import '../widgets/add_exercise_sheet.dart';

class WorkoutScreen extends StatefulWidget {
  final WorkoutModel? workout;

  const WorkoutScreen({
    Key? key,
    this.workout,
  }) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<ExerciseModel> _exercises = [];
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      _nameController.text = widget.workout!.name;
      _selectedDate = widget.workout!.date;
      _exercises.addAll(widget.workout!.exercises);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addExercise() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddExerciseSheet(
          onSave: (exercise) {
            setState(() {
              _exercises.add(exercise);
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> _saveWorkout() async {
    if (_formKey.currentState!.validate()) {
      final workout = WorkoutModel(
        id: widget.workout?.id ?? DateTime.now().toString(),
        userId: 'user_id', // TODO: Implementar autenticação
        name: _nameController.text,
        exercises: _exercises,
        date: _selectedDate,
      );

      try {
        final provider = Provider.of<WorkoutProvider>(context, listen: false);
        if (widget.workout != null) {
          await provider.updateWorkout(workout);
        } else {
          await provider.addWorkout(workout);
        }
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar treino: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout == null ? 'Novo Treino' : 'Editar Treino'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Treino',
                prefixIcon: Icon(Icons.fitness_center),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Data'),
              subtitle: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
              onTap: _selectDate,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exercícios',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addExercise,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._exercises.map((exercise) => ExerciseListTile(
                  exercise: exercise,
                  onDelete: () {
                    setState(() {
                      _exercises.remove(exercise);
                    });
                  },
                )),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Salvar Treino',
              onPressed: _saveWorkout,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
} 