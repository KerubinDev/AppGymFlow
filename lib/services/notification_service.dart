import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';

class NotificationSettings {
  final bool enabled;
  final int? hour;
  final int? minute;
  final List<bool>? days;

  NotificationSettings({
    required this.enabled,
    this.hour,
    this.minute,
    this.days,
  });
}

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  static const String _settingsKey = 'notification_settings';
  static const String _enabledKey = 'notifications_enabled';
  static const String _hourKey = 'notification_hour';
  static const String _minuteKey = 'notification_minute';
  static const String _daysKey = 'notification_days';

  Future<void> initialize() async {
    // Inicializa timezone
    tz.initializeTimeZones();
    
    // Configurações para Android
    const androidSettings = AndroidNotificationDetails(
      'workout_reminders',
      'Lembretes de Treino',
      channelDescription: 'Notificações para lembretes de treino',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      enableLights: true,
      color: Color.fromARGB(255, 33, 150, 243),
      ledColor: Color.fromARGB(255, 33, 150, 243),
      ledOnMs: 1000,
      ledOffMs: 500,
    );

    // Configurações para iOS
    const iosSettings = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      badgeNumber: 1,
    );

    // Configurações de inicialização
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
      ),
    );

    // Inicializa o plugin
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Solicita permissões (importante para iOS e Android 13+)
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Permissões para iOS
    await _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Permissões para Android (API 33+)
    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  }

  Future<NotificationSettings> getNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return NotificationSettings(
      enabled: prefs.getBool(_enabledKey) ?? false,
      hour: prefs.getInt(_hourKey),
      minute: prefs.getInt(_minuteKey),
      days: prefs.getStringList(_daysKey)?.map((e) => e == 'true').toList(),
    );
  }

  Future<void> saveNotificationSettings({
    required bool enabled,
    required int hour,
    required int minute,
    required List<bool> days,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);
    await prefs.setInt(_hourKey, hour);
    await prefs.setInt(_minuteKey, minute);
    await prefs.setStringList(
      _daysKey,
      days.map((e) => e.toString()).toList(),
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    // Implementar navegação quando a notificação for tocada
  }

  Future<void> showWorkoutReminder({
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'workout_reminders',
      'Lembretes de Treino',
      channelDescription: 'Notificações para lembretes de treino',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleWeeklyWorkoutReminder({
    required String title,
    required String body,
    required DateTime scheduledTime,
    required List<int> days,
  }) async {
    print('Agendando notificações para os dias: $days'); // Debug

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'workout_reminders',
        'Lembretes de Treino',
        channelDescription: 'Notificações para lembretes de treino',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        badgeNumber: 1,
      ),
    );

    // Cancela notificações existentes antes de agendar novas
    await cancelAllNotifications();

    for (final day in days) {
      final scheduledDate = _nextInstanceOfDay(scheduledTime, day);
      
      print('Agendando para: ${scheduledDate.toString()}'); // Debug
      
      try {
        await _notifications.zonedSchedule(
          day, // ID único para cada dia
          title,
          body,
          scheduledDate,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
        print('Notificação agendada com sucesso para dia $day'); // Debug
      } catch (e) {
        print('Erro ao agendar notificação: $e'); // Debug
      }
    }
  }

  tz.TZDateTime _nextInstanceOfDay(DateTime time, int day) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
} 