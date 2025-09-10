import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for products...',
        prefixIcon: Icon(
          Icons.search,
          size: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(
          vertical: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20),
          horizontal: 16,
        ),
      ),
    );
  }
}