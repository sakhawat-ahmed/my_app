import 'package:flutter/material.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _orderNotifications = true;
  bool _promotionalNotifications = true;
  bool _priceDropNotifications = true;
  bool _newArrivalNotifications = false;
  bool _deliveryUpdates = true;
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = false;

  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'Order Confirmed',
      message: 'Your order #12345 has been confirmed',
      time: '2 hours ago',
      type: NotificationType.order,
      isRead: false,
    ),
    NotificationItem(
      title: 'Special Offer',
      message: '50% off on fresh vegetables this weekend',
      time: '1 day ago',
      type: NotificationType.promotional,
      isRead: true,
    ),
    NotificationItem(
      title: 'Price Drop Alert',
      message: 'Milk price has dropped! Check it out',
      time: '2 days ago',
      type: NotificationType.priceDrop,
      isRead: true,
    ),
    NotificationItem(
      title: 'Delivery Update',
      message: 'Your order will be delivered in 30 minutes',
      time: '3 days ago',
      type: NotificationType.delivery,
      isRead: true,
    ),
    NotificationItem(
      title: 'New Products',
      message: 'Check out our new organic products',
      time: '1 week ago',
      type: NotificationType.newArrival,
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.responsivePadding(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All Notifications'),
              Tab(text: 'Settings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // All Notifications Tab
            _buildNotificationsList(),

            // Settings Tab
            _buildNotificationSettings(padding),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Column(
      children: [
        if (unreadCount > 0)
          Container(
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
          ),
        Expanded(
          child: ListView.builder(
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final notification = _notifications[index];
              return _buildNotificationItem(notification);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.title),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _notifications.remove(notification);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {},
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: notification.isRead ? Colors.white : Colors.blue[50],
        child: ListTile(
          leading: _getNotificationIcon(notification.type),
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
          trailing: !notification.isRead
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
          onTap: () {
            setState(() {
              notification.isRead = true;
            });
          },
        ),
      ),
    );
  }

  Widget _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return const Icon(Icons.shopping_bag, color: Colors.green);
      case NotificationType.promotional:
        return const Icon(Icons.local_offer, color: Colors.orange);
      case NotificationType.priceDrop:
        return const Icon(Icons.arrow_downward, color: Colors.red);
      case NotificationType.delivery:
        return const Icon(Icons.delivery_dining, color: Colors.blue);
      case NotificationType.newArrival:
        return const Icon(Icons.new_releases, color: Colors.purple);
    }
  }

  Widget _buildNotificationSettings(EdgeInsets padding) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(padding.left),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification Types
          _buildSectionTitle('Notification Types'),
          Card(
            elevation: 2,
            child: Column(
              children: [
                _buildNotificationSwitch(
                  'Order Updates',
                  'Order confirmations and status updates',
                  _orderNotifications,
                  (value) => setState(() => _orderNotifications = value),
                ),
                _buildNotificationSwitch(
                  'Promotional Offers',
                  'Special deals and discounts',
                  _promotionalNotifications,
                  (value) => setState(() => _promotionalNotifications = value),
                ),
                _buildNotificationSwitch(
                  'Price Drop Alerts',
                  'Notifications when prices drop',
                  _priceDropNotifications,
                  (value) => setState(() => _priceDropNotifications = value),
                ),
                _buildNotificationSwitch(
                  'New Arrivals',
                  'New product notifications',
                  _newArrivalNotifications,
                  (value) => setState(() => _newArrivalNotifications = value),
                ),
                _buildNotificationSwitch(
                  'Delivery Updates',
                  'Real-time delivery tracking',
                  _deliveryUpdates,
                  (value) => setState(() => _deliveryUpdates = value),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Notification Channels
          _buildSectionTitle('Notification Channels'),
          Card(
            elevation: 2,
            child: Column(
              children: [
                _buildNotificationSwitch(
                  'Push Notifications',
                  'Receive notifications in the app',
                  _pushNotifications,
                  (value) => setState(() => _pushNotifications = value),
                ),
                _buildNotificationSwitch(
                  'Email Notifications',
                  'Receive notifications via email',
                  _emailNotifications,
                  (value) => setState(() => _emailNotifications = value),
                ),
                _buildNotificationSwitch(
                  'SMS Notifications',
                  'Receive notifications via SMS',
                  _smsNotifications,
                  (value) => setState(() => _smsNotifications = value),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Notification Frequency
          _buildSectionTitle('Notification Frequency'),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How often would you like to receive promotional notifications?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFrequencyChip('Daily', false),
                      _buildFrequencyChip('Weekly', true),
                      _buildFrequencyChip('Monthly', false),
                      _buildFrequencyChip('Never', false),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Clear All Notifications
          Center(
            child: ElevatedButton(
              onPressed: _showClearAllDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear All Notifications'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildNotificationSwitch(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildFrequencyChip(String label, bool selected) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (bool selected) {
        setState(() {});
      },
      selectedColor: Colors.green,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Notifications'),
          content: const Text('Are you sure you want to clear all notifications? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _notifications.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications cleared'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NotificationItem {
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });
}

enum NotificationType {
  order,
  promotional,
  priceDrop,
  delivery,
  newArrival,
}