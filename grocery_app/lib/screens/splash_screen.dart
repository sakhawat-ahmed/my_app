import 'package:flutter/material.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/services/auth_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // Add a small delay to show the splash screen
    await Future.delayed(const Duration(seconds: 2));
    
    final user = await AuthService.getCurrentUser();
    
    if (mounted) {
      if (user != null) {
        // User is logged in, go to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // User is not logged in, go to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[700]!,
              Colors.green[500]!,
              Colors.green[300]!,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shopping cart icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  size: 60,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 30),
              // App name with shadow
              const Text(
                'GROCERY APP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}