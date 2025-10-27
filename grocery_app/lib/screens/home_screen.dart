import 'package:flutter/material.dart';
import 'package:grocery_app/services/api_service.dart'; 
import 'package:grocery_app/screens/cart_screen.dart';
import 'package:grocery_app/screens/profile_screen.dart';
import 'package:grocery_app/screens/favorites_screen.dart';
import 'package:grocery_app/screens/search_screen.dart';
import 'package:grocery_app/widgets/home/home_app_bar.dart';
import 'package:grocery_app/widgets/home/home_drawer.dart';
import 'package:grocery_app/widgets/home/home_content.dart';
import 'package:grocery_app/widgets/home/home_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  Map<String, dynamic>? _currentUser;
  bool _isSearching = false;
  bool _isLoading = true;
  Map<String, dynamic>? _homeData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      // Load user data and home data in parallel
      final userFuture = ApiService.getCurrentUser();
      final homeDataFuture = ApiService.getHomeData();

      final user = await userFuture;
      final homeResult = await homeDataFuture;

      setState(() {
        _currentUser = user;
        if (homeResult['success'] == true) {
          _homeData = homeResult['data'];
        } else {
          _errorMessage = homeResult['error'];
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
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
          MaterialPageRoute(builder: (context) => ProfileScreen(user: _currentUser)),
        );
        break;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    await _loadInitialData();
  }

  void _handleLogout() async {
    await ApiService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          // Main Content
          Scaffold(
            appBar: _isSearching 
                ? null 
                : HomeAppBar(
                    user: _currentUser,
                    onLogout: _handleLogout,
                  ),
            body: _buildBody(),
            floatingActionButton: _isSearching || _isLoading
                ? null 
                : _buildFloatingActionButton(),
            bottomNavigationBar: _isSearching || _isLoading
                ? null 
                : HomeBottomNav(
                    onItemTapped: _onBottomNavTapped,
                  ),
            drawer: _isSearching || _isLoading ? null : HomeDrawer(user: _currentUser),
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

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load data',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: HomeContent(
        selectedCategory: selectedCategory,
        user: _currentUser,
        homeData: _homeData,
        onCategorySelected: _onCategorySelected,
        onRefresh: _refreshData,
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