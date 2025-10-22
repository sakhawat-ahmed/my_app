import 'package:flutter/foundation.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/data/search_data.dart';
import 'package:grocery_app/data/product_data.dart';

class SearchProvider with ChangeNotifier {
  List<Product> _searchResults = [];
  String _searchQuery = '';
  bool _isSearching = false;

  List<Product> get searchResults => _searchResults;
  String get searchQuery => _searchQuery;
  bool get isSearching => _isSearching;
  bool get hasResults => _searchResults.isNotEmpty;
  bool get isEmptySearch => _searchQuery.isEmpty;

  void searchProducts(String query) {
    _searchQuery = query;
    _isSearching = true;
    
    if (query.isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = SearchData.searchProducts(query, ProductData.products);
    }
    
    _isSearching = false;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }

  List<String> getSearchSuggestions() {
    return SearchData.getSearchSuggestions(_searchQuery);
  }

  List<Product> getPopularSearches() {
    return SearchData.getPopularSearches();
  }
}