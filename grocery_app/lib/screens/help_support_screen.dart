import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:grocery_app/utils/responsive_utils.dart';

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
            _buildSectionTitle('Frequently Asked Questions'),
            _buildFAQItem(
              'How do I place an order?',
              'Browse products, add to cart, and proceed to checkout. You can choose delivery or pickup options.',
            ),
            _buildFAQItem(
              'What payment methods are accepted?',
              'We accept credit/debit cards, digital wallets, and cash on delivery.',
            ),
            _buildFAQItem(
              'How can I track my order?',
              'Go to My Orders section to track your order in real-time.',
            ),
            _buildFAQItem(
              'What is your return policy?',
              'We accept returns within 7 days for damaged or incorrect items.',
            ),

            const SizedBox(height: 24),

            // Contact Support
            _buildSectionTitle('Contact Support'),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildContactOption(
                      Icons.phone,
                      'Call Us',
                      '+1 (555) 123-4567',
                      () => _launchURL('tel:+15551234567'),
                    ),
                    const Divider(),
                    _buildContactOption(
                      Icons.email,
                      'Email Us',
                      'support@grocerystore.com',
                      () => _launchURL('mailto:support@grocerystore.com'),
                    ),
                    const Divider(),
                    _buildContactOption(
                      Icons.chat,
                      'Live Chat',
                      'Available 24/7',
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Live chat feature coming soon!'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Store Information
            _buildSectionTitle('Store Information'),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoreInfoItem(Icons.access_time, 'Opening Hours', 'Mon-Sun: 6:00 AM - 11:00 PM'),
                    const SizedBox(height: 12),
                    _buildStoreInfoItem(Icons.location_on, 'Address', '123 Grocery Street, City, State 12345'),
                    const SizedBox(height: 12),
                    _buildStoreInfoItem(Icons.directions_car, 'Delivery Radius', 'Up to 10 miles from store location'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Guides
            _buildSectionTitle('Quick Guides'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildGuideChip('How to use coupons', () {}),
                _buildGuideChip('Delivery instructions', () {}),
                _buildGuideChip('Account setup', () {}),
                _buildGuideChip('Payment troubleshooting', () {}),
                _buildGuideChip('Order cancellation', () {}),
                _buildGuideChip('Refund process', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
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

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
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

  Widget _buildContactOption(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildStoreInfoItem(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
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

  Widget _buildGuideChip(String title, VoidCallback onTap) {
    return ActionChip(
      label: Text(title),
      onPressed: onTap,
      backgroundColor: Colors.green[50],
      labelStyle: const TextStyle(color: Colors.green),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}