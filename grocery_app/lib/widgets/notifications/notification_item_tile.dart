import 'package:flutter/material.dart';
import 'package:grocery_app/models/notification_model.dart';

class NotificationItemTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  final VoidCallback? onUndo;

  const NotificationItemTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
    this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      background: _buildDismissBackground(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismiss(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: notification.isRead ? Colors.white : Colors.blue[50],
        child: ListTile(
          leading: _buildNotificationIcon(),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.message),
              const SizedBox(height: 4),
              Text(
                notification.time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          trailing: !notification.isRead ? _buildUnreadIndicator() : null,
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Widget _buildNotificationIcon() {
    IconData icon;
    Color color;

    switch (notification.type) {
      case NotificationType.order:
        icon = Icons.shopping_bag;
        color = Colors.green;
        break;
      case NotificationType.promotional:
        icon = Icons.local_offer;
        color = Colors.orange;
        break;
      case NotificationType.priceDrop:
        icon = Icons.arrow_downward;
        color = Colors.red;
        break;
      case NotificationType.delivery:
        icon = Icons.delivery_dining;
        color = Colors.blue;
        break;
      case NotificationType.newArrival:
        icon = Icons.new_releases;
        color = Colors.purple;
        break;
    }

    return Icon(icon, color: color);
  }

  Widget _buildUnreadIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
    );
  }
}