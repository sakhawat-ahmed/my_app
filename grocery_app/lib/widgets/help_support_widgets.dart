import 'package:flutter/material.dart';
import 'package:grocery_app/models/help_support_model.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
}

class FAQItemWidget extends StatelessWidget {
  final FAQItem faqItem;

  const FAQItemWidget({super.key, required this.faqItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          faqItem.question,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              faqItem.answer,
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactOptionWidget extends StatelessWidget {
  final ContactOption contactOption;
  final VoidCallback onTap;

  const ContactOptionWidget({
    super.key,
    required this.contactOption,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        _getContactIcon(contactOption.type),
        color: Colors.green,
      ),
      title: Text(contactOption.title),
      subtitle: Text(contactOption.subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  IconData _getContactIcon(ContactType type) {
    switch (type) {
      case ContactType.phone:
        return Icons.phone;
      case ContactType.email:
        return Icons.email;
      case ContactType.liveChat:
        return Icons.chat;
    }
  }
}

class StoreInfoWidget extends StatelessWidget {
  final StoreInfo storeInfo;

  const StoreInfoWidget({super.key, required this.storeInfo});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          _getStoreInfoIcon(storeInfo.type),
          color: Colors.green,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                storeInfo.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                storeInfo.value,
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getStoreInfoIcon(StoreInfoType type) {
    switch (type) {
      case StoreInfoType.openingHours:
        return Icons.access_time;
      case StoreInfoType.address:
        return Icons.location_on;
      case StoreInfoType.deliveryRadius:
        return Icons.directions_car;
    }
  }
}

class QuickGuideChip extends StatelessWidget {
  final QuickGuide guide;
  final VoidCallback onTap;

  const QuickGuideChip({
    super.key,
    required this.guide,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(guide.title),
      onPressed: onTap,
      backgroundColor: Colors.green[50],
      labelStyle: const TextStyle(color: Colors.green),
    );
  }
}