import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../widgets/custom_button.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final _notificationService = NotificationService();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 0);
  final List<bool> _selectedDays = List.generate(7, (_) => false);
  bool _notificationsEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _notificationService.getNotificationSettings();
    setState(() {
      _notificationsEnabled = settings.enabled;
      _selectedTime = TimeOfDay(
        hour: settings.hour ?? 18,
        minute: settings.minute ?? 0,
      );
      if (settings.days != null) {
        for (int i = 0; i < settings.days!.length; i++) {
          _selectedDays[i] = settings.days![i];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações de Treino'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationSwitch(),
          if (_notificationsEnabled) ...[
            const SizedBox(height: 24),
            _buildTimeSelector(),
            const SizedBox(height: 24),
            _buildDaySelector(),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Salvar Configurações',
              onPressed: _saveSettings,
              isLoading: _isLoading,
            ),
            CustomButton(
              text: 'Testar Notificação',
              onPressed: () async {
                try {
                  // Testa notificação imediata
                  await _notificationService.showTestNotification();
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notificação de teste enviada!'),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao testar notificação: $e'),
                      ),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationSwitch() {
    return Card(
      child: SwitchListTile(
        title: const Text(
          'Ativar Notificações',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(
          'Receba lembretes para seus treinos',
          style: TextStyle(fontSize: 14),
        ),
        value: _notificationsEnabled,
        onChanged: (value) {
          setState(() => _notificationsEnabled = value);
          if (!value) {
            _notificationService.cancelAllNotifications();
          }
        },
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Horário do Lembrete',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectTime,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    final days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dias da Semana',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(7, (index) {
                return FilterChip(
                  label: Text(days[index]),
                  selected: _selectedDays[index],
                  onSelected: (selected) {
                    setState(() => _selectedDays[index] = selected);
                  },
                  selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    
    try {
      await _notificationService.saveNotificationSettings(
        enabled: _notificationsEnabled,
        hour: _selectedTime.hour,
        minute: _selectedTime.minute,
        days: _selectedDays,
      );

      if (_notificationsEnabled) {
        final selectedDayIndices = _selectedDays
            .asMap()
            .entries
            .where((e) => e.value)
            .map((e) => e.key + 1)
            .toList();

        if (selectedDayIndices.isNotEmpty) {
          await _notificationService.scheduleWeeklyWorkoutReminder(
            title: 'Hora do Treino! 💪',
            body: 'Vamos manter o foco e conquistar seus objetivos!',
            scheduledTime: DateTime.now().copyWith(
              hour: _selectedTime.hour,
              minute: _selectedTime.minute,
            ),
            days: selectedDayIndices,
          );
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configurações salvas com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar configurações: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
} 