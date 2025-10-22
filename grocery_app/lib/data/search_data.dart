import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/data/product_data.dart';

class SearchData {
  static List<Product> searchProducts(String query, List<Product> products) {
    if (query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();
    
    return products.where((product) {
      final productName = product.name.toLowerCase();
      final productDescription = product.description.toLowerCase();
      final productCategory = product.category.toLowerCase();

      return productName.contains(lowercaseQuery) ||
          productDescription.contains(lowercaseQuery) ||
          productCategory.contains(lowercaseQuery);
    }).toList();
  }

  static List<Product> getPopularSearches() {
    // Return popular or frequently searched products
    return ProductData.products
        .where((product) => product.rating >= 4.0)
        .take(6)
        .toList();
  }

  static List<String> getSearchSuggestions(String query) {
    if (query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();
    final categories = ProductData.products
        .map((product) => product.category)
        .toSet()
        .toList();

    return categories
        .where((category) => category.toLowerCase().contains(lowercaseQuery))
        .take(5)
        .toList();
  }
}