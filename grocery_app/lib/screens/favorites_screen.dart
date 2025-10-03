import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/favorites_provider.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:grocery_app/widgets/product_card.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final padding = ResponsiveUtils.responsivePadding(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Favorites',
          style: TextStyle(
            fontSize: ResponsiveUtils.titleFontSize(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: themeProvider.scaffoldBackgroundColor,
        foregroundColor: themeProvider.textColor,
        elevation: 0,
      ),
      body: favoritesProvider.favoriteProducts.isEmpty
          ? _buildEmptyState(context, themeProvider)
          : _buildFavoritesList(context, favoritesProvider, themeProvider, padding),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: themeProvider.secondaryTextColor,
          ),
          SizedBox(height: 20),
          Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeProvider.textColor,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Start adding products to your favorites!',
            style: TextStyle(
              fontSize: 16,
              color: themeProvider.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Navigate back to home
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text(
              'Browse Products',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(
    BuildContext context,
    FavoritesProvider favoritesProvider,
    ThemeProvider themeProvider,
    EdgeInsets padding,
  ) {
    return Column(
      children: [
        // Header with count
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: padding.left,
            vertical: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${favoritesProvider.favoriteCount} items',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: themeProvider.secondaryTextColor,
                ),
              ),
              if (favoritesProvider.favoriteProducts.isNotEmpty)
                TextButton(
                  onPressed: () {
                    _showClearAllDialog(context, favoritesProvider);
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Products Grid
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding.left),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveUtils.gridCrossAxisCount(context),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: favoritesProvider.favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoritesProvider.favoriteProducts[index];
                return ProductCard(product: product);
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showClearAllDialog(BuildContext context, FavoritesProvider favoritesProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Clear All Favorites?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to remove all items from your favorites?',
            style: TextStyle(
              fontSize: 16,
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
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                favoritesProvider.clearFavorites();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All favorites cleared'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Clear All',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}