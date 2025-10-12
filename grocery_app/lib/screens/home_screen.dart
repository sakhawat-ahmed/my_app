import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/models/user_model.dart';
import 'package:grocery_app/screens/cart_screen.dart';
import 'package:grocery_app/screens/profile_screen.dart';
import 'package:grocery_app/screens/favorites_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/screens/search_screen.dart';
import 'package:grocery_app/widgets/home/home_app_bar.dart';
import 'package:grocery_app/widgets/home/home_drawer.dart';
import 'package:grocery_app/widgets/home/home_content.dart';
import 'package:grocery_app/widgets/home/home_bottom_nav.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/favorites_provider.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:grocery_app/services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  User? _currentUser;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await AuthService.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _onBottomNavTapped(int index) {
    switch (index) {
      case 0: // Home - already there
        break;
      case 1: // Search
        _startSearch();
        break;
      case 2: // Favorites
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoritesScreen()),
        );
        break;
      case 3: // Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          // Main Content
          Scaffold(
            appBar: _isSearching ? null : HomeAppBar(user: _currentUser),
            body: HomeContent(
              selectedCategory: selectedCategory,
              user: _currentUser,
              onCategorySelected: _onCategorySelected,
            ),
            floatingActionButton: _isSearching 
                ? null 
                : _buildFloatingActionButton(),
            bottomNavigationBar: _isSearching 
                ? null 
                : HomeBottomNav(
                    onItemTapped: _onBottomNavTapped,
                  ),
            drawer: _isSearching ? null : HomeDrawer(user: _currentUser),
          ),

          // Search Overlay
          if (_isSearching)
            SearchScreen(
              onClose: _stopSearch,
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
      },
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      child: const Icon(Icons.shopping_cart),
    );
  }
}