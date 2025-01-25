import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final SharedPreferences prefs;
  late ThemeMode _themeMode;

  ThemeProvider(this.prefs) {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void _loadTheme() {
    final isDark = prefs.getBool('is_dark') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await prefs.setBool('is_dark', mode == ThemeMode.dark);
    notifyListeners();
  }
} 