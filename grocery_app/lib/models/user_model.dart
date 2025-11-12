class User {
  final String id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String userType;
  final String? profilePicture;
  final DateTime? dateOfBirth;
  final int loyaltyPoints;
  final String? storeName;
  final String? storeDescription;
  final DateTime dateJoined;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    required this.userType,
    this.profilePicture,
    this.dateOfBirth,
    this.loyaltyPoints = 0,
    this.storeName,
    this.storeDescription,
    required this.dateJoined,
  });

  String get name => username;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      userType: json['user_type'] ?? 'customer',
      profilePicture: json['profile_picture'],
      dateOfBirth: json['date_of_birth'] != null ? DateTime.parse(json['date_of_birth']) : null,
      loyaltyPoints: json['loyalty_points'] ?? 0,
      storeName: json['store_name'],
      storeDescription: json['store_description'],
      dateJoined: DateTime.parse(json['date_joined'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'user_type': userType,
      'profile_picture': profilePicture,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'loyalty_points': loyaltyPoints,
      'store_name': storeName,
      'store_description': storeDescription,
      'date_joined': dateJoined.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) => User.fromJson(map);
  Map<String, dynamic> toMap() => toJson();

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? userType,
    String? profilePicture,
    DateTime? dateOfBirth,
    int? loyaltyPoints,
    String? storeName,
    String? storeDescription,
    DateTime? dateJoined,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      profilePicture: profilePicture ?? this.profilePicture,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      storeName: storeName ?? this.storeName,
      storeDescription: storeDescription ?? this.storeDescription,
      dateJoined: dateJoined ?? this.dateJoined,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}