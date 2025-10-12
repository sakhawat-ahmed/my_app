import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/widgets/product/product_card.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:grocery_app/data/product_data.dart';

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

    final query = _searchController.text.toLowerCase();
    
    final results = ProductData.products.where((product) {
      final productName = product.name.toLowerCase();
      final productDescription = product.description.toLowerCase();
      final productCategory = product.category.toLowerCase();

      return productName.contains(query) ||
          productDescription.contains(query) ||
          productCategory.contains(query);
    }).toList();

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
    final padding = ResponsiveUtils.responsivePadding(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar at top
              _buildSearchBar(themeProvider, padding),
              
              // Search Results or Empty State
              Expanded(
                child: Container(
                  color: themeProvider.scaffoldBackgroundColor,
                  child: _searchController.text.isEmpty
                      ? _buildSearchHint(themeProvider)
                      : _searchResults.isEmpty
                          ? _buildNoResultsState(themeProvider)
                          : _buildSearchResults(context, themeProvider, padding),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeProvider themeProvider, EdgeInsets padding) {
    return Container(
      color: themeProvider.scaffoldBackgroundColor,
      padding: EdgeInsets.all(padding.left),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: themeProvider.inputFillColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(
                    color: themeProvider.secondaryTextColor,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: themeProvider.secondaryTextColor,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: themeProvider.secondaryTextColor,
                          ),
                          onPressed: _clearSearch,
                        )
                      : null,
                ),
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 16,
                ),
                autofocus: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: widget.onClose,
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHint(ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 60,
            color: themeProvider.secondaryTextColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Search for products',
            style: TextStyle(
              fontSize: 18,
              color: themeProvider.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60,
            color: themeProvider.secondaryTextColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              color: themeProvider.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords',
            style: TextStyle(
              fontSize: 14,
              color: themeProvider.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, ThemeProvider themeProvider, EdgeInsets padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding.left),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveUtils.gridCrossAxisCount(context),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final product = _searchResults[index];
          return ProductCard(product: product);
        },
      ),
    );
  }
}