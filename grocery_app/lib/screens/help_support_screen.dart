import 'package:flutter/material.dart';
import 'package:grocery_app/models/help_support_model.dart';
import 'package:grocery_app/services/url_launcher_service.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/widgets/help_support_widgets.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.responsivePadding(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding.left),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FAQ Section
            const SectionTitle(title: 'Frequently Asked Questions'),
            ...HelpSupportData.faqItems.map(
              (faq) => FAQItemWidget(faqItem: faq),
            ),

            const SizedBox(height: 24),

            // Contact Support
            const SectionTitle(title: 'Contact Support'),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: _buildContactOptions(context),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Store Information
            const SectionTitle(title: 'Store Information'),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...HelpSupportData.storeInfo.map(
                      (info) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: StoreInfoWidget(storeInfo: info),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Guides
            const SectionTitle(title: 'Quick Guides'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: HelpSupportData.quickGuides.map(
                (guide) => QuickGuideChip(
                  guide: guide,
                  onTap: () => _onQuickGuideTap(context, guide),
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContactOptions(BuildContext context) {
    final widgets = <Widget>[];
    
    for (int i = 0; i < HelpSupportData.contactOptions.length; i++) {
      final option = HelpSupportData.contactOptions[i];
      widgets.add(
        ContactOptionWidget(
          contactOption: option,
          onTap: () => _onContactOptionTap(context, option),
        ),
      );
      
      if (i < HelpSupportData.contactOptions.length - 1) {
        widgets.add(const Divider());
      }
    }
    
    return widgets;
  }

  void _onContactOptionTap(BuildContext context, ContactOption option) {
    switch (option.type) {
      case ContactType.phone:
        UrlLauncherService.launchPhone(option.value);
        break;
      case ContactType.email:
        UrlLauncherService.launchEmail(option.value);
        break;
      case ContactType.liveChat:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Live chat feature coming soon!'),
            backgroundColor: Colors.orange,
          ),
        );
        break;
    }
  }

  void _onQuickGuideTap(BuildContext context, QuickGuide guide) {
    // Handle quick guide tap - you can navigate to a detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening: ${guide.title}'),
        backgroundColor: Colors.green,
      ),
    );
  }
}