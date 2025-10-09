import 'package:flutter/material.dart';
import 'package:grocery_app/screens/help_support_screen.dart';
import 'package:grocery_app/screens/notifications_screen.dart';
import 'package:provider/provider.dart';
import 'package:grocery_app/providers/theme_provider.dart';
import 'package:grocery_app/utils/responsive_utils.dart';
import 'package:grocery_app/widgets/setting_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final padding = ResponsiveUtils.responsivePadding(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding.left),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            _buildProfileCard(),

            const SizedBox(height: 24),

            // Account Settings
            _buildSectionTitle('Account Settings', Icons.person_outline),
            _buildSettingsCard([
              SettingTile(
                icon: Icons.person,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () {},
                gradient: const [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              SettingTile(
                icon: Icons.location_on,
                title: 'Delivery Address',
                subtitle: 'Manage your delivery locations',
                onTap: () {},
                gradient: const [Color(0xFFf093fb), Color(0xFFf5576c)],
              ),
              SettingTile(
                icon: Icons.payment,
                title: 'Payment Methods',
                subtitle: 'Add or remove payment options',
                onTap: () {},
                gradient: const [Color(0xFF4facfe), Color(0xFF00f2fe)],
              ),
            ]),

            const SizedBox(height: 24),

            // App Preferences
            _buildSectionTitle('App Preferences', Icons.settings_outlined),
            _buildSettingsCard([
              SettingTile(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Manage your notification preferences',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  );
                },
                gradient: const [Color(0xFF43e97b), Color(0xFF38f9d7)],
              ),
              _buildThemeSwitch(themeProvider),
              SettingTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English (US)',
                onTap: () {
                  _showLanguageDialog(context);
                },
                gradient: const [Color(0xFFfa709a), Color(0xFFfee140)],
              ),
            ]),

            const SizedBox(height: 24),

            // Support
            _buildSectionTitle('Support', Icons.help_outline),
            _buildSettingsCard([
              SettingTile(
                icon: Icons.help,
                title: 'Help & Support',
                subtitle: 'Get help with the app',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                  );
                },
                gradient: const [Color(0xFFa8edea), Color(0xFFfed6e3)],
              ),
              SettingTile(
                icon: Icons.bug_report,
                title: 'Report a Bug',
                subtitle: 'Found an issue? Let us know',
                onTap: () {
                  _showBugReportDialog(context);
                },
                gradient: const [Color(0xFFffecd2), Color(0xFFfcb69f)],
              ),
              SettingTile(
                icon: Icons.star,
                title: 'Rate App',
                subtitle: 'Share your experience',
                onTap: () {},
                gradient: const [Color(0xFFff9a9e), Color(0xFFfecfef)],
              ),
            ]),

            const SizedBox(height: 24),

            // App Version with beautiful card
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 40),
                    const SizedBox(height: 8),
                    const Text(
                      'Grocery Store',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(Icons.person, size: 30, color: Colors.green),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Premium Member',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified, color: Colors.white, size: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildThemeSwitch(ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ListTile(
        leading: const Icon(Icons.dark_mode, color: Colors.white),
        title: const Text(
          'Dark Mode',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        subtitle: const Text(
          'Switch between light and dark theme',
          style: TextStyle(color: Colors.white70),
        ),
        trailing: Transform.scale(
          scale: 0.8,
          child: Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withOpacity(0.5),
          ),
        ),
        onTap: () {
          themeProvider.toggleTheme();
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Language',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildLanguageOption('English (US)', true),
                _buildLanguageOption('Spanish', false),
                _buildLanguageOption('French', false),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isSelected ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: isSelected
            ? const Icon(Icons.check_circle, color: Colors.white)
            : const Icon(Icons.radio_button_unchecked, color: Colors.white70),
        title: Text(
          language,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  void _showBugReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bug_report, color: Colors.orange, size: 50),
                const SizedBox(height: 16),
                const Text(
                  'Report a Bug',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text('Please describe the issue you encountered:'),
                const SizedBox(height: 16),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Describe the issue...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Thank you for your feedback!'),
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}