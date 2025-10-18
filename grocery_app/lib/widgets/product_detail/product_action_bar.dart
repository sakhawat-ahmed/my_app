import 'package:flutter/material.dart';
import 'package:grocery_app/models/product.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class ProductActionBar extends StatefulWidget {
  final Product product;
  final Color textColor;
  final Color borderColor;
  final Color cardColor;
  final VoidCallback onAddToCart;

  const ProductActionBar({
    super.key,
    required this.product,
    required this.textColor,
    required this.borderColor,
    required this.cardColor,
    required this.onAddToCart,
  });

  @override
  State<ProductActionBar> createState() => _ProductActionBarState();
}

class _ProductActionBarState extends State<ProductActionBar> {
  int _quantity = 1;

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      decoration: BoxDecoration(
        color: widget.cardColor,
        border: Border(
          top: BorderSide(
            color: widget.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Quantity Selector
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: widget.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    size: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
                  ),
                  onPressed: _decreaseQuantity,
                ),
                Text(
                  _quantity.toString(),
                  style: TextStyle(
                    fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    size: ResponsiveUtils.responsiveSize(context, mobile: 20, tablet: 24, desktop: 28),
                  ),
                  onPressed: _increaseQuantity,
                ),
              ],
            ),
          ),
          SizedBox(width: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
          // Add to Cart Button
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                widget.onAddToCart();
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