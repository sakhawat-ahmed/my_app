import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onPasswordVisibilityChanged;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onPasswordVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _buildUsernameField(),
          SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28)),
          _buildPasswordField(),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: usernameController,
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
      controller: passwordController,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock, color: Colors.green),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: onPasswordVisibilityChanged,
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
}