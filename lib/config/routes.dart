import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/dashboard_screen.dart';

class Routes {
  static const String welcome = '/';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      welcome: (context) => const WelcomeScreen(),
      dashboard: (context) => const DashboardScreen(),
    };
  }
} 