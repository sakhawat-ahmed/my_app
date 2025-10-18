import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class ProductDescriptionSection extends StatelessWidget {
  final Product product;
  final Color textColor;
  final Color secondaryTextColor;

  const ProductDescriptionSection({
    super.key,
    required this.product,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
        Text(
          product.description,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: secondaryTextColor,
            height: 1.5,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        _buildProductDetails(context),
      ],
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    final details = {
      'Category': product.category,
      'Unit': product.unit,
      'Availability': 'In Stock',
    };

    return Column(
      children: details.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(bottom: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
          child: _buildDetailRow(context, entry.key, entry.value),
        );
      }).toList(),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }
}