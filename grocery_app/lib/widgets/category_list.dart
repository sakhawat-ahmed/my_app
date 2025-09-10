import 'package:flutter/material.dart';
import 'package:grocery_app/data/product_data.dart';
import '../utils/responsive_utils.dart';

class CategoryList extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryList({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final height = ResponsiveUtils.responsiveSize(context, mobile: 50, tablet: 60, desktop: 70);

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ProductData.categories.length,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 16, desktop: 24),
        ),
        itemBuilder: (context, index) {
          final category = ProductData.categories[index];
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 8, desktop: 12),
            ),
            child: ChoiceChip(
              label: Text(
                category,
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 14, desktop: 16),
                ),
              ),
              selected: selectedCategory == category,
              onSelected: (selected) {
                onCategorySelected(category);
              },
              selectedColor: Colors.green,
              labelStyle: TextStyle(
                color: selectedCategory == category ? Colors.white : Colors.black,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20),
                vertical: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8),
              ),
            ),
          );
        },
      ),
    );
  }
}