import 'package:flutter/material.dart';

class NotificationHeader extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onMarkAllRead;

  const NotificationHeader({
    super.key,
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    if (unreadCount == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green[50],
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.green[700]),
          const SizedBox(width: 8),
          Text(
            '$unreadCount unread notification${unreadCount > 1 ? 's' : ''}',
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onMarkAllRead,
            child: Text(
              'Mark all as read',
              style: TextStyle(
                color: Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}