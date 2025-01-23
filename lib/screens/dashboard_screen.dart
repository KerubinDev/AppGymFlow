import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/workout_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/workout_card.dart';
import '../config/routes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userId = Provider.of<AuthProvider>(context, listen: false).currentUser?.uid;
    if (userId != null) {
      try {
        await Future.wait([
          Provider.of<UserProvider>(context, listen: false).fetchUser(userId),
          Provider.of<WorkoutProvider>(context, listen: false).fetchWorkouts(userId),
        ]);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao carregar dados: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    final workouts = Provider.of<WorkoutProvider>(context).workouts;

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${user?.name ?? 'Usuário'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, Routes.profile),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverToBoxAdapter(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Resumo',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Treinos completados: ${workouts.where((w) => w.isCompleted).length}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                'Treinos planejados: ${workouts.where((w) => !w.isCompleted).length}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Próximos Treinos',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Implementar visualização de todos os treinos
                            },
                            child: const Text('Ver Todos'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: workouts.isEmpty
                        ? const SliverToBoxAdapter(
                            child: Center(
                              child: Text('Nenhum treino planejado'),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final workout = workouts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: WorkoutCard(workout: workout),
                                );
                              },
                              childCount: workouts.length,
                            ),
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, Routes.workout),
        label: const Text('Novo Treino'),
        icon: const Icon(Icons.add),
      ),
    );
  }
} 