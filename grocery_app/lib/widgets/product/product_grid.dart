import 'package:flutter/material.dart';
import 'package:grocery_app/widgets/product/product_card.dart';
import '../../utils/responsive_utils.dart';

class ProductGrid extends StatelessWidget {
  final String category;
  final List<dynamic> products; // Add this parameter

  const ProductGrid({
    super.key, 
    required this.category,
    required this.products, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    // Filter products based on category
    final filteredProducts = _getFilteredProducts();
    
    final crossAxisCount = ResponsiveUtils.gridCrossAxisCount(context);
    final spacing = ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16);

    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              category == 'All' 
                ? 'Check back later for new products'
                : 'No products in $category category',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 0.75,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ProductCard(product: _convertToProductModel(product));
      },
    );
  }

  List<dynamic> _getFilteredProducts() {
    if (category == 'All') {
      return products;
    }
    
    return products.where((product) {
      if (product is Map<String, dynamic>) {
        final productCategory = product['category_name'] ?? product['category'];
        return productCategory == category;
      }
      return false;
    }).toList();
  }

  // Convert API product data to your existing Product model
  // This method depends on your existing Product model structure
  dynamic _convertToProductModel(dynamic product) {
    if (product is Map<String, dynamic>) {
      // If your ProductCard expects a Map, return as-is
      // If it expects a specific class, you'll need to convert it
      return product;
    }
    return product;
  }
}