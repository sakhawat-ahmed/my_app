import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // For Android emulator - use 10.0.2.2
  // For iOS simulator - use localhost
  // For real device - use your computer IP
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // Get headers with authentication token
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    return {
      'Content-Type': 'application/json',
      'Authorization': token != null ? 'Token $token' : '',
    };
  }

  // ==================== AUTHENTICATION ====================
  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Save token and user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('user', json.encode(data['user']));
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['error'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> register(String username, String password, String email, String userType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
          'email': email,
          'user_type': userType,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('user', json.encode(data['user']));
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['error'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // ==================== PROFILE UPDATE ====================
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
        // Update local storage with new user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', json.encode(data['user']));
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['detail'] ?? 'Failed to update profile'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      return Map<String, dynamic>.from(json.decode(userString));
    }
    return null;
  }

  // ==================== PRODUCTS & CATEGORIES ====================
  static Future<Map<String, dynamic>> getHomeData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/home/'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': 'Failed to load home data'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories/'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': 'Failed to load categories'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getProducts({String? category, String? search}) async {
    try {
      final params = <String, String>{};
      if (category != null) params['category'] = category;
      if (search != null) params['search'] = search;
      
      final uri = Uri.parse('$baseUrl/products/').replace(queryParameters: params);
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': 'Failed to load products'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getProductDetail(int productId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/$productId/'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': 'Failed to load product details'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // ==================== CART OPERATIONS ====================
  static Future<Map<String, dynamic>> getCart() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/cart/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': 'Failed to load cart'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> addToCart(int productId, int quantity) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/cart/'),
        headers: headers,
        body: json.encode({
          'product': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true};
      } else {
        return {'success': false, 'error': 'Failed to add to cart'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateCartItem(int cartItemId, int quantity) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/cart/$cartItemId/'),
        headers: headers,
        body: json.encode({
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'error': 'Failed to update cart'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> removeFromCart(int cartItemId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/cart/$cartItemId/'),
        headers: headers,
      );

      if (response.statusCode == 204) {
        return {'success': true};
      } else {
        return {'success': false, 'error': 'Failed to remove from cart'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> clearCart() async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/cart/clear/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'error': 'Failed to clear cart'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // ==================== ORDERS ====================
  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/orders/'),
        headers: headers,
        body: json.encode(orderData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': 'Failed to create order'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getOrders() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/orders/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': 'Failed to load orders'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // ==================== ADDRESSES ====================
  static Future<Map<String, dynamic>> getAddresses() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/addresses/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': 'Failed to load addresses'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> addAddress(Map<String, dynamic> addressData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/addresses/'),
        headers: headers,
        body: json.encode(addressData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': 'Failed to add address'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }
}