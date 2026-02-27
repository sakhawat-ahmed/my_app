import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/user_provider.dart';
import 'package:grocery_app/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: userProvider.isLoading
          ? _buildLoadingState()
          : user != null
              ? _buildUserInfo(context, user)
              : _buildGuestState(context),
    );
  }

  Widget _buildLoadingState() {
    return const Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                height: 20,
                child: LinearProgressIndicator(),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: 180,
                height: 16,
                child: LinearProgressIndicator(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context, User user) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.green[50],
            shape: BoxShape.circle,
          ),
          child: user.profilePicture != null
              ? ClipOval(
                  child: Image.network(
                    user.profilePicture!,
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.green[600],
                      );
                    },
                  ),
                )
              : Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.green[600],
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.username,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getUserTypeColor(user.userType),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getUserTypeLabel(user.userType),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (user.phone != null && user.phone!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  user.phone!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
        Icon(
          Icons.verified,
          color: Colors.green[400],
          size: 24,
        ),
      ],
    );
  }

  Widget _buildGuestState(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_outline,
            size: 30,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Guest User',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Please login to access all features',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.login,
            color: Colors.green[600],
          ),
          onPressed: () {
            // Navigate to login screen
            Navigator.pushNamed(context, '/login');
          },
        ),
      ],
    );
  }

  Color _getUserTypeColor(String? userType) {
    switch (userType) {
      case 'vendor':
        return Colors.orange[400]!;
      case 'delivery':
        return Colors.blue[400]!;
      case 'admin':
        return Colors.red[400]!;
      default: // customer
        return Colors.green[400]!;
    }
  }

  String _getUserTypeLabel(String? userType) {
    switch (userType) {
      case 'vendor':
        return 'Vendor';
      case 'delivery':
        return 'Delivery Partner';
      case 'admin':
        return 'Admin';
      default: // customer
        return 'Customer';
    }
  }
}