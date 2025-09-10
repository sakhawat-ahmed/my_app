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
    final imageSize = ResponsiveUtils.responsiveSize(context, mobile: 50, tablet: 60, desktop: 70);
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
        cartProvider.removeItem(item.product.id);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20),
          vertical: ResponsiveUtils.responsiveSize(context, mobile: 6, tablet: 8, desktop: 10),
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
          child: Row(
            children: [
              Image.asset(
                item.product.imageUrl,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(width: ResponsiveUtils.responsiveSize(context, mobile: 8, tablet: 12, desktop: 16)),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 2, tablet: 4, desktop: 6)),
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
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      size: ResponsiveUtils.responsiveSize(context, mobile: 18, tablet: 22, desktop: 26),
                    ),
                    onPressed: () {
                      if (item.quantity > 1) {
                        cartProvider.updateQuantity(
                            item.product.id, item.quantity - 1);
                      } else {
                        cartProvider.removeItem(item.product.id);
                      }
                    },
                  ),
                  Text(
                    item.quantity.toString(),
                    style: TextStyle(
                      fontSize: ResponsiveUtils.responsiveSize(context, mobile: 14, tablet: 16, desktop: 18),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      size: ResponsiveUtils.responsiveSize(context, mobile: 18, tablet: 22, desktop: 26),
                    ),
                    onPressed: () {
                      cartProvider.updateQuantity(
                          item.product.id, item.quantity + 1);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}