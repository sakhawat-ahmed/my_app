import 'package:flutter/material.dart' hide SearchBar;
import 'package:grocery_app/widgets/category_list.dart';
import 'package:grocery_app/widgets/product_grid.dart';
import 'package:grocery_app/widgets/search_bar.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';

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
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
            ),
            onPressed: () {
              // Navigate to cart screen
            },
          ),
          if (!isMobile)
            IconButton(
              icon: Icon(
                Icons.account_circle,
                size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
              ),
              onPressed: () {},
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: padding,
              child: const SearchBar(),
            ),
            CategoryList(
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
            Expanded(
              child: ProductGrid(category: selectedCategory),
            ),
          ],
        ),
      ),
    );
  }
}