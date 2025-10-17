import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class ProductDetailAppBar extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onSharePressed;
  final VoidCallback onFavoritePressed;
  final bool isFavorite;

  const ProductDetailAppBar({
    super.key,
    required this.onBackPressed,
    required this.onSharePressed,
    required this.onFavoritePressed,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
            ),
            onPressed: onBackPressed,
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.share,
              size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
            ),
            onPressed: onSharePressed,
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
              size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
            ),
            onPressed: onFavoritePressed,
          ),
        ],
      ),
    );
  }
}