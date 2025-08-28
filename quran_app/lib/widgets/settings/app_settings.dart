import 'package:flutter/material.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Clear Cache'),
            onTap: () {
              _showClearCacheDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Check for Updates'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear all cached data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}