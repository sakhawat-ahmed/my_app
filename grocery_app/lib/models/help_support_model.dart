class FAQItem {
  final String question;
  final String answer;

  const FAQItem({
    required this.question,
    required this.answer,
  });
}

class ContactOption {
  final String title;
  final String subtitle;
  final String value;
  final ContactType type;

  const ContactOption({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.type,
  });
}

class StoreInfo {
  final String title;
  final String value;
  final StoreInfoType type;

  const StoreInfo({
    required this.title,
    required this.value,
    required this.type,
  });
}

class QuickGuide {
  final String title;
  final String description;

  const QuickGuide({
    required this.title,
    required this.description,
  });
}

enum ContactType {
  phone,
  email,
  liveChat,
}

enum StoreInfoType {
  openingHours,
  address,
  deliveryRadius,
}

class HelpSupportData {
  static final List<FAQItem> faqItems = [
    FAQItem(
      question: 'How do I place an order?',
      answer: 'Browse products, add to cart, and proceed to checkout. You can choose delivery or pickup options.',
    ),
    FAQItem(
      question: 'What payment methods are accepted?',
      answer: 'We accept credit/debit cards, digital wallets, and cash on delivery.',
    ),
    FAQItem(
      question: 'How can I track my order?',
      answer: 'Go to My Orders section to track your order in real-time.',
    ),
    FAQItem(
      question: 'What is your return policy?',
      answer: 'We accept returns within 7 days for damaged or incorrect items.',
    ),
  ];

  static final List<ContactOption> contactOptions = [
    ContactOption(
      title: 'Call Us',
      subtitle: '+1 (555) 123-4567',
      value: 'tel:+15551234567',
      type: ContactType.phone,
    ),
    ContactOption(
      title: 'Email Us',
      subtitle: 'support@grocerystore.com',
      value: 'mailto:support@grocerystore.com',
      type: ContactType.email,
    ),
    ContactOption(
      title: 'Live Chat',
      subtitle: 'Available 24/7',
      value: 'live_chat',
      type: ContactType.liveChat,
    ),
  ];

  static final List<StoreInfo> storeInfo = [
    StoreInfo(
      title: 'Opening Hours',
      value: 'Mon-Sun: 6:00 AM - 11:00 PM',
      type: StoreInfoType.openingHours,
    ),
    StoreInfo(
      title: 'Address',
      value: '123 Grocery Street, City, State 12345',
      type: StoreInfoType.address,
    ),
    StoreInfo(
      title: 'Delivery Radius',
      value: 'Up to 10 miles from store location',
      type: StoreInfoType.deliveryRadius,
    ),
  ];

  static final List<QuickGuide> quickGuides = [
    QuickGuide(
      title: 'How to use coupons',
      description: 'Learn how to apply discount coupons to your orders',
    ),
    QuickGuide(
      title: 'Delivery instructions',
      description: 'Set delivery preferences and instructions',
    ),
    QuickGuide(
      title: 'Account setup',
      description: 'Complete guide to setting up your account',
    ),
    QuickGuide(
      title: 'Payment troubleshooting',
      description: 'Solve common payment issues',
    ),
    QuickGuide(
      title: 'Order cancellation',
      description: 'How to cancel or modify your orders',
    ),
    QuickGuide(
      title: 'Refund process',
      description: 'Step-by-step refund procedure',
    ),
  ];
} 