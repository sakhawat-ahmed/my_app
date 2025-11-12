import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _currentUserKey = 'currentUser';
  static const String _themePreferenceKey = 'isDarkMode';
  static const String _authTokenKey = 'authToken';
  
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);
    
    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Token $token' : '',
    };
  }

  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? phone,
    String userType = 'customer',
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
          'password2': password,
          'phone': phone,
          'user_type': userType,
          'first_name': firstName,
          'last_name': lastName,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
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

  static Future<Map<String, dynamic>> login({
    String? username,
    String? email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          if (username != null) 'username': username,
          if (email != null) 'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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

  static Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/auth/profile/update/'),
        headers: headers,
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_currentUserKey, json.encode(data['user']));
        
        return {
          'success': true, 
          'user': User.fromJson(data['user']),
          'message': data['message'] ?? 'Profile updated successfully'
        };
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

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Password changed successfully'
        };
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

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);
    return token != null;
  }

  static Future<Map<String, dynamic>> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
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

  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  static String _parseError(dynamic errorData) {
    if (errorData is String) return errorData;
    if (errorData['error'] is String) return errorData['error'];
    if (errorData['detail'] is String) return errorData['detail'];
    if (errorData is Map<String, dynamic>) {
      final errors = <String>[];
      errorData.forEach((key, value) {
        if (value is List) {
          errors.add('${key.replaceAll('_', ' ')}: ${value.join(", ")}');
        } else if (value is String) {
          errors.add('${key.replaceAll('_', ' ')}: $value');
        }
      });
      if (errors.isNotEmpty) return errors.join('\n');
    }
    return 'An unexpected error occurred';
  }
}