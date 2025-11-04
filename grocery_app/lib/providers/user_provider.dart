// lib/providers/user_provider.dart
import 'package:flutter/foundation.dart';
import 'package:grocery_app/models/user_model.dart';
import 'package:grocery_app/services/auth_services.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  bool _isLoading = false;

  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    _user = (await AuthService.getCurrentUser()) as Map<String, dynamic>?;
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await AuthService.login(username, password);
    
    _isLoading = false;
    
    if (result['success'] == true) {
      _user = result['data']['user'];
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<bool> register(String username, String password, String email, String userType) async {
    _isLoading = true;
    notifyListeners();

    final result = await AuthService.register(username as User, password, email, userType);
    
    _isLoading = false;
    
    if (result['success'] == true) {
      _user = result['data']['user'];
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<bool> updateProfile(Map<String, dynamic> userData) async {
    _isLoading = true;
    notifyListeners();

    final result = await AuthService.updateUserProfile(userData);
    
    _isLoading = false;
    
    if (result['success'] == true) {
      _user = result['data']['user'];
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    final result = await AuthService.changePassword(currentPassword, newPassword);
    return result['success'] == true;
  }

  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    notifyListeners();
  }
}