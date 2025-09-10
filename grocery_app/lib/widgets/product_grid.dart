import 'package:flutter/material.dart';
import 'package:grocery_app/data/product_data.dart';
import 'package:grocery_app/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final String category;

  const ProductGrid({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final filteredProducts = category == 'All'
        ? ProductData.products
        : ProductData.products.where((product) => product.category == category).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.7,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductCard(product: filteredProducts[index]);
      },
    );
  }
}