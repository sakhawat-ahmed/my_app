import 'package:flutter/material.dart';
import 'package:grocery_app/models/notification_model.dart';

class NotificationSettingsPanel extends StatefulWidget {
  const NotificationSettingsPanel({super.key});

  @override
  State<NotificationSettingsPanel> createState() => _NotificationSettingsPanelState();
}

class _NotificationSettingsPanelState extends State<NotificationSettingsPanel> {
  final List<NotificationSetting> _settings = [];
  final List<NotificationFrequency> _frequencies = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    // In a real app, this would come from a provider or repository
    setState(() {
      _settings.addAll([
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
        // Add other settings...
      ]);
      
      _frequencies.addAll([
         NotificationFrequency(id: 'daily', label: 'Daily', isSelected: false),
         NotificationFrequency(id: 'weekly', label: 'Weekly', isSelected: true),
         NotificationFrequency(id: 'monthly', label: 'Monthly', isSelected: false),
         NotificationFrequency(id: 'never', label: 'Never', isSelected: false),
      ]);
    });
  }

  void _onSettingChanged(String id, bool value) {
    setState(() {
      final setting = _settings.firstWhere((s) => s.id == id);
      setting.value = value;
    });
  }

  void _onFrequencySelected(String id) {
    setState(() {
      for (var frequency in _frequencies) {
        frequency.isSelected = frequency.id == id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Notification Types'),
          _buildSettingsCard(_settings
              .where((s) => !s.id.contains('_notifications'))
              .toList()),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Notification Channels'),
          _buildSettingsCard(_settings
              .where((s) => s.id.contains('_notifications'))
              .toList()),
          
          const SizedBox(height: 24),
          
          _buildFrequencySection(),
          
          const SizedBox(height: 24),
          
          _buildClearAllButton(),
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

  Widget _buildSettingsCard(List<NotificationSetting> settings) {
    return Card(
      elevation: 2,
      child: Column(
        children: settings
            .map((setting) => _buildSettingSwitch(setting))
            .toList(),
      ),
    );
  }

  Widget _buildSettingSwitch(NotificationSetting setting) {
    return SwitchListTile(
      title: Text(setting.title),
      subtitle: Text(setting.description),
      value: setting.value,
      onChanged: (value) => _onSettingChanged(setting.id, value),
    );
  }

  Widget _buildFrequencySection() {
    return Card(
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
              children: _frequencies
                  .map((frequency) => _buildFrequencyChip(frequency))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyChip(NotificationFrequency frequency) {
    return ChoiceChip(
      label: Text(frequency.label),
      selected: frequency.isSelected,
      onSelected: (selected) => _onFrequencySelected(frequency.id),
      selectedColor: Colors.green,
      labelStyle: TextStyle(
        color: frequency.isSelected ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildClearAllButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Handle clear all notifications
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        child: const Text('Clear All Notifications'),
      ),
    );
  }
}