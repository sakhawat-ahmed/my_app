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
    final childAspectRatio = ResponsiveUtils.isMobile(context) ? 0.7 : 0.8;
    final spacing = ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20);

    return GridView.builder(
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductCard(product: filteredProducts[index]);
      },
    );
  }
}