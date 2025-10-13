enum NotificationType {
  order,
  promotional,
  priceDrop,
  delivery,
  newArrival,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isRead,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class NotificationSetting {
  final String id;
  final String title;
  final String description;
  bool value;

  NotificationSetting({
    required this.id,
    required this.title,
    required this.description,
    required this.value,
  });
}

class NotificationFrequency {
  final String id;
  final String label;
  bool isSelected;

   NotificationFrequency({
    required this.id,
    required this.label,
     required this.isSelected,
  });
}