import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'currentUser';
  static const String _themePreferenceKey = 'isDarkMode';
  static const String _authTokenKey = 'authToken';
  
  // Backend API configuration
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const bool _useBackend = true; 

  // ==================== BACKEND API METHODS ====================

  // Get headers with authentication token
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);
    
    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Token $token' : '',
    };
  }

  // Backend user registration
  static Future<Map<String, dynamic>> _registerWithBackend(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': user.name,
          'email': user.email,
          'password': user.password,
          'phone': user.phone,
          'user_type': 'customer', // Default user type
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        
        // Save token and user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_authTokenKey, data['token']);
        await prefs.setString(_currentUserKey, json.encode(data['user']));
        
        return {'success': true, 'user': User.fromMap(data['user'])};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false, 
          'error': error['error'] ?? error['detail'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // Backend user login
  static Future<Map<String, dynamic>> _loginWithBackend(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Save token and user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_authTokenKey, data['token']);
        await prefs.setString(_currentUserKey, json.encode(data['user']));
        
        return {'success': true, 'user': User.fromMap(data['user'])};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false, 
          'error': error['error'] ?? error['detail'] ?? 'Login failed'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // Backend update user profile
  static Future<Map<String, dynamic>> _updateUserWithBackend(User updatedUser) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/auth/profile/update/'),
        headers: headers,
        body: json.encode({
          'username': updatedUser.name,
          'email': updatedUser.email,
          'phone': updatedUser.phone,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Update local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_currentUserKey, json.encode(data['user']));
        
        return {'success': true, 'user': User.fromMap(data['user'])};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false, 
          'error': error['detail'] ?? 'Failed to update profile'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // Backend change password
  static Future<Map<String, dynamic>> _changePasswordWithBackend(
    String currentPassword, String newPassword) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/auth/change-password/'),
        headers: headers,
        body: json.encode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false, 
          'error': error['detail'] ?? 'Failed to change password'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // Check backend connectivity with proper timeout implementation
  static Future<bool> _checkBackendConnectivity() async {
    try {
      // Create a custom client with timeout
      final client = http.Client();
      final response = await client.get(Uri.parse('$baseUrl/health/'));
      client.close(); // Always close the client
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ==================== UNIFIED AUTH METHODS ====================

  // Register new user
  static Future<Map<String, dynamic>> register(User user) async {
    try {
      // Try backend first if enabled
      if (_useBackend) {
        final backendResult = await _registerWithBackend(user);
        if (backendResult['success'] == true) {
          return backendResult;
        }
        // If backend fails, fall back to local storage
        print('Backend registration failed: ${backendResult['error']}. Using local storage.');
      }

      // Local storage registration
      final prefs = await SharedPreferences.getInstance();
      final users = await getUsers();
      
      // Check if email already exists
      if (users.any((u) => u.email == user.email)) {
        return {'success': false, 'error': 'Email already exists'};
      }
      
      // Check if phone already exists
      if (users.any((u) => u.phone == user.phone)) {
        return {'success': false, 'error': 'Phone number already exists'};
      }
      
      users.add(user);
      final userJsonList = users.map((u) => json.encode(u.toJson())).toList();
      await prefs.setStringList(_usersKey, userJsonList);
      
      // Set as current user
      await prefs.setString(_currentUserKey, json.encode(user.toJson()));
      
      return {'success': true, 'user': user};
    } catch (e) {
      return {'success': false, 'error': 'Registration failed: $e'};
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Try backend first if enabled
      if (_useBackend) {
        final backendResult = await _loginWithBackend(email, password);
        if (backendResult['success'] == true) {
          return backendResult;
        }
        // If backend fails, fall back to local storage
        print('Backend login failed: ${backendResult['error']}. Using local storage.');
      }

      // Local storage login
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
        await prefs.setString(_currentUserKey, json.encode(user.toJson()));
        return {'success': true, 'user': user};
      }
      
      return {'success': false, 'error': 'Invalid email or password'};
    } catch (e) {
      return {'success': false, 'error': 'Login failed: $e'};
    }
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_currentUserKey);
      if (userString != null) {
        final userMap = json.decode(userString);
        return User.fromJson(userMap);
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    if (_useBackend) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_authTokenKey);
      return token != null;
    } else {
      final user = await getCurrentUser();
      return user != null;
    }
  }

  // Logout user
  static Future<Map<String, dynamic>> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Clear backend token if exists
      if (_useBackend) {
        final token = prefs.getString(_authTokenKey);
        if (token != null) {
          try {
            final headers = await _getHeaders();
            await http.post(
              Uri.parse('$baseUrl/auth/logout/'),
              headers: headers,
            );
          } catch (e) {
            print('Backend logout failed: $e');
          }
        }
        await prefs.remove(_authTokenKey);
      }
      
      // Clear current user
      await prefs.remove(_currentUserKey);
      
      return {'success': true};
    } catch (e) {
      return {'success': false, 'error': 'Logout failed: $e'};
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateUser(User updatedUser) async {
    try {
      // Try backend first if enabled
      if (_useBackend) {
        final backendResult = await _updateUserWithBackend(updatedUser);
        if (backendResult['success'] == true) {
          return backendResult;
        }
        // If backend fails, fall back to local storage
        print('Backend update failed: ${backendResult['error']}. Using local storage.');
      }

      // Local storage update
      final prefs = await SharedPreferences.getInstance();
      final users = await getUsers();
      
      // Find the user index
      final index = users.indexWhere((user) => user.id == updatedUser.id);
      
      if (index != -1) {
        // Update the user
        users[index] = updatedUser;
        
        // Save updated users list
        final userJsonList = users.map((u) => json.encode(u.toJson())).toList();
        await prefs.setStringList(_usersKey, userJsonList);
        
        // Update current user if it's the same user
        final currentUser = await getCurrentUser();
        if (currentUser != null && currentUser.id == updatedUser.id) {
          await prefs.setString(_currentUserKey, json.encode(updatedUser.toJson()));
        }
        
        return {'success': true, 'user': updatedUser};
      }
      
      return {'success': false, 'error': 'User not found'};
    } catch (e) {
      return {'success': false, 'error': 'Update failed: $e'};
    }
  }

  // Change password
  static Future<Map<String, dynamic>> changePassword(
    String currentPassword, String newPassword) async {
    try {
      // Try backend first if enabled
      if (_useBackend) {
        final backendResult = await _changePasswordWithBackend(currentPassword, newPassword);
        if (backendResult['success'] == true) {
          return backendResult;
        }
        // If backend fails, fall back to local storage
        print('Backend password change failed: ${backendResult['error']}. Using local storage.');
      }

      // Local storage password change
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        return {'success': false, 'error': 'No user logged in'};
      }

      // Verify current password
      if (currentUser.password != currentPassword) {
        return {'success': false, 'error': 'Current password is incorrect'};
      }

      // Update password - create new user instance with updated password
      final updatedUser = User(
        id: currentUser.id,
        name: currentUser.name,
        email: currentUser.email,
        phone: currentUser.phone,
        password: newPassword,
        createdAt: currentUser.createdAt,
        profileImage: currentUser.profileImage,
        userType: currentUser.userType,
      );
      
      final updateResult = await updateUser(updatedUser);
      
      if (updateResult['success'] == true) {
        return {'success': true};
      } else {
        return {'success': false, 'error': updateResult['error']};
      }
    } catch (e) {
      return {'success': false, 'error': 'Password change failed: $e'};
    }
  }

  // Get all users (local storage only)
  static Future<List<User>> getUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStrings = prefs.getStringList(_usersKey) ?? [];
      return userStrings.map((string) => User.fromJson(json.decode(string))).toList();
    } catch (e) {
      return [];
    }
  }

  // ==================== THEME PREFERENCE ====================

  // Save theme preference
  static Future<void> saveThemePreference(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themePreferenceKey, isDarkMode);
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }

  // Get theme preference
  static Future<bool> getThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_themePreferenceKey) ?? false;
    } catch (e) {
      print('Error getting theme preference: $e');
      return false;
    }
  }

  // ==================== UTILITY METHODS ====================

  // Clear all data (for testing/debugging)
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_usersKey);
      await prefs.remove(_currentUserKey);
      await prefs.remove(_authTokenKey);
      await prefs.remove(_themePreferenceKey);
    } catch (e) {
      print('Error clearing data: $e');
    }
  }

  // Get authentication token
  static Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_authTokenKey);
    } catch (e) {
      return null;
    }
  }

  // Check if using backend
  static bool isUsingBackend() {
    return _useBackend;
  }

  // Get backend base URL
  static String getBaseUrl() {
    return baseUrl;
  }
}