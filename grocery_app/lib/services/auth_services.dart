import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'currentUser';
  static const String _themePreferenceKey = 'isDarkMode';
  static const String _authTokenKey = 'authToken';
  
  static const String baseUrl = 'http://10.0.2.2:8000/api';

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
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String userType = 'customer',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': name,
          'email': email,
          'password': password,
          'password2': password, // For Django serializer compatibility
          'phone': phone,
          'user_type': userType,
        }),
      );

      print('Registration response: ${response.statusCode}');
      print('Registration body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          // Save token and user data
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_authTokenKey, data['token']);
          await prefs.setString(_currentUserKey, json.encode(data['user']));
          
          return {
            'success': true, 
            'user': User.fromJson(data['user']),
            'token': data['token'],
            'message': data['message'] ?? 'Registration successful'
          };
        } else {
          return {
            'success': false, 
            'error': data['error'] ?? 'Registration failed'
          };
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false, 
          'error': _parseError(errorData)
        };
      }
    } catch (e) {
      return {
        'success': false, 
        'error': 'Network error: $e'
      };
    }
  }

  // Backend user login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Login response: ${response.statusCode}');
      print('Login body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          // Save token and user data
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_authTokenKey, data['token']);
          await prefs.setString(_currentUserKey, json.encode(data['user']));
          
          return {
            'success': true, 
            'user': User.fromJson(data['user']),
            'token': data['token'],
            'message': data['message'] ?? 'Login successful'
          };
        } else {
          return {
            'success': false, 
            'error': data['error'] ?? 'Login failed'
          };
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false, 
          'error': _parseError(errorData)
        };
      }
    } catch (e) {
      return {
        'success': false, 
        'error': 'Network error: $e'
      };
    }
  }

  // Backend update user profile
  static Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/auth/profile/update/'),
        headers: headers,
        body: json.encode(userData),
      );

      print('Update profile response: ${response.statusCode}');
      print('Update profile body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          // Update local storage
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_currentUserKey, json.encode(data['user']));
          
          return {
            'success': true, 
            'user': User.fromJson(data['user']),
            'message': data['message'] ?? 'Profile updated successfully'
          };
        } else {
          return {
            'success': false, 
            'error': data['error'] ?? 'Profile update failed'
          };
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false, 
          'error': _parseError(errorData)
        };
      }
    } catch (e) {
      return {
        'success': false, 
        'error': 'Network error: $e'
      };
    }
  }

  // Backend change password
  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
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

      print('Change password response: ${response.statusCode}');
      print('Change password body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          return {
            'success': true,
            'message': data['message'] ?? 'Password changed successfully'
          };
        } else {
          return {
            'success': false, 
            'error': data['error'] ?? 'Password change failed'
          };
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false, 
          'error': _parseError(errorData)
        };
      }
    } catch (e) {
      return {
        'success': false, 
        'error': 'Network error: $e'
      };
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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);
    final user = await getCurrentUser();
    return token != null && user != null;
  }

  // Logout user
  static Future<Map<String, dynamic>> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_authTokenKey);
      
      // Try backend logout if token exists
      if (token != null) {
        try {
          final headers = await _getHeaders();
          final response = await http.post(
            Uri.parse('$baseUrl/auth/logout/'),
            headers: headers,
          );
          print('Backend logout response: ${response.statusCode}');
        } catch (e) {
          print('Backend logout failed: $e');
        }
      }
      
      // Clear local storage
      await prefs.remove(_authTokenKey);
      await prefs.remove(_currentUserKey);
      
      return {
        'success': true,
        'message': 'Logged out successfully'
      };
    } catch (e) {
      return {
        'success': false, 
        'error': 'Logout failed: $e'
      };
    }
  }

  // Health check
  static Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data
        };
      } else {
        return {
          'success': false,
          'error': 'Backend health check failed'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Cannot connect to backend: $e'
      };
    }
  }

  // Test backend connection
  static Future<bool> testConnection() async {
    try {
      final result = await healthCheck();
      return result['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // Theme preference methods
  static Future<void> saveThemePreference(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themePreferenceKey, isDarkMode);
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }

  static Future<bool> getThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_themePreferenceKey) ?? false;
    } catch (e) {
      print('Error getting theme preference: $e');
      return false;
    }
  }

  // Get authentication token
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  // Helper method to parse errors
  static String _parseError(dynamic errorData) {
    if (errorData is String) return errorData;
    
    if (errorData is Map<String, dynamic>) {
      // Check for direct error message
      if (errorData['error'] is String) return errorData['error'];
      if (errorData['detail'] is String) return errorData['detail'];
      if (errorData['message'] is String) return errorData['message'];
      
      // Handle Django serializer errors
      final errors = <String>[];
      errorData.forEach((key, value) {
        if (value is List) {
          errors.add('${key.replaceAll('_', ' ')}: ${value.join(", ")}');
        } else if (value is String) {
          errors.add('${key.replaceAll('_', ' ')}: $value');
        }
      });
      
      if (errors.isNotEmpty) {
        return errors.join('\n');
      }
    }
    
    return 'An unexpected error occurred';
  }

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
}