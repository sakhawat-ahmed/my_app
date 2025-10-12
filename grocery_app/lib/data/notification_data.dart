import 'package:grocery_app/models/notification_model.dart';

class NotificationData {
  static List<NotificationItem> get sampleNotifications => [
    NotificationItem(
      id: '1',
      title: 'Order Confirmed',
      message: 'Your order #12345 has been confirmed and is being processed',
      time: '2 hours ago',
      type: NotificationType.order,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Special Offer!',
      message: '50% off on fresh vegetables this weekend. Limited time offer!',
      time: '1 day ago',
      type: NotificationType.promotional,
      isRead: true,
    ),
    NotificationItem(
      id: '3',
      title: 'Price Drop Alert',
      message: 'Milk price has dropped! Check it out now and save more',
      time: '2 days ago',
      type: NotificationType.priceDrop,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Delivery Update',
      message: 'Your order will be delivered in 30 minutes. Get ready!',
      time: '3 days ago',
      type: NotificationType.delivery,
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'New Products Alert',
      message: 'Check out our new organic products just for you!',
      time: '1 week ago',
      type: NotificationType.newArrival,
      isRead: true,
    ),
  ];

  static List<NotificationSetting> get notificationSettings => [
    NotificationSetting(
      id: 'order_updates',
      title: 'Order Updates',
      description: 'Order confirmations and status updates',
      value: true,
    ),
    NotificationSetting(
      id: 'promotional_offers',
      title: 'Promotional Offers',
      description: 'Special deals and discounts',
      value: true,
    ),
    NotificationSetting(
      id: 'price_drop_alerts',
      title: 'Price Drop Alerts',
      description: 'Notifications when prices drop',
      value: true,
    ),
    NotificationSetting(
      id: 'new_arrivals',
      title: 'New Arrivals',
      description: 'New product notifications',
      value: false,
    ),
    NotificationSetting(
      id: 'delivery_updates',
      title: 'Delivery Updates',
      description: 'Real-time delivery tracking',
      value: true,
    ),
    NotificationSetting(
      id: 'push_notifications',
      title: 'Push Notifications',
      description: 'Receive notifications in the app',
      value: true,
    ),
    NotificationSetting(
      id: 'email_notifications',
      title: 'Email Notifications',
      description: 'Receive notifications via email',
      value: false,
    ),
    NotificationSetting(
      id: 'sms_notifications',
      title: 'SMS Notifications',
      description: 'Receive notifications via SMS',
      value: false,
    ),
  ];

  static List<NotificationFrequency> get frequencyOptions => [
    const NotificationFrequency(
      id: 'daily',
      label: 'Daily',
      isSelected: false,
    ),
    const NotificationFrequency(
      id: 'weekly',
      label: 'Weekly',
      isSelected: true,
    ),
    const NotificationFrequency(
      id: 'monthly',
      label: 'Monthly',
      isSelected: false,
    ),
    const NotificationFrequency(
      id: 'never',
      label: 'Never',
      isSelected: false,
    ),
  ];
}