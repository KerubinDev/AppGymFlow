import 'package:flutter/material.dart';
import 'package:shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _key = 'theme_mode';
  final SharedPreferences _prefs;
  late ThemeMode _themeMode;

  ThemeProvider(this._prefs) {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  void _loadThemeMode() {
    final value = _prefs.getString(_key);
    _themeMode = value == 'dark'
        ? ThemeMode.dark
        : value == 'light'
            ? ThemeMode.light
            : ThemeMode.system;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString(
      _key,
      mode == ThemeMode.dark
          ? 'dark'
          : mode == ThemeMode.light
              ? 'light'
              : 'system',
    );
    notifyListeners();
  }
} 