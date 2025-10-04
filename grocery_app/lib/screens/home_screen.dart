import 'package:flutter/material.dart';
import 'package:grocery_app/models/user_model.dart';
import 'package:grocery_app/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/screens/cart_screen.dart';
import 'package:grocery_app/screens/profile_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/screens/favorites_screen.dart';
import 'package:grocery_app/widgets/category_list.dart';
import 'package:grocery_app/widgets/product_grid.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/favorites_provider.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:grocery_app/services/auth_services.dart';
import 'package:grocery_app/data/product_data.dart';
import 'package:grocery_app/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  User? _currentUser;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Product> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    final user = await AuthService.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final query = _searchController.text.toLowerCase();
    
    final results = ProductData.products.where((product) {
      final productName = product.name.toLowerCase();
      final productDescription = product.description.toLowerCase();
      final productCategory = product.category.toLowerCase();

      return productName.contains(query) ||
          productDescription.contains(query) ||
          productCategory.contains(query);
    }).toList();

    setState(() {
      _searchResults = results;
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocusNode.requestFocus();
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _searchResults = [];
    });
    _searchFocusNode.unfocus();
  }

  Future<void> _logout() async {
    try {
      await AuthService.logout();
      
      // Clear cart when logging out
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.clear();
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error logging out'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveSize(context, mobile: 18, tablet: 20, desktop: 22),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.responsivePadding(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Material(
      child: Stack(
        children: [
          // Main Content
          Scaffold(
            appBar: _isSearching ? null : _buildAppBar(context),
            body: _buildBody(context, themeProvider, padding),
            floatingActionButton: _isSearching ? null : _buildFloatingActionButton(),
            bottomNavigationBar: _isSearching ? null : _buildBottomNavigationBar(context),
            drawer: _isSearching ? null : _buildDrawer(context),
          ),

          // Search Overlay
          if (_isSearching) _buildSearchOverlay(context, themeProvider, padding),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Grocery Store',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: ResponsiveUtils.titleFontSize(context),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.black),
      // Removed all actions - no cart or profile icons
    );
  }

  Widget _buildBody(BuildContext context, ThemeProvider themeProvider, EdgeInsets padding) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header with user name
          if (!_isSearching)
            Padding(
              padding: EdgeInsets.fromLTRB(
                padding.left,
                padding.top,
                padding.right,
                padding.bottom / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentUser != null 
                      ? 'Hello, ${_currentUser!.name}!'
                      : 'Hello, Welcome!',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.responsiveSize(context, mobile: 18, tablet: 20, desktop: 22),
                      fontWeight: FontWeight.bold,
                      color: themeProvider.textColor,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8)),
                  Text(
                    'Find the best groceries for your needs',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
                      color: themeProvider.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

          // Categories Title
          if (!_isSearching)
            Padding(
              padding: EdgeInsets.fromLTRB(
                padding.left,
                0,
                padding.right,
                ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16),
              ),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                  fontWeight: FontWeight.bold,
                  color: themeProvider.textColor,
                ),
              ),
            ),

          // Category List
          if (!_isSearching)
            CategoryList(
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),

          // Products Title with results count
          if (!_isSearching)
            Padding(
              padding: EdgeInsets.fromLTRB(
                padding.left,
                ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24),
                padding.right,
                ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedCategory == 'All' ? 'All Products' : selectedCategory,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                      fontWeight: FontWeight.bold,
                      color: themeProvider.textColor,
                    ),
                  ),
                  Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      return Text(
                        '${cartProvider.itemCount} items in cart',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 14, desktop: 16),
                          color: Colors.green,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

          // Products Grid or Search Results
          Expanded(
            child: _isSearching && _searchController.text.isNotEmpty
                ? _buildSearchResults(context, themeProvider, padding)
                : ProductGrid(category: selectedCategory),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchOverlay(BuildContext context, ThemeProvider themeProvider, EdgeInsets padding) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar at top
              Container(
                color: themeProvider.scaffoldBackgroundColor,
                padding: EdgeInsets.all(padding.left),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: themeProvider.inputFillColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            hintStyle: TextStyle(
                              color: themeProvider.secondaryTextColor,
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: themeProvider.secondaryTextColor,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: themeProvider.secondaryTextColor,
                                    ),
                                    onPressed: _stopSearch,
                                  )
                                : null,
                          ),
                          style: TextStyle(
                            color: themeProvider.textColor,
                            fontSize: 16,
                          ),
                          autofocus: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _stopSearch,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Search Results or Empty State
              Expanded(
                child: Container(
                  color: themeProvider.scaffoldBackgroundColor,
                  child: _searchController.text.isEmpty
                      ? _buildSearchHint(themeProvider)
                      : _searchResults.isEmpty
                          ? _buildNoResultsState(themeProvider)
                          : _buildSearchResults(context, themeProvider, padding),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHint(ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 60,
            color: themeProvider.secondaryTextColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Search for products',
            style: TextStyle(
              fontSize: 18,
              color: themeProvider.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60,
            color: themeProvider.secondaryTextColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              color: themeProvider.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords',
            style: TextStyle(
              fontSize: 14,
              color: themeProvider.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, ThemeProvider themeProvider, EdgeInsets padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding.left),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveUtils.gridCrossAxisCount(context),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final product = _searchResults[index];
          return ProductCard(product: product);
        },
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

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey[600],
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              return Stack(
                children: [
                  const Icon(Icons.favorite),
                  if (favoritesProvider.favoriteCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          favoritesProvider.favoriteCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          label: 'Favorites',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        if (index == 3) {
          // Profile
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (index == 2) {
          // Favorites
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoritesScreen()),
          );
        } else if (index == 1) {
          // Search - iOS style overlay
          _startSearch();
        }
        // Home (index 0) stays on current screen
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _currentUser?.name ?? 'Guest',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentUser?.email ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.green),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag, color: Colors.green),
            title: const Text('My Orders'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.green),
            title: const Text('Favorites'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.green),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.grey),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }
}