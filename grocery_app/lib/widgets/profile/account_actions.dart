import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class AccountActions extends StatelessWidget {
  final VoidCallback onOrderHistoryTap;
  final VoidCallback onPaymentMethodsTap;
  final VoidCallback onHelpSupportTap;
  final VoidCallback onLogoutTap;

  const AccountActions({
    super.key,
    required this.onOrderHistoryTap,
    required this.onPaymentMethodsTap,
    required this.onHelpSupportTap,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildActionTile(
          context: context,
          title: 'Order History',
          icon: Icons.history,
          onTap: onOrderHistoryTap,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
        _buildActionTile(
          context: context,
          title: 'Payment Methods',
          icon: Icons.credit_card,
          onTap: onPaymentMethodsTap,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
        _buildActionTile(
          context: context,
          title: 'Help & Support',
          icon: Icons.help_center,
          onTap: onHelpSupportTap,
        ),
        SizedBox(height: ResponsiveUtils.responsiveSize(context, mobile: 12, tablet: 16, desktop: 20)),
        _buildActionTile(
          context: context,
          title: 'Logout',
          icon: Icons.logout,
          color: Colors.red,
          onTap: onLogoutTap,
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    Color color = Colors.green,
    required Function() onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveUtils.responsiveSize(context, mobile: 16, tablet: 18, desktop: 20),
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: color,
          size: ResponsiveUtils.responsiveSize(context, mobile: 24, tablet: 26, desktop: 28),
        ),
        onTap: onTap,
      ),
    );
  }
}