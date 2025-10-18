import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/widgets/product_detail/product_detail_app_bar.dart';
import 'package:grocery_app/widgets/product_detail/product_image_section.dart';
import 'package:grocery_app/widgets/product_detail/product_info_section.dart';
import 'package:grocery_app/widgets/product_detail/product_description_section.dart';
import 'package:grocery_app/widgets/product_detail/product_reviews_section.dart';
import 'package:grocery_app/widgets/product_detail/product_action_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductDetailState _state;

  @override
  void initState() {
    super.initState();
    _state = ProductDetailState(isFavorite: widget.product.isFavorite);
  }

  void _toggleFavorite() {
    setState(() {
      _state = _state.copyWith(isFavorite: !_state.isFavorite);
    });
  }

  void _shareProduct() {
    // Implement share functionality
  }

  void _addToCart(CartProvider cartProvider) {
    cartProvider.addItem(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
            ProductDetailAppBar(
              onBackPressed: () => Navigator.pop(context),
              onSharePressed: _shareProduct,
              onFavoritePressed: _toggleFavorite,
              isFavorite: _state.isFavorite,
            ),
            // Product Content
            Expanded(
              child: SingleChildScrollView(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    ProductImageSection(imageUrl: widget.product.imageUrl),
                    SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28)),
                    // Product Info
                    ProductInfoSection(
                      product: widget.product,
                      textColor: themeProvider.textColor,
                      secondaryTextColor: themeProvider.secondaryTextColor,
                    ),
                    SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28)),
                    // Description
                    ProductDescriptionSection(
                      product: widget.product,
                      textColor: themeProvider.textColor,
                      secondaryTextColor: themeProvider.secondaryTextColor,
                    ),
                    SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28)),
                    // Reviews
                    ProductReviewsSection(
                      textColor: themeProvider.textColor,
                      secondaryTextColor: themeProvider.secondaryTextColor,
                      cardColor: themeProvider.cardColor,
                      borderColor: themeProvider.borderColor,
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Action Bar
            ProductActionBar(
              product: widget.product,
              textColor: themeProvider.textColor,
              borderColor: themeProvider.borderColor,
              cardColor: themeProvider.cardColor,
              onAddToCart: () => _addToCart(cartProvider),
            ),
          ],
        ),
      ),
    );
  }
}