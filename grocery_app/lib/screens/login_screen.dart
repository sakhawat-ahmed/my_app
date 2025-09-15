import 'package:flutter/material.dart';
import 'package:grocery_app/services/auth_services.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = await AuthService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user != null) {
          Fluttertoast.showToast(
            msg: "Login successful!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Fluttertoast.showToast(
            msg: "Invalid email or password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "An error occurred. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
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

              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildEmailField(),
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

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email Address',
        prefixIcon: const Icon(Icons.email, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
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
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
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
          ),
        ),
        GestureDetector(
          onTap: () {
          },
          child: Text(
            'Register',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}