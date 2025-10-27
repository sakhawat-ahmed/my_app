import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic>? user;
  final VoidCallback? onLogout;

  const HomeAppBar({
    super.key,
    required this.user,
    this.onLogout,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Grocery Store',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: ResponsiveUtils.titleFontSize(context),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        if (onLogout != null)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogout,
            tooltip: 'Logout',
          ),
      ],
    );
  }
}