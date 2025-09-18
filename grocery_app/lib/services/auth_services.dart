import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'dart:convert';

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
      final userJsonList = users.map((u) => json.encode(u.toMap())).toList();
      await prefs.setStringList(_usersKey, userJsonList);
      
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
        await prefs.setString(_currentUserKey, json.encode(user.toMap()));
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
        final userMap = json.decode(userString);
        return User.fromMap(userMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Logout user
  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get all users
  static Future<List<User>> getUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStrings = prefs.getStringList(_usersKey) ?? [];
      return userStrings.map((string) => User.fromMap(json.decode(string))).toList();
    } catch (e) {
      return [];
    }
  }

  // Update user
  static Future<bool> updateUser(User updatedUser) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final users = await getUsers();
      
      // Find the user index
      final index = users.indexWhere((user) => user.id == updatedUser.id);
      
      if (index != -1) {
        // Update the user
        users[index] = updatedUser;
        
        // Save updated users list
        final userJsonList = users.map((u) => json.encode(u.toMap())).toList();
        await prefs.setStringList(_usersKey, userJsonList);
        
        // Update current user if it's the same user
        final currentUser = await getCurrentUser();
        if (currentUser != null && currentUser.id == updatedUser.id) {
          await prefs.setString(_currentUserKey, json.encode(updatedUser.toMap()));
        }
        
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }
}