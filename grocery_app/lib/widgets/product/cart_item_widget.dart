import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/models/cart_item.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final isMobile = ResponsiveUtils.isMobile(context);
    final imageSize = ResponsiveUtils.responsiveSize(context, mobile: 45, tablet: 55, desktop: 65);
    final fontSize = ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 14, desktop: 16);

    return Dismissible(
      key: Key(item.product.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        cartProvider.removeItem(item.product.id as int);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16),
          vertical: ResponsiveUtils.responsiveSize(context, mobile: 4, tablet: 6, desktop: 8),
        ),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 10, desktop: 12)),
            child: Row(
              children: [
                // Product Image
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(item.product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                SizedBox(width: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
                
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 2, tablet: 3, desktop: 4)),
                      Text(
                        '\$${item.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Quantity Controls
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.remove,
                        size: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        if (item.quantity > 1) {
                          cartProvider.updateQuantity(item.product.id as int, item.quantity - 1);
                        } else {
                          cartProvider.removeItem(item.product.id as int);
                        }
                      },
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 10, desktop: 12),
                        vertical: ResponsiveUtils.responsiveSize(context, mobile: 2, tablet: 4, desktop: 6),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.quantity.toString(),
                        style: TextStyle(
                          fontSize: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 14, desktop: 16),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        size: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        cartProvider.updateQuantity(item.product.id as int, item.quantity + 1);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}