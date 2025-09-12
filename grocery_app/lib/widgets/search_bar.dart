import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const SearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search for products...',
        prefixIcon: Icon(
          Icons.search,
          size: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
          color: Colors.grey[600],
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  size: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  controller.clear();
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(
          vertical: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20),
          horizontal: 20,
        ),
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
        ),
      ),
      style: TextStyle(
        fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
      ),
      onChanged: (value) {
        // Handle search functionality
      },
      onSubmitted: (value) {
        // Handle search submission
      },
    );
  }
}