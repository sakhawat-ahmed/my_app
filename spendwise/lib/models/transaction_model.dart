import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'category_model.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final String categoryId;
  @HiveField(4)
  final DateTime date;
  @HiveField(5)
  final TransactionType type;
  @HiveField(6)
  final String? note;
  @HiveField(7)
  final String userId;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.type,
    this.note,
    required this.userId,
  });

  String get formattedDate => DateFormat('MMM dd, yyyy').format(date);
  String get formattedAmount {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '${type == TransactionType.income ? '+' : '-'}\$${formatter.format(amount)}';
  }

  Category get category => Category.getCategoryById(categoryId);
  
  Color get amountColor => type == TransactionType.income 
      ? Colors.green 
      : Colors.red;
}