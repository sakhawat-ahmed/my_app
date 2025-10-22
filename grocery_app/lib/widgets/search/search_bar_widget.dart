import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/theme_provider.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;
  final VoidCallback onClose;
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onClear,
    required this.onClose,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      color: themeProvider.scaffoldBackgroundColor,
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
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
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
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: themeProvider.secondaryTextColor,
                          ),
                          onPressed: onClear,
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
            onPressed: onClose,
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
}