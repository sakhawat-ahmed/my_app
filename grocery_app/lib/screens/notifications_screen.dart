import 'package:flutter/material.dart';
import 'package:grocery_app/widgets/notifications/notification_list_section.dart';
import 'package:grocery_app/widgets/notifications/notification_settings_panel.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
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
        body: const TabBarView(
          children: [
            NotificationListSection(),
            NotificationSettingsPanel(),
          ],
        ),
      ),
    );
  }
}