import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/workout_provider.dart';
import '../models/workout_model.dart';
import '../widgets/workout_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DateFormat _dateFormat = DateFormat('dd/MM');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  List<FlSpot> _getWorkoutSpots(List<WorkoutModel> workouts) {
    final Map<DateTime, int> workoutCounts = {};
    
    for (var workout in workouts) {
      final date = DateTime(workout.date.year, workout.date.month, workout.date.day);
      workoutCounts[date] = (workoutCounts[date] ?? 0) + 1;
    }

    final sortedDates = workoutCounts.keys.toList()..sort();
    return sortedDates
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              workoutCounts[entry.value]!.toDouble(),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<WorkoutProvider>(context).workouts;
    final completedWorkouts = workouts.where((w) => w.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Lista'),
            Tab(text: 'Gráficos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Lista de treinos
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: completedWorkouts.length,
            itemBuilder: (context, index) {
              return WorkoutCard(workout: completedWorkouts[index]);
            },
          ),

          // Tab 2: Gráficos
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Treinos por Semana',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final date = DateTime.fromMillisecondsSinceEpoch(
                                          value.toInt());
                                      return Text(_dateFormat.format(date));
                                    },
                                    reservedSize: 30,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: true),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _getWorkoutSpots(completedWorkouts),
                                  isCurved: true,
                                  color: Theme.of(context).primaryColor,
                                  barWidth: 3,
                                  dotData: FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estatísticas',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _StatisticTile(
                          icon: Icons.fitness_center,
                          title: 'Total de Treinos',
                          value: completedWorkouts.length.toString(),
                        ),
                        _StatisticTile(
                          icon: Icons.timer,
                          title: 'Média de Exercícios por Treino',
                          value: completedWorkouts.isEmpty
                              ? '0'
                              : (completedWorkouts
                                          .map((w) => w.exercises.length)
                                          .reduce((a, b) => a + b) /
                                      completedWorkouts.length)
                                  .toStringAsFixed(1),
                        ),
                        _StatisticTile(
                          icon: Icons.calendar_today,
                          title: 'Treinos este mês',
                          value: completedWorkouts
                              .where((w) =>
                                  w.date.month == DateTime.now().month &&
                                  w.date.year == DateTime.now().year)
                              .length
                              .toString(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _StatisticTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatisticTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
} 