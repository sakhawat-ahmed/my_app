import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_app/models/user_model.dart';

class AuthService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'currentUser';

  // Register new user
  static Future<bool> register(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final users = await getUsers();
      
      // Check if email already exists
      if (users.any((u) => u.email == user.email)) {
        return false;
      }
      
      // Check if phone already exists
      if (users.any((u) => u.phone == user.phone)) {
        return false;
      }
      
      users.add(user);
      final userMaps = users.map((u) => u.toMap()).toList();
      await prefs.setStringList(_usersKey, userMaps.map((map) => _encodeMap(map)).toList());
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Login user
  static Future<User?> login(String email, String password) async {
    try {
      final users = await getUsers();
      final user = users.firstWhere(
        (u) => u.email == email && u.password == password,
        orElse: () => User(
          id: '',
          name: '',
          email: '',
          phone: '',
          password: '',
          createdAt: DateTime.now(),
        ),
      );
      
      if (user.id.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_currentUserKey, _encodeMap(user.toMap()));
        return user;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_currentUserKey);
      if (userString != null) {
        final userMap = _decodeMap(userString);
        return User.fromMap(userMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // Get all users
  static Future<List<User>> getUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStrings = prefs.getStringList(_usersKey) ?? [];
      return userStrings.map((string) => User.fromMap(_decodeMap(string))).toList();
    } catch (e) {
      return [];
    }
  }

  // Helper methods for encoding/decoding maps
  static String _encodeMap(Map<String, dynamic> map) {
    return map.entries.map((e) => '${e.key}:${e.value}').join(';');
  }

  static Map<String, dynamic> _decodeMap(String string) {
    final map = <String, dynamic>{};
    final pairs = string.split(';');
    for (final pair in pairs) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        map[parts[0]] = parts[1];
      }
    }
    return map;
  }
}