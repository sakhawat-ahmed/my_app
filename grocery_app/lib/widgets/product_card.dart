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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  product.imageUrl,
                  height: imageSize,
                  width: double.infinity,
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                        ),
                        maxLines: isMobile ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 2, tablet: 4, desktop: 6)),
                      Text(
                        product.description,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: fontSize,
                        ),
                        maxLines: isMobile ? 2 : 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Column(
                    children: [
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
                          SizedBox(width: ResponsiveUtils.responsiveSize(context, mobile: 2, tablet: 4, desktop: 6)),
                          Text(
                            '(${product.reviewCount})',
                            style: TextStyle(fontSize: fontSize),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 8, desktop: 12)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: priceFontSize,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add_shopping_cart,
                              size: ResponsiveUtils.responsiveSize(context, mobile: 18, tablet: 22, desktop: 26),
                            ),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}