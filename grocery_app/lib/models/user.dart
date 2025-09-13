class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String profileImageUrl;
  final bool isPremium;
  final DateTime joinDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.profileImageUrl = '',
    this.isPremium = false,
    required this.joinDate,
  });

  // Add fromJson and toJson methods if needed
}