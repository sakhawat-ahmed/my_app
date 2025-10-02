import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final padding = ResponsiveUtils.responsivePadding(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(context),
            // Product Content
            Expanded(
              child: SingleChildScrollView(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    _buildProductImage(context),
                    SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28)),
                    // Product Info
                    _buildProductInfo(context, themeProvider),
                    SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28)),
                    // Description
                    _buildDescriptionSection(context, themeProvider),
                    SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28)),
                    // Reviews
                    _buildReviewsSection(context, themeProvider),
                  ],
                ),
              ),
            ),
            // Bottom Action Bar
            _buildBottomActionBar(context, cartProvider, themeProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.share,
              size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
            ),
            onPressed: () {
              // Share functionality
            },
          ),
          IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: product.isFavorite ? Colors.red : null,
              size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
            ),
            onPressed: () {
              // Toggle favorite
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ResponsiveUtils.responsiveSize(context, mobile: 250, tablet: 300, desktop: 350),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(product.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 28, desktop: 32),
            fontWeight: FontWeight.bold,
            color: themeProvider.textColor,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
        Text(
          product.category,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
        Row(
          children: [
            RatingBar.builder(
              initialRating: product.rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
              ignoreGestures: true,
            ),
            SizedBox(width: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
            Text(
              '${product.rating} (${product.reviewCount} reviews)',
              style: TextStyle(
                fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
                color: themeProvider.secondaryTextColor,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 28, tablet: 32, desktop: 36),
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
        Text(
          'Per ${product.unit}',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
            color: themeProvider.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
            fontWeight: FontWeight.bold,
            color: themeProvider.textColor,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
        Text(
          product.description,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            color: themeProvider.secondaryTextColor,
            height: 1.5,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
        // Additional product details
        _buildDetailRow(
          context,
          'Category',
          product.category,
          themeProvider,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
        _buildDetailRow(
          context,
          'Unit',
          product.unit,
          themeProvider,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
        _buildDetailRow(
          context,
          'Availability',
          'In Stock',
          themeProvider,
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value, ThemeProvider themeProvider) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
            fontWeight: FontWeight.w500,
            color: themeProvider.textColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
            color: themeProvider.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(BuildContext context, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Reviews',
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
            fontWeight: FontWeight.bold,
            color: themeProvider.textColor,
          ),
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
        // Sample review
        _buildReviewItem(
          context,
          'John Doe',
          'Great product! Fresh and delicious.',
          5,
          themeProvider,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
        _buildReviewItem(
          context,
          'Jane Smith',
          'Good quality, will buy again.',
          4,
          themeProvider,
        ),
      ],
    );
  }

  Widget _buildReviewItem(BuildContext context, String name, String comment, int rating, ThemeProvider themeProvider) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
              fontWeight: FontWeight.bold,
              color: themeProvider.textColor,
            ),
          ),
          SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8)),
          RatingBar.builder(
            initialRating: rating.toDouble(),
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
            comment,
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
              color: themeProvider.secondaryTextColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, CartProvider cartProvider, ThemeProvider themeProvider) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24)),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        border: Border(
          top: BorderSide(
            color: themeProvider.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Quantity Selector
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: themeProvider.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    size: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
                  ),
                  onPressed: () {
                    // Decrease quantity
                  },
                ),
                Text(
                  '1',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                    fontWeight: FontWeight.bold,
                    color: themeProvider.textColor,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    size: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
                  ),
                  onPressed: () {
                    // Increase quantity
                  },
                ),
              ],
            ),
          ),
          SizedBox(width: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
          // Add to Cart Button
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                cartProvider.addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} added to cart'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Add to Cart',
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}