import 'package:flutter/material.dart';
import 'package:grocery_app/models/user_model.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User? user;

  const HomeAppBar({
    super.key,
    required this.user,
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
    );
  }
}