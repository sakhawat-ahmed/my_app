import 'dart:async';
import 'package:flutter/foundation.dart' hide Category;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import '../models/category_model.dart';

// Manual TypeAdapters
class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 1;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.income;
      case 1:
        return TransactionType.expense;
      default:
        return TransactionType.expense;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.income:
        writer.writeByte(0);
        break;
      case TransactionType.expense:
        writer.writeByte(1);
        break;
    }
  }
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 2;

  @override
  Category read(BinaryReader reader) {
    return Category(
      id: reader.readString(),
      name: reader.readString(),
      iconData: reader.readString(),
      colorValue: reader.readInt(),
      type: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.iconData);
    writer.writeInt(obj.colorValue);
    writer.write(obj.type);
  }
}

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 0;

  @override
  Transaction read(BinaryReader reader) {
    return Transaction(
      id: reader.readString(),
      title: reader.readString(),
      amount: reader.readDouble(),
      categoryId: reader.readString(),
      date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      type: reader.read(),
      note: reader.read(),
      userId: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeDouble(obj.amount);
    writer.writeString(obj.categoryId);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.write(obj.type);
    writer.write(obj.note);
    writer.writeString(obj.userId);
  }
}

class AppUserAdapter extends TypeAdapter<AppUser> {
  @override
  final int typeId = 3;

  @override
  AppUser read(BinaryReader reader) {
    return AppUser(
      id: reader.readString(),
      email: reader.readString(),
      name: reader.read(),
      photoUrl: reader.read(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      monthlyBudget: reader.readDouble(),
      currency: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, AppUser obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.email);
    writer.write(obj.name);
    writer.write(obj.photoUrl);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
    writer.writeDouble(obj.monthlyBudget);
    writer.writeString(obj.currency);
  }
}

class HiveService {
  static const String transactionsBox = 'transactions';
  static const String userBox = 'user';
  static const String settingsBox = 'settings';

  static late Box<Transaction> _transactionBox;
  static late Box<AppUser> _userBox;
  static late Box _settingsBox;

  static Future<void> init() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
      
      // Register adapters manually
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(TransactionAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(TransactionTypeAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(CategoryAdapter());
      }
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(AppUserAdapter());
      }
      
      // Open boxes
      _transactionBox = await Hive.openBox<Transaction>(transactionsBox);
      _userBox = await Hive.openBox<AppUser>(userBox);
      _settingsBox = await Hive.openBox(settingsBox);
    } catch (e) {
      print('Error initializing Hive: $e');
    }
  }

  // Transaction methods
  static Future<void> addTransaction(Transaction transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  static Future<void> updateTransaction(Transaction transaction) async {
    await _transactionBox.put(transaction.id, transaction);
  }

  static Future<void> deleteTransaction(String id) async {
    await _transactionBox.delete(id);
  }

  static List<Transaction> getTransactions(String userId) {
    return _transactionBox.values
        .where((t) => t.userId == userId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static ValueListenable<Box<Transaction>> listenToTransactions() {
    return _transactionBox.listenable();
  }

  // User methods
  static Future<void> saveUser(AppUser user) async {
    await _userBox.put('currentUser', user);
  }

  static AppUser? getCurrentUser() {
    return _userBox.get('currentUser');
  }

  static Future<void> updateUser(AppUser user) async {
    await _userBox.put('currentUser', user);
  }

  static Future<void> clearUser() async {
    await _userBox.delete('currentUser');
  }

  // Settings methods
  static Future<void> setDarkMode(bool isDark) async {
    await _settingsBox.put('isDarkMode', isDark);
  }

  static bool getDarkMode() {
    return _settingsBox.get('isDarkMode', defaultValue: false);
  }

  static Future<void> setCurrency(String currency) async {
    await _settingsBox.put('currency', currency);
  }

  static String getCurrency() {
    return _settingsBox.get('currency', defaultValue: 'USD');
  }
}