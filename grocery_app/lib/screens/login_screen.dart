import 'package:flutter/material.dart';
import 'package:grocery_app/services/api_service.dart'; 
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/screens/register_screen.dart';
import 'package:grocery_app/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(); 
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        // Use the new ApiService instead of AuthService
        final result = await ApiService.login(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          setState(() {
            _errorMessage = result['error'];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage ?? 'Login failed'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Network error: Please check your connection';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage ?? 'An error occurred. Please try again.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.responsivePadding(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Column(
            children: [
              // Header
              SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 40, tablet: 60, desktop: 80)),
              _buildHeader(),
              SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 40, tablet: 60, desktop: 80)),

              // Error Message
              if (_errorMessage != null) _buildErrorWidget(),
              
              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildUsernameField(), // Changed from email to username
                    SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28)),
                    _buildPasswordField(),
                    SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32)),
                    _buildLoginButton(),
                  ],
                ),
              ),

              // Register Link
              SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32)),
              _buildRegisterLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.shopping_cart,
          size: ResponsiveUtils.responsiveSize(context, mobile: 80, tablet: 100, desktop: 120),
          color: Colors.green,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
        Text(
          'Sign in to continue shopping',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 14, desktop: 16)),
      margin: EdgeInsets.only(bottom: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700], size: 20),
          SizedBox(width: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 10, desktop: 12)),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 15, desktop: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Username',
        hintText: 'Enter your username',
        prefixIcon: const Icon(Icons.person, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your username';
        }
        if (value.length < 3) {
          return 'Username must be at least 3 characters';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock, color: Colors.green),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        child: _isLoading
            ? SizedBox(
                height: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 22, desktop: 24),
                width: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 22, desktop: 24),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Login',
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
            color: Colors.grey[600],
          ),
        ),
        GestureDetector(
          onTap: _isLoading
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
          child: Text(
            'Register',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
              color: Colors.green,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}