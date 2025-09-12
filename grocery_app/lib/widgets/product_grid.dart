import 'package:flutter/material.dart';
import 'package:grocery_app/data/product_data.dart';
import 'package:grocery_app/widgets/product_card.dart';
import '../utils/responsive_utils.dart';

class ProductGrid extends StatelessWidget {
  final String category;

  const ProductGrid({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final filteredProducts = category == 'All'
        ? ProductData.products
        : ProductData.products.where((product) => product.category == category).toList();

    final crossAxisCount = ResponsiveUtils.gridCrossAxisCount(context);
    final spacing = ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate childAspectRatio based on available height
        final aspectRatio = constraints.maxHeight > 600 ? 0.65 : 0.7;

        return GridView.builder(
          padding: EdgeInsets.all(spacing),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            return ProductCard(product: filteredProducts[index]);
          },
        );
      },
    );
  }
}