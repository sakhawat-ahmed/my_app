import 'dart:io';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/category_model.dart';
import 'hive_service.dart';

class ExportService {
  static Future<bool> exportToCSV() async {
    try {
      final user = HiveService.getCurrentUser();
      if (user == null) return false;

      final transactions = HiveService.getTransactions(user.id);
      
      // Create CSV data
      List<List<dynamic>> rows = [];
      
      // Header row
      rows.add([
        'Date',
        'Title',
        'Amount',
        'Type',
        'Category',
        'Note',
      ]);
      
      // Data rows
      for (var transaction in transactions) {
        rows.add([
          DateFormat('yyyy-MM-dd HH:mm:ss').format(transaction.date),
          transaction.title,
          transaction.amount,
          transaction.type == TransactionType.income ? 'Income' : 'Expense',
          transaction.category.name,
          transaction.note ?? '',
        ]);
      }
      
      // Convert to CSV
      String csv = const ListToCsvConverter().convert(rows);
      
      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/expense_tracker_export_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv');
      await file.writeAsString(csv);
      
      // Share file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Expense Tracker Export',
      );
      
      return true;
    } catch (e) {
      return false;
    }
  }
}