import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/theme_provider.dart';

class TextSizeSelector extends StatelessWidget {
  const TextSizeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ListTile(
      leading: const Icon(Icons.text_fields),
      title: const Text('Text Size'),
      subtitle: Text(themeProvider.currentTextSizeName),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        _showTextSizeDialog(context, themeProvider);
      },
    );
  }

  void _showTextSizeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Text Size'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: themeProvider.textSizeOptions.length,
            itemBuilder: (context, index) {
              final sizeName = themeProvider.textSizeOptions[index];
              final sizeFactor = ThemeProvider.textSizePresets[sizeName]!;
              
              return ListTile(
                title: Text(sizeName),
                subtitle: Text(
                  'Example: ${(16 * sizeFactor).toStringAsFixed(1)}pt',
                  style: TextStyle(fontSize: 14 * sizeFactor),
                ),
                trailing: themeProvider.textSizeFactor == sizeFactor
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  themeProvider.changeTextSizeByName(sizeName);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Text size changed to $sizeName'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}