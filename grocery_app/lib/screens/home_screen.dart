import 'package:flutter/material.dart' hide SearchBar;
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/screens/cart_screen.dart';
import 'package:grocery_app/widgets/category_list.dart';
import 'package:grocery_app/widgets/product_grid.dart';
import 'package:grocery_app/widgets/search_bar.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

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
          if (!isMobile)
            IconButton(
              icon: Icon(
                Icons.account_circle,
                size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
                color: Colors.green,
              ),
              onPressed: () {
                // Navigate to profile screen
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with greeting
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
                    'Hello, Welcome!',
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

      // Floating Action Button for quick access
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
                size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 26, desktop: 28),
              ),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          }
          // Handle other tab clicks
        },
      ),
    );
  }
}