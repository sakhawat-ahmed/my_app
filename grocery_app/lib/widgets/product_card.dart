import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/providers/favorites_provider.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:grocery_app/screens/product_detail_screen.dart'; 

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isMobile = ResponsiveUtils.isMobile(context);
    final imageSize = ResponsiveUtils.productImageSize(context);
    final fontSize = ResponsiveUtils.responsiveSize(context, mobile: 10, tablet: 12, desktop: 14);
    final titleFontSize = ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 14, desktop: 16);
    final priceFontSize = ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18);

    return GestureDetector(
      onTap: () {
        print('Product tapped: ${product.name}'); // Debug print
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Section
            Container(
              height: imageSize * 0.8,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                     
child: Positioned(
  top: 6,
  right: 6,
  child: Consumer<FavoritesProvider>(
    builder: (context, favoritesProvider, child) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon: Icon(
            favoritesProvider.isFavorite(product) ? Icons.favorite : Icons.favorite_border,
            color: favoritesProvider.isFavorite(product) ? Colors.red : Colors.grey,
            size: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
          ),
          onPressed: () {
            favoritesProvider.toggleFavorite(product);
          },
        ),
      );
    },
  ),
),
                    ),
                  ),
                ],
              ),
            ),
            // Content Section
            Padding(
              padding: EdgeInsets.all(ResponsiveUtils.responsiveSize(context, mobile: 6, tablet: 8, desktop: 10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
                      height: 1.1,
                      color: themeProvider.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 2, tablet: 3, desktop: 4)),
                  // Product Description
                  Text(
                    product.description,
                    style: TextStyle(
                      color: themeProvider.secondaryTextColor,
                      fontSize: fontSize,
                      height: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8)),
                  // Rating
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
                          size: 8,
                        ),
                        onRatingUpdate: (rating) {},
                        ignoreGestures: true,
                      ),
                      SizedBox(width: ResponsiveUtils.responsiveSize(context, mobile: 2, tablet: 3, desktop: 4)),
                      Text(
                        '(${product.reviewCount})',
                        style: TextStyle(
                          fontSize: fontSize - 1,
                          color: themeProvider.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 6, tablet: 8, desktop: 10)),
                  // Price and Add to Cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: priceFontSize,
                          color: Colors.green,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.add_shopping_cart,
                            size: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          onPressed: () {
                            cartProvider.addItem(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} added to cart'),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}