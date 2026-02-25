import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../services/hive_service.dart';

final transactionProvider = StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  return TransactionNotifier();
});

final filteredTransactionsProvider = Provider((ref) {
  final state = ref.watch(transactionProvider);
  final filter = ref.watch(transactionFilterProvider);
  
  return _filterTransactions(state.transactions, filter);
});

final transactionFilterProvider = StateProvider<TransactionFilter>((ref) {
  return TransactionFilter();
});

class TransactionFilter {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? categoryId;
  final TransactionType? type;
  final String? searchQuery;

  TransactionFilter({
    this.startDate,
    this.endDate,
    this.categoryId,
    this.type,
    this.searchQuery,
  });

  TransactionFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    TransactionType? type,
    String? searchQuery,
  }) {
    return TransactionFilter(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

List<Transaction> _filterTransactions(
    List<Transaction> transactions, TransactionFilter filter) {
  return transactions.where((t) {
    if (filter.startDate != null && t.date.isBefore(filter.startDate!)) {
      return false;
    }
    if (filter.endDate != null && t.date.isAfter(filter.endDate!)) {
      return false;
    }
    if (filter.categoryId != null && t.categoryId != filter.categoryId) {
      return false;
    }
    if (filter.type != null && t.type != filter.type) {
      return false;
    }
    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.toLowerCase();
      return t.title.toLowerCase().contains(query) ||
          t.note?.toLowerCase().contains(query) == true;
    }
    return true;
  }).toList();
}

class TransactionState {
  final List<Transaction> transactions;
  final bool isLoading;
  final String? error;
  final double monthlyBudget;

  TransactionState({
    required this.transactions,
    this.isLoading = false,
    this.error,
    this.monthlyBudget = 0,
  });

  TransactionState copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    String? error,
    double? monthlyBudget,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
    );
  }

  double get totalBalance {
    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpense = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    return totalIncome - totalExpense;
  }

  double get totalIncome {
    return transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get currentMonthExpense {
    final now = DateTime.now();
    return transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  bool get isOverBudget => monthlyBudget > 0 && currentMonthExpense > monthlyBudget;

  Map<String, double> getCategoryExpenses() {
    final expenseTransactions = transactions
        .where((t) => t.type == TransactionType.expense);
    
    final Map<String, double> categoryExpenses = {};
    
    for (var transaction in expenseTransactions) {
      final categoryId = transaction.categoryId;
      categoryExpenses[categoryId] = 
          (categoryExpenses[categoryId] ?? 0) + transaction.amount;
    }
    
    return categoryExpenses;
  }

  Map<String, double> getMonthlySummary() {
    final Map<String, double> monthlyData = {};
    final now = DateTime.now();
    
    for (int i = 6; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey = DateFormat('MMM yyyy').format(month);
      
      final monthExpense = transactions
          .where((t) =>
              t.type == TransactionType.expense &&
              t.date.month == month.month &&
              t.date.year == month.year)
          .fold(0.0, (sum, t) => sum + t.amount);
      
      monthlyData[monthKey] = monthExpense;
    }
    
    return monthlyData;
  }
}

class TransactionNotifier extends StateNotifier<TransactionState> {
  TransactionNotifier() : super(TransactionState(transactions: [])) {
    loadTransactions();
  }

  void loadTransactions() {
    final user = HiveService.getCurrentUser();
    if (user != null) {
      final transactions = HiveService.getTransactions(user.id);
      state = state.copyWith(
        transactions: transactions,
        monthlyBudget: user.monthlyBudget,
      );
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      await HiveService.addTransaction(transaction);
      final transactions = [...state.transactions, transaction]
        ..sort((a, b) => b.date.compareTo(a.date));
      state = state.copyWith(transactions: transactions);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      await HiveService.updateTransaction(transaction);
      final transactions = state.transactions.map((t) {
        return t.id == transaction.id ? transaction : t;
      }).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      state = state.copyWith(transactions: transactions);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await HiveService.deleteTransaction(id);
      final transactions =
          state.transactions.where((t) => t.id != id).toList();
      state = state.copyWith(transactions: transactions);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}