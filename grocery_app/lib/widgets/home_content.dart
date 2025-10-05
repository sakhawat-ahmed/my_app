import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/models/user_model.dart';
import 'package:grocery_app/widgets/category_list.dart';
import 'package:grocery_app/widgets/product_grid.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/theme_provider.dart';

class HomeContent extends StatelessWidget {
  final String selectedCategory;
  final User? user;
  final Function(String) onCategorySelected;

  const HomeContent({
    super.key,
    required this.selectedCategory,
    required this.user,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.responsivePadding(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header with user name
          _buildWelcomeHeader(themeProvider, padding),
          
          // Categories Title
          _buildCategoriesTitle(themeProvider, padding),
          
          // Category List
          CategoryList(
            selectedCategory: selectedCategory,
            onCategorySelected: onCategorySelected,
          ),
          
          // Products Title with results count
          _buildProductsTitle(themeProvider, padding),
          
          // Products Grid
          Expanded(
            child: ProductGrid(category: selectedCategory),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(ThemeProvider themeProvider, EdgeInsets padding) {
    return Padding(
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
            user != null 
              ? 'Hello, ${user!.name}!'
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
    );
  }

  Widget _buildCategoriesTitle(ThemeProvider themeProvider, EdgeInsets padding) {
    return Padding(
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
    );
  }

  Widget _buildProductsTitle(ThemeProvider themeProvider, EdgeInsets padding) {
    return Padding(
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
    );
  }
}