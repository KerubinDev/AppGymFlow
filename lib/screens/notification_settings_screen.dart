import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/notification_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Notificações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Ativar Notificações'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
              if (!value) {
                _notificationService.cancelAllNotifications();
              }
            },
          ),
          if (_notificationsEnabled) ...[
            const SizedBox(height: 16),
            const Text(
              'Horário do Lembrete',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text(
                '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.access_time),
              onTap: _selectTime,
            ),
            const SizedBox(height: 16),
            const Text(
              'Dias da Semana',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _DayChip(
                  label: 'D',
                  selected: _selectedDays[6],
                  onSelected: (value) => _updateDay(6, value),
                ),
                _DayChip(
                  label: 'S',
                  selected: _selectedDays[0],
                  onSelected: (value) => _updateDay(0, value),
                ),
                _DayChip(
                  label: 'T',
                  selected: _selectedDays[1],
                  onSelected: (value) => _updateDay(1, value),
                ),
                _DayChip(
                  label: 'Q',
                  selected: _selectedDays[2],
                  onSelected: (value) => _updateDay(2, value),
                ),
                _DayChip(
                  label: 'Q',
                  selected: _selectedDays[3],
                  onSelected: (value) => _updateDay(3, value),
                ),
                _DayChip(
                  label: 'S',
                  selected: _selectedDays[4],
                  onSelected: (value) => _updateDay(4, value),
                ),
                _DayChip(
                  label: 'S',
                  selected: _selectedDays[5],
                  onSelected: (value) => _updateDay(5, value),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _scheduleNotifications,
              child: const Text('Salvar Configurações'),
            ),
          ],
        ],
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

  void _updateDay(int index, bool selected) {
    setState(() => _selectedDays[index] = selected);
  }

  Future<void> _scheduleNotifications() async {
    await _notificationService.cancelAllNotifications();

    final selectedDayIndices = _selectedDays
        .asMap()
        .entries
        .where((e) => e.value)
        .map((e) => e.key + 1)
        .toList();

    if (selectedDayIndices.isNotEmpty) {
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      await _notificationService.scheduleWeeklyWorkoutReminder(
        title: 'Hora do Treino! 💪',
        body: 'Não se esqueça do seu treino de hoje!',
        scheduledTime: scheduledTime,
        days: selectedDayIndices,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notificações configuradas com sucesso!')),
        );
      }
    }
  }
}

class _DayChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _DayChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
    );
  }
} 