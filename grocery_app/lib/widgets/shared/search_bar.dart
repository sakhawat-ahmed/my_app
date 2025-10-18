import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  const SearchBar({super.key, required this.controller, this.focusNode});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: TextStyle(
        fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
        color: themeProvider.textColor,
      ),
      decoration: InputDecoration(
        hintText: 'Search for products...',
        hintStyle: TextStyle(
          color: themeProvider.secondaryTextColor,
          fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
        ),
        prefixIcon: Icon(
          Icons.search,
          size: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
          color: themeProvider.secondaryTextColor,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  size: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
                  color: themeProvider.secondaryTextColor,
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
        fillColor: themeProvider.inputFillColor,
        contentPadding: EdgeInsets.symmetric(
          vertical: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20),
          horizontal: 20,
        ),
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