import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class AuthProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  UserModel? _currentUser;
  final SharedPreferences _prefs;

  AuthProvider(this._prefs) {
    _loadUser();
  }

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> _loadUser() async {
    final userId = _prefs.getString('userId');
    if (userId != null) {
      // Implementar método para buscar usuário por ID
      _currentUser = await _db.getUserById(userId);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    final user = await _db.getUser(email, password);
    if (user != null) {
      _currentUser = user;
      await _prefs.setString('userId', user.id);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final user = UserModel(
        id: DateTime.now().toString(),
        name: name,
        email: email,
        password: password,
      );
      await _db.saveUser(user);
      _currentUser = user;
      await _prefs.setString('userId', user.id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await _prefs.remove('userId');
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    double? weight,
    double? height,
    String? goal,
  }) async {
    if (_currentUser != null) {
      final updatedUser = _currentUser!.copyWith(
        name: name,
        weight: weight,
        height: height,
        goal: goal,
      );
      await _db.updateUser(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
    }
  }
} 