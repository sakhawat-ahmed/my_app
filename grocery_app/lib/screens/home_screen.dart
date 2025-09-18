import 'package:flutter/material.dart' hide SearchBar;
import 'package:grocery_app/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/screens/cart_screen.dart';
import 'package:grocery_app/screens/profile_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/widgets/category_list.dart';
import 'package:grocery_app/widgets/product_grid.dart';
import 'package:grocery_app/widgets/search_bar.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  User? _currentUser;

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final padding = ResponsiveUtils.responsivePadding(context);

    return Scaffold(
      appBar: AppBar(
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
        actions: [
          // Cart Icon with badge
          IconButton(
            icon: Badge(
              label: Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return Text(
                    cartProvider.itemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              child: Icon(
                Icons.shopping_cart,
                size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
                color: Colors.green,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          // User Profile Icon
          if (!isMobile)
            IconButton(
              icon: Icon(
                Icons.account_circle,
                size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
                color: Colors.green,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header with user name
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
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8)),
                  Text(
                    'Find the best groceries for your needs',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: EdgeInsets.fromLTRB(
                padding.left,
                0,
                padding.right,
                padding.bottom / 2,
              ),
              child: SearchBar(controller: _searchController),
            ),

            // Categories Title
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
                  color: Colors.grey[800],
                ),
              ),
            ),

            // Category List
            CategoryList(
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),

            // Products Title with results count
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
                      color: Colors.grey[800],
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

            // Products Grid
            Expanded(
              child: ProductGrid(category: selectedCategory),
            ),
          ],
        ),
      ),

      // Floating Action Button for quick access to cart
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          );
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.shopping_cart),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 26, desktop: 28),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 26, desktop: 28),
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return Badge(
                  label: Text(
                    cartProvider.itemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Icon(
                    Icons.shopping_cart,
                    size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 26, desktop: 28),
                  ),
                );
              },
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 26, desktop: 28),
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 26, desktop: 28),
            ),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            // Cart
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          } else if (index == 4) {
            // Profile
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          } else if (index == 1) {
            // Search - focus on search field
            FocusScope.of(context).requestFocus(FocusNode());
            Future.delayed(const Duration(milliseconds: 100), () {
              _searchController.selection = TextSelection.fromPosition(
                TextPosition(offset: _searchController.text.length),
              );
            });
          }
          // Handle other tab clicks if needed
        },
      ),

      // Drawer for additional options
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
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
                  SizedBox(height: 10),
                  Text(
                    _currentUser?.name ?? 'Guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _currentUser?.email ?? '',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.green),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag, color: Colors.green),
              title: Text('My Orders'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to orders screen
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.green),
              title: Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to favorites screen
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.green),
              title: Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to notifications screen
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings screen
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: Colors.grey),
              title: Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to help screen
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
    );
  }
}