import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class ReviewItem extends StatelessWidget {
  final ProductReview review;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  final Color borderColor;

  const ReviewItem({
    super.key,
    required this.review,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20),
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review.userName,
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8)),
          RatingBar.builder(
            initialRating: review.rating.toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {},
            ignoreGestures: true,
          ),
          SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
              color: secondaryTextColor,
              height: 1.4,
            ),
          ),
          SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
          Text(
            _formatDate(review.date),
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 14, desktop: 16),
              color: secondaryTextColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}