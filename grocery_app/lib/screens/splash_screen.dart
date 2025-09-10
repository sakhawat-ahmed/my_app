import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = ResponsiveUtils.responsiveSize(context, mobile: 80, tablet: 100, desktop: 120);
    final titleSize = ResponsiveUtils.responsiveSize(context, mobile: 28, tablet: 32, desktop: 36);
    final taglineSize = ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18);

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
          child: Padding(
            padding: ResponsiveUtils.responsivePadding(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Shopping cart icon
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(iconSize / 2),
                  ),
                  child: Icon(
                    Icons.shopping_cart,
                    size: iconSize * 0.6,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 30, desktop: 40)),
                // App name with shadow
                Text(
                  'GROCERY APP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
                // Tagline
                Text(
                  'Fresh • Quality • Convenient',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: taglineSize,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 40, tablet: 50, desktop: 60)),
                // Loading indicator
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}