import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense
}

@HiveType(typeId: 2)
class Category {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final IconData icon;
  @HiveField(3)
  final Color color;
  @HiveField(4)
  final TransactionType type;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  static List<Category> get expenseCategories => [
        Category(
          id: '1',
          name: 'Food',
          icon: Icons.restaurant,
          color: Colors.orange,
          type: TransactionType.expense,
        ),
        Category(
          id: '2',
          name: 'Transport',
          icon: Icons.directions_car,
          color: Colors.blue,
          type: TransactionType.expense,
        ),
        Category(
          id: '3',
          name: 'Shopping',
          icon: Icons.shopping_bag,
          color: Colors.purple,
          type: TransactionType.expense,
        ),
        Category(
          id: '4',
          name: 'Bills',
          icon: Icons.receipt,
          color: Colors.red,
          type: TransactionType.expense,
        ),
        Category(
          id: '5',
          name: 'Entertainment',
          icon: Icons.movie,
          color: Colors.pink,
          type: TransactionType.expense,
        ),
        Category(
          id: '6',
          name: 'Health',
          icon: Icons.favorite,
          color: Colors.green,
          type: TransactionType.expense,
        ),
        Category(
          id: '7',
          name: 'Education',
          icon: Icons.school,
          color: Colors.teal,
          type: TransactionType.expense,
        ),
        Category(
          id: '8',
          name: 'Other',
          icon: Icons.more_horiz,
          color: Colors.grey,
          type: TransactionType.expense,
        ),
      ];

  static List<Category> get incomeCategories => [
        Category(
          id: '9',
          name: 'Salary',
          icon: Icons.work,
          color: Colors.green,
          type: TransactionType.income,
        ),
        Category(
          id: '10',
          name: 'Freelance',
          icon: Icons.laptop,
          color: Colors.blue,
          type: TransactionType.income,
        ),
        Category(
          id: '11',
          name: 'Investment',
          icon: Icons.trending_up,
          color: Colors.purple,
          type: TransactionType.income,
        ),
        Category(
          id: '12',
          name: 'Gift',
          icon: Icons.card_giftcard,
          color: Colors.pink,
          type: TransactionType.income,
        ),
        Category(
          id: '13',
          name: 'Other',
          icon: Icons.more_horiz,
          color: Colors.grey,
          type: TransactionType.income,
        ),
      ];

  static List<Category> getAllCategories() {
    return [...expenseCategories, ...incomeCategories];
  }

  static Category getCategoryById(String id) {
    return getAllCategories().firstWhere((cat) => cat.id == id);
  }
}