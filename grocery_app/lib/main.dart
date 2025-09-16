import 'package:flutter/material.dart';
import 'package:grocery_app/screens/home_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/screens/splash_screen.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/services/auth_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Grocery App',
        theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          splashColor: Colors.green[100],
          highlightColor: Colors.green[50],
        ),
        home: FutureBuilder(
          future: AuthService.getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                return const HomeScreen();
              } else {
                return const LoginScreen();
              }
            }
          },
        ),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}