import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 3)
class AppUser {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String? name;
  @HiveField(3)
  final String? photoUrl;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final double monthlyBudget;
  @HiveField(6)
  final String currency;

  AppUser({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    required this.createdAt,
    this.monthlyBudget = 0.0,
    this.currency = 'USD',
  });

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    DateTime? createdAt,
    double? monthlyBudget,
    String? currency,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      currency: currency ?? this.currency,
    );
  }
}