import 'package:flutter/material.dart';
import 'package:grocery_app/data/product_review_data.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/widgets/product_detail/review_item.dart';

class ProductReviewsSection extends StatelessWidget {
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  final Color borderColor;

  const ProductReviewsSection({
    super.key,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final reviews = ProductReviewData.sampleReviews;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Reviews',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
        Column(
          children: reviews
              .map(
                (review) => Padding(
                  padding: EdgeInsets.only(
                    bottom: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20),
                  ),
                  child: ReviewItem(
                    review: review,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardColor: cardColor,
                    borderColor: borderColor,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}