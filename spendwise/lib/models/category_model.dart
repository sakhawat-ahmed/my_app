import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// Remove this line: part 'category_model.g.dart';

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
  final String iconData;
  @HiveField(3)
  final int colorValue;
  @HiveField(4)
  final TransactionType type;

  Category({
    required this.id,
    required this.name,
    required this.iconData,
    required this.colorValue,
    required this.type,
  });

  IconData get icon {
    switch (iconData) {
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'receipt':
        return Icons.receipt;
      case 'movie':
        return Icons.movie;
      case 'favorite':
        return Icons.favorite;
      case 'school':
        return Icons.school;
      case 'more_horiz':
        return Icons.more_horiz;
      case 'work':
        return Icons.work;
      case 'laptop':
        return Icons.laptop;
      case 'trending_up':
        return Icons.trending_up;
      case 'card_giftcard':
        return Icons.card_giftcard;
      default:
        return Icons.attach_money;
    }
  }

  Color get color => Color(colorValue);

  static List<Category> get expenseCategories => [
        Category(
          id: '1',
          name: 'Food',
          iconData: 'restaurant',
          colorValue: 0xFFFF9800,
          type: TransactionType.expense,
        ),
        Category(
          id: '2',
          name: 'Transport',
          iconData: 'directions_car',
          colorValue: 0xFF2196F3,
          type: TransactionType.expense,
        ),
        Category(
          id: '3',
          name: 'Shopping',
          iconData: 'shopping_bag',
          colorValue: 0xFF9C27B0,
          type: TransactionType.expense,
        ),
        Category(
          id: '4',
          name: 'Bills',
          iconData: 'receipt',
          colorValue: 0xFFF44336,
          type: TransactionType.expense,
        ),
        Category(
          id: '5',
          name: 'Entertainment',
          iconData: 'movie',
          colorValue: 0xFFE91E63,
          type: TransactionType.expense,
        ),
        Category(
          id: '6',
          name: 'Health',
          iconData: 'favorite',
          colorValue: 0xFF4CAF50,
          type: TransactionType.expense,
        ),
        Category(
          id: '7',
          name: 'Education',
          iconData: 'school',
          colorValue: 0xFF009688,
          type: TransactionType.expense,
        ),
        Category(
          id: '8',
          name: 'Other',
          iconData: 'more_horiz',
          colorValue: 0xFF9E9E9E,
          type: TransactionType.expense,
        ),
      ];

  static List<Category> get incomeCategories => [
        Category(
          id: '9',
          name: 'Salary',
          iconData: 'work',
          colorValue: 0xFF4CAF50,
          type: TransactionType.income,
        ),
        Category(
          id: '10',
          name: 'Freelance',
          iconData: 'laptop',
          colorValue: 0xFF2196F3,
          type: TransactionType.income,
        ),
        Category(
          id: '11',
          name: 'Investment',
          iconData: 'trending_up',
          colorValue: 0xFF9C27B0,
          type: TransactionType.income,
        ),
        Category(
          id: '12',
          name: 'Gift',
          iconData: 'card_giftcard',
          colorValue: 0xFFE91E63,
          type: TransactionType.income,
        ),
        Category(
          id: '13',
          name: 'Other',
          iconData: 'more_horiz',
          colorValue: 0xFF9E9E9E,
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