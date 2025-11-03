// lib/models/user_model.dart
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final DateTime createdAt;
  final String? profileImage;
  final String? userType;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.createdAt,
    this.profileImage,
    this.userType,
  });

  // Factory constructor for creating User from Map (JSON)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      profileImage: json['profile_image'],
      userType: json['user_type'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : (json['createdAt'] != null 
              ? DateTime.parse(json['createdAt'])
              : DateTime.now()),
    );
  }

  // Convert User to Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'profile_image': profileImage,
      'user_type': userType,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Alternative method name for compatibility
  factory User.fromMap(Map<String, dynamic> map) => User.fromJson(map);
  
  // Alternative method name for compatibility  
  Map<String, dynamic> toMap() => toJson();

  // Simple method to create a new User with updated fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? profileImage,
    String? userType,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      profileImage: profileImage ?? this.profileImage,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}