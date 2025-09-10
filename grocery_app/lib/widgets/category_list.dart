import 'package:flutter/material.dart';
import 'package:grocery_app/data/product_data.dart';

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
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ProductData.categories.length,
        itemBuilder: (context, index) {
          final category = ProductData.categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: selectedCategory == category,
              onSelected: (selected) {
                onCategorySelected(category);
              },
              selectedColor: Colors.green,
              labelStyle: TextStyle(
                color: selectedCategory == category ? Colors.white : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}