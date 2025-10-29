import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class CategoryList extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final List<dynamic> categories; // Add this parameter

  const CategoryList({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.categories, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final height = ResponsiveUtils.responsiveSize(context, mobile: 45, tablet: 50, desktop: 55);

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16),
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryName = _getCategoryName(category);
          final categoryId = _getCategoryId(category);
          
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.responsiveSize(context, mobile: 3, tablet: 5, desktop: 8),
            ),
            child: ChoiceChip(
              label: Text(
                categoryName,
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveSize(context, mobile: 11, tablet: 13, desktop: 15),
                ),
              ),
              selected: selectedCategory == categoryName || selectedCategory == categoryId,
              onSelected: (selected) {
                onCategorySelected(categoryName);
              },
              selectedColor: Colors.green,
              labelStyle: TextStyle(
                color: selectedCategory == categoryName ? Colors.white : Colors.black,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16),
                vertical: ResponsiveUtils.responsiveSize(context, mobile: 2, tablet: 4, desktop: 6),
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper method to get category name from different data structures
  String _getCategoryName(dynamic category) {
    if (category is String) {
      return category;
    } else if (category is Map<String, dynamic>) {
      return category['name'] ?? 'Category';
    }
    return 'Category';
  }

  // Helper method to get category ID
  String _getCategoryId(dynamic category) {
    if (category is Map<String, dynamic>) {
      return category['id']?.toString() ?? '';
    }
    return '';
  }
}