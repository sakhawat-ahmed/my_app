import 'package:flutter/material.dart';
import 'package:grocery_app/models/notification_model.dart';
import 'package:grocery_app/widgets/notifications/notification_item_tile.dart';

class NotificationListSection extends StatefulWidget {
  const NotificationListSection({super.key});

  @override
  State<NotificationListSection> createState() => _NotificationListSectionState();
}

class _NotificationListSectionState extends State<NotificationListSection> {
  final List<NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    // In a real app, this would come from a provider or repository
    setState(() {
      _notifications.addAll([
        NotificationItem(
          id: '1',
          title: 'Order Confirmed',
          message: 'Your order #12345 has been confirmed',
          time: '2 hours ago',
          type: NotificationType.order,
          isRead: false,
        ),
        NotificationItem(
          id: '2',
          title: 'Special Offer',
          message: '50% off on fresh vegetables this weekend',
          time: '1 day ago',
          type: NotificationType.promotional,
          isRead: true,
        ),
        // Add other notifications...
      ]);
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  void _deleteNotification(NotificationItem notification) {
    setState(() {
      _notifications.remove(notification);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _notifications.add(notification);
            });
          },
        ),
      ),
    );
  }

  void _markAsRead(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Column(
      children: [
        if (unreadCount > 0) _buildUnreadHeader(unreadCount),
        Expanded(
          child: ListView.builder(
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final notification = _notifications[index];
              return NotificationItemTile(
                notification: notification,
                onTap: () => _markAsRead(notification),
                onDismiss: () => _deleteNotification(notification),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUnreadHeader(int unreadCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green[50],
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.green[700]),
          const SizedBox(width: 8),
          Text(
            '$unreadCount unread notifications',
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _markAllAsRead,
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