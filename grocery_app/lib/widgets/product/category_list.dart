import 'package:flutter/material.dart';
import 'package:grocery_app/data/product_data.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

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
    final height = ResponsiveUtils.responsiveSize(context, mobile: 45, tablet: 50, desktop: 55);

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ProductData.categories.length,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16),
        ),
        itemBuilder: (context, index) {
          final category = ProductData.categories[index];
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.responsiveSize(context, mobile: 3, tablet: 5, desktop: 8),
            ),
            child: ChoiceChip(
              label: Text(
                category,
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveSize(context, mobile: 11, tablet: 13, desktop: 15),
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
                horizontal: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16),
                vertical: ResponsiveUtils.responsiveSize(context, mobile: 2, tablet: 4, desktop: 6),
              ),
            ),
          );
        },
      ),
    );
  }
}