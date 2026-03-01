import 'package:hive/hive.dart';
import '../models/user_model.dart';

class LocalAuthService {
  static const String usersBox = 'users';
  static const String currentUserKey = 'currentUser';
  
  static late Box _usersBox;
  
  static Future<void> init() async {
    _usersBox = await Hive.openBox(usersBox);
  }
  
  // Sign up
  static Future<AppUser?> signUp(String email, String password, String name) async {
    try {
      // Check if user already exists
      final existingUser = _getUserByEmail(email);
      if (existingUser != null) {
        return null; // User already exists
      }
      
      // Create new user
      final user = AppUser(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
      
      // Store user with password (in a real app, hash the password)
      await _usersBox.put(user.id, {
        'user': user,
        'password': password, // In production, store hashed password only
      });
      
      return user;
    } catch (e) {
      print('Sign up error: $e');
      return null;
    }
  }
  
  // Sign in
  static Future<AppUser?> signIn(String email, String password) async {
    try {
      final userData = _getUserByEmail(email);
      if (userData == null) return null;
      
      final storedPassword = userData['password'];
      if (storedPassword != password) return null; // Wrong password
      
      final user = userData['user'] as AppUser;
      
      // Save as current user
      await Hive.box('settings').put(currentUserKey, user.id);
      
      return user;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }
  
  // Get current user
  static Future<AppUser?> getCurrentUser() async {
    try {
      final settingsBox = Hive.box('settings');
      final userId = settingsBox.get(currentUserKey);
      
      if (userId == null) return null;
      
      final userData = _usersBox.get(userId);
      if (userData == null) return null;
      
      return userData['user'] as AppUser;
    } catch (e) {
      return null;
    }
  }
  
  // Sign out
  static Future<void> signOut() async {
    await Hive.box('settings').delete(currentUserKey);
  }
  
  // Helper to find user by email
  static Map? _getUserByEmail(String email) {
    for (var key in _usersBox.keys) {
      final data = _usersBox.get(key);
      final user = data['user'] as AppUser;
      if (user.email == email) {
        return data;
      }
    }
    return null;
  }
}