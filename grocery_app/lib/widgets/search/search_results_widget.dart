import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/widgets/product/product_card.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/providers/theme_provider.dart';

class SearchResultsWidget extends StatelessWidget {
  final List<Product> searchResults;
  final bool isEmptySearch;

  const SearchResultsWidget({
    super.key,
    required this.searchResults,
    required this.isEmptySearch,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final padding = ResponsiveUtils.responsivePadding(context);

    if (isEmptySearch) {
      return _buildSearchHint(themeProvider);
    }

    if (searchResults.isEmpty) {
      return _buildNoResultsState(themeProvider);
    }

    return _buildSearchResultsGrid(context, padding);
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

  Widget _buildSearchResultsGrid(BuildContext context, EdgeInsets padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding.left),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveUtils.gridCrossAxisCount(context),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final product = searchResults[index];
          return ProductCard(product: product);
        },
      ),
    );
  }
}