import 'package:flutter/material.dart';
import 'package:grocery_app/services/api_service.dart'; 
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/screens/register_screen.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:grocery_app/widgets/login/login_header.dart';
import 'package:grocery_app/widgets/login/login_form.dart';
import 'package:grocery_app/widgets/login/login_button.dart';
import 'package:grocery_app/widgets/login/login_error_widget.dart';

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

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void _onPasswordVisibilityChanged() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
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
              const LoginHeader(),
              SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 40, tablet: 60, desktop: 80)),

              // Error Message
              if (_errorMessage != null) 
                LoginErrorWidget(errorMessage: _errorMessage!),
              
              // Login Form
              LoginForm(
                formKey: _formKey,
                usernameController: _usernameController,
                passwordController: _passwordController,
                obscurePassword: _obscurePassword,
                onPasswordVisibilityChanged: _onPasswordVisibilityChanged,
              ),

              // Login Button
              SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32)),
              LoginButton(
                isLoading: _isLoading,
                onPressed: _login,
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
          onTap: _isLoading ? null : _navigateToRegister,
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