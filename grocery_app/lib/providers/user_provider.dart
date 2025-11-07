import 'package:flutter/foundation.dart';
import 'package:grocery_app/models/user_model.dart';
import 'package:grocery_app/services/auth_services.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get error => _error;

  Future<void> loadUser() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await AuthService.getCurrentUser();
    } catch (e) {
      _error = 'Failed to load user: $e';
      if (kDebugMode) {
        print('Error loading user: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await AuthService.login(
        email: email,
        password: password,
      );
      
      _isLoading = false;
      
      if (result['success'] == true) {
        _user = result['user'] as User;
        notifyListeners();
        return true;
      } else {
        _error = result['error'] as String?;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Login failed: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String userType = 'customer',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await AuthService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        userType: userType,
      );
      
      _isLoading = false;
      
      if (result['success'] == true) {
        _user = result['user'] as User;
        notifyListeners();
        return true;
      } else {
        _error = result['error'] as String?;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Registration failed: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> userData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await AuthService.updateUserProfile(userData);
      
      _isLoading = false;
      
      if (result['success'] == true) {
        _user = result['user'] as User;
        notifyListeners();
        return true;
      } else {
        _error = result['error'] as String?;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Profile update failed: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await AuthService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      _isLoading = false;
      
      if (result['success'] == true) {
        notifyListeners();
        return true;
      } else {
        _error = result['error'] as String?;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Password change failed: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await AuthService.logout();
      _user = null;
    } catch (e) {
      _error = 'Logout failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear any error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}