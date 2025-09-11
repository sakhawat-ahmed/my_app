import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery_app/models/product.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final isMobile = ResponsiveUtils.isMobile(context);
    final imageSize = ResponsiveUtils.productImageSize(context);
    final fontSize = ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 14, desktop: 16);
    final titleFontSize = ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18);
    final priceFontSize = ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section with fixed height
              SizedBox(
                height: imageSize,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.asset(
                        product.imageUrl,
                        width: double.infinity,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          product.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: product.isFavorite ? Colors.red : Colors.grey,
                          size: ResponsiveUtils.responsiveSize(context, mobile: 18, tablet: 22, desktop: 26),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              // Content Section - Flexible to take remaining space
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveUtils.responsiveSize(context, mobile: 6, tablet: 8, desktop: 10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top section - Product info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: titleFontSize,
                              height: 1.2,
                            ),
                            maxLines: isMobile ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 2, tablet: 3, desktop: 4)),
                          Text(
                            product.description,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: fontSize - 1,
                              height: 1.1,
                            ),
                            maxLines: isMobile ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8)),
                          Row(
                            children: [
                              RatingBar.builder(
                                initialRating: product.rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: ResponsiveUtils.responsiveSize(context, mobile: 10, tablet: 12, desktop: 14),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                              SizedBox(width: ResponsiveUtils.responsiveSize(context, mobile: 2, tablet: 3, desktop: 4)),
                              Text(
                                '(${product.reviewCount})',
                                style: TextStyle(fontSize: fontSize - 1),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Bottom section - Price and Add to cart
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: priceFontSize,
                                color: Colors.green,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add_shopping_cart,
                              size: ResponsiveUtils.responsiveSize(context, mobile: 18, tablet: 20, desktop: 22),
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            color: Colors.green,
                            onPressed: () {
                              cartProvider.addItem(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product.name} added to cart'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}