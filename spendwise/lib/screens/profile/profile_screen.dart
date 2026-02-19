import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../services/hive_service.dart';
import '../../services/export_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditingBudget = false;
  final _budgetController = TextEditingController();

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await ref.read(authProvider.notifier).signOut();
    }
  }

  Future<void> _exportData() async {
    final success = await ExportService.exportToCSV();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Data exported successfully' : 'Failed to export data',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _updateBudget() async {
    final user = ref.read(authProvider).user;
    if (user != null && _budgetController.text.isNotEmpty) {
      final budget = double.tryParse(_budgetController.text) ?? 0;
      final updatedUser = user.copyWith(monthlyBudget: budget);
      await ref.read(authProvider.notifier).updateUser(updatedUser);
      ref.read(transactionProvider.notifier).loadTransactions();
      setState(() {
        _isEditingBudget = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final transactionState = ref.watch(transactionProvider);
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final user = authState.user;

    return Container(
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.light
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF6F5FC),
                  Color(0xFFEDEAF6),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E1E2C),
                  Color(0xFF2D2A3A),
                ],
              ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your account settings',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Profile Card
                    Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primaryContainer,
                              child: Text(
                                user?.name?[0].toUpperCase() ?? 'U',
                                style: GoogleFonts.poppins(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user?.name ?? 'User',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color:
                                    Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Member since ${DateFormat('MMM yyyy').format(user?.createdAt ?? DateTime.now())}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color:
                                    Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Monthly Budget Card
                    Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Monthly Budget',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.onBackground,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _isEditingBudget ? Icons.check : Icons.edit,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    if (_isEditingBudget) {
                                      _updateBudget();
                                    } else {
                                      _budgetController.text =
                                          transactionState.monthlyBudget
                                              .toStringAsFixed(2);
                                      setState(() {
                                        _isEditingBudget = true;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (_isEditingBudget)
                              TextField(
                                controller: _budgetController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter monthly budget',
                                  prefixText: '\$',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Current Budget',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    '\$${NumberFormat('#,##0.00').format(transactionState.monthlyBudget)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                ],
                              ),
                            if (!_isEditingBudget)
                              const SizedBox(height: 12),
                            if (!_isEditingBudget)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Current Month Spending',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    '\$${NumberFormat('#,##0.00').format(transactionState.currentMonthExpense)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: transactionState.isOverBudget
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            if (!_isEditingBudget &&
                                transactionState.monthlyBudget > 0)
                              const SizedBox(height: 12),
                            if (!_isEditingBudget &&
                                transactionState.monthlyBudget > 0)
                              LinearProgressIndicator(
                                value: transactionState.currentMonthExpense /
                                    transactionState.monthlyBudget,
                                backgroundColor:
                                    Theme.of(context).colorScheme.surfaceVariant,
                                color: transactionState.isOverBudget
                                    ? Colors.red
                                    : Theme.of(context).colorScheme.primary,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Settings
                    Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Settings',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Dark Mode Toggle
                            _buildSettingsItem(
                              icon: Icons.dark_mode_outlined,
                              title: 'Dark Mode',
                              trailing: Switch(
                                value: isDarkMode,
                                onChanged: (value) {
                                  ref.read(themeProvider.notifier).toggleTheme();
                                },
                              ),
                            ),
                            
                            const Divider(height: 24),
                            
                            // Currency (Future implementation)
                            _buildSettingsItem(
                              icon: Icons.attach_money,
                              title: 'Currency',
                              subtitle: HiveService.getCurrency(),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                // Navigate to currency selection
                              },
                            ),
                            
                            const Divider(height: 24),
                            
                            // Export Data
                            _buildSettingsItem(
                              icon: Icons.download_outlined,
                              title: 'Export Data',
                              subtitle: 'CSV format',
                              trailing: const Icon(Icons.chevron_right),
                              onTap: _exportData,
                            ),
                            
                            const Divider(height: 24),
                            
                            // Backup & Restore (Future implementation)
                            _buildSettingsItem(
                              icon: Icons.backup_outlined,
                              title: 'Backup & Restore',
                              subtitle: 'Google Drive',
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                // Implement backup & restore
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.1),
                          foregroundColor: Colors.red,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.red.withOpacity(0.3)),
                          ),
                        ),
                        child: Text(
                          'Logout',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // App Version
                    Center(
                      child: Text(
                        'Version 1.0.0',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}