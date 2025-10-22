import 'package:flutter/material.dart';
import 'package:grocery_app/widgets/search/search_bar_widget.dart';
import 'package:grocery_app/widgets/search/search_results_widget.dart';
import 'package:grocery_app/data/search_data.dart';
import 'package:grocery_app/data/product_data.dart';
import 'package:grocery_app/models/product.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback onClose;

  const SearchScreen({
    super.key,
    required this.onClose,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Product> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final results = SearchData.searchProducts(
      _searchController.text, 
      ProductData.products
    );

    setState(() {
      _searchResults = results;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar at top
              SearchBarWidget(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onClear: _clearSearch,
                onClose: widget.onClose,
                onChanged: (value) => _onSearchChanged(),
              ),
              
              // Search Results
              Expanded(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: SearchResultsWidget(
                    searchResults: _searchResults,
                    isEmptySearch: _searchController.text.isEmpty,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}