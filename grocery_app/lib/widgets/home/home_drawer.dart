import 'package:flutter/material.dart';
import 'package:grocery_app/screens/favorites_screen.dart';
import 'package:grocery_app/screens/help_support_screen.dart';
import 'package:grocery_app/screens/login_screen.dart';
import 'package:grocery_app/screens/notifications_screen.dart';
import 'package:grocery_app/screens/settings_screen.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:grocery_app/services/api_service.dart'; 
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  final Map<String, dynamic>? user;

  const HomeDrawer({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildDrawerItems(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    final userName = _getUserName();
    final userEmail = user?['email'] ?? 'No email';
    final userType = _getUserTypeDisplay();

    return DrawerHeader(
      decoration: BoxDecoration(
        color: _getUserColor(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  _getUserIcon(),
                  size: 30,
                  color: _getUserColor(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        userType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItems(BuildContext context) {
    return Column(
      children: [
        // Home
        ListTile(
          leading: const Icon(Icons.home, color: Colors.green),
          title: const Text('Home'),
          onTap: () {
            Navigator.pop(context);
          },
        ),

        // My Orders
        ListTile(
          leading: const Icon(Icons.shopping_bag, color: Colors.green),
          title: const Text('My Orders'),
          onTap: () {
            Navigator.pop(context);
            // TODO: Navigate to orders screen
            _showComingSoonSnackbar(context, 'Orders');
          },
        ),

        // Favorites
        ListTile(
          leading: const Icon(Icons.favorite, color: Colors.green),
          title: const Text('Favorites'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesScreen()),
            );
          },
        ),

        // Notifications
        ListTile(
          leading: const Icon(Icons.notifications, color: Colors.green),
          title: const Text('Notifications'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
            );
          },
        ),

        // Vendor-specific menu items
        if (_isVendor()) ..._buildVendorMenuItems(context),

        // Delivery-specific menu items
        if (_isDeliveryPartner()) ..._buildDeliveryMenuItems(context),

        const Divider(),

        // Settings
        ListTile(
          leading: const Icon(Icons.settings, color: Colors.grey),
          title: const Text('Settings'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),

        // Help & Support
        ListTile(
          leading: const Icon(Icons.help, color: Colors.grey),
          title: const Text('Help & Support'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
            );
          },
        ),

        const Divider(),

        // Logout
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout'),
          onTap: () {
            Navigator.pop(context);
            _showLogoutDialog(context);
          },
        ),
      ],
    );
  }

  List<Widget> _buildVendorMenuItems(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.store, color: Colors.blue),
        title: const Text('My Store'),
        onTap: () {
          Navigator.pop(context);
          _showComingSoonSnackbar(context, 'Vendor Store');
        },
      ),
      ListTile(
        leading: const Icon(Icons.inventory, color: Colors.blue),
        title: const Text('Manage Products'),
        onTap: () {
          Navigator.pop(context);
          _showComingSoonSnackbar(context, 'Product Management');
        },
      ),
      ListTile(
        leading: const Icon(Icons.analytics, color: Colors.blue),
        title: const Text('Analytics'),
        onTap: () {
          Navigator.pop(context);
          _showComingSoonSnackbar(context, 'Vendor Analytics');
        },
      ),
    ];
  }

  List<Widget> _buildDeliveryMenuItems(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.delivery_dining, color: Colors.orange),
        title: const Text('My Deliveries'),
        onTap: () {
          Navigator.pop(context);
          _showComingSoonSnackbar(context, 'Delivery Management');
        },
      ),
      ListTile(
        leading: const Icon(Icons.route, color: Colors.orange),
        title: const Text('Delivery Routes'),
        onTap: () {
          Navigator.pop(context);
          _showComingSoonSnackbar(context, 'Delivery Routes');
        },
      ),
      ListTile(
        leading: const Icon(Icons.attach_money, color: Colors.orange),
        title: const Text('Earnings'),
        onTap: () {
          Navigator.pop(context);
          _showComingSoonSnackbar(context, 'Delivery Earnings');
        },
      ),
    ];
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveSize(context, mobile: 18, tablet: 20, desktop: 22),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await ApiService.logout(); // Updated to use ApiService
      
      // Clear cart when logging out
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.clear();
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showComingSoonSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Helper methods for user data
  String _getUserName() {
    if (user == null) return 'Guest User';
    
    final firstName = user!['first_name'] ?? '';
    final lastName = user!['last_name'] ?? '';
    final username = user!['username'] ?? '';
    
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      return '$firstName $lastName'.trim();
    } else if (username.isNotEmpty) {
      return username;
    }
    
    return 'User';
  }

  String _getUserTypeDisplay() {
    if (user == null) return 'Guest';
    
    final userType = user!['user_type'];
    
    switch (userType) {
      case 'customer':
        return 'Customer';
      case 'vendor':
        return 'Vendor';
      case 'delivery':
        return 'Delivery Partner';
      default:
        return 'Customer';
    }
  }

  Color _getUserColor() {
    if (user == null) return Colors.green;
    
    final userType = user!['user_type'];
    
    switch (userType) {
      case 'customer':
        return Colors.green;
      case 'vendor':
        return Colors.blue;
      case 'delivery':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  IconData _getUserIcon() {
    if (user == null) return Icons.person;
    
    final userType = user!['user_type'];
    
    switch (userType) {
      case 'customer':
        return Icons.person;
      case 'vendor':
        return Icons.store;
      case 'delivery':
        return Icons.delivery_dining;
      default:
        return Icons.person;
    }
  }

  bool _isVendor() {
    return user?['user_type'] == 'vendor';
  }

  bool _isDeliveryPartner() {
    return user?['user_type'] == 'delivery';
  }
}