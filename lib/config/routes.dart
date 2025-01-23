import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/workout_screen.dart';
import '../screens/exercise_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';

class Routes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String workout = '/workout';
  static const String exercise = '/exercise';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      welcome: (context) => const WelcomeScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      dashboard: (context) => const DashboardScreen(),
      workout: (context) => const WorkoutScreen(),
      exercise: (context) => const ExerciseScreen(),
      profile: (context) => const ProfileScreen(),
      settings: (context) => const SettingsScreen(),
    };
  }
} 