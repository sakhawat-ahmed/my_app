import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class ProductImageSection extends StatelessWidget {
  final String imageUrl;
  final List<String>? additionalImages;

  const ProductImageSection({
    super.key,
    required this.imageUrl,
    this.additionalImages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ResponsiveUtils.responsiveSize(context, mobile: 250, tablet: 300, desktop: 350),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}