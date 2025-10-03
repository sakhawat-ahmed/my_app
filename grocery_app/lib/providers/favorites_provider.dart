import 'package:flutter/foundation.dart';
import 'package:grocery_app/models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favoriteProducts = [];

  List<Product> get favoriteProducts => _favoriteProducts;

  bool isFavorite(Product product) {
    return _favoriteProducts.any((p) => p.id == product.id);
  }

  void addToFavorites(Product product) {
    if (!isFavorite(product)) {
      _favoriteProducts.add(product.copyWith(isFavorite: true));
      notifyListeners();
    }
  }

  void removeFromFavorites(Product product) {
    _favoriteProducts.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      removeFromFavorites(product);
    } else {
      addToFavorites(product);
    }
  }

  void clearFavorites() {
    _favoriteProducts.clear();
    notifyListeners();
  }

  int get favoriteCount => _favoriteProducts.length;
}