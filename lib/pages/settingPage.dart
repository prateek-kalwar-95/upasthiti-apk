import 'package:flutter/material.dart';
import 'package:sih/pages/helpSupport.dart';
import 'package:sih/pages/profilePage.dart';
import 'package:sih/root/splace.dart';
import 'package:sih/service/auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;
  bool darkMode = false;
  bool biometric = false;

  get Navigatior => null;

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Account deletion requested. You will receive a confirmation email.',
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
                await AuthServices().signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool isToggle = false,
    bool? toggleValue,
    ValueChanged<bool>? onToggleChanged,
    bool isDangerous = false,
    bool hasArrow = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        shadowColor: Colors.black12,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDangerous
                        ? Colors.red.shade100
                        : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isDangerous
                        ? Colors.red.shade600
                        : Colors.blue.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDangerous
                              ? Colors.red.shade600
                              : Colors.black,
                        ),
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (isToggle && toggleValue != null && onToggleChanged != null)
                  Switch(
                    value: toggleValue,
                    onChanged: onToggleChanged,
                    activeColor: Colors.blue.shade600,
                  )
                else if (hasArrow)
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.indigo.shade100],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.all(24),
              //   decoration: BoxDecoration(
              //     color: Colors.blue.shade600,
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.blue.shade200,
              //         blurRadius: 10,
              //         offset: const Offset(0, 4),
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Text(
              //         'Settings',
              //         style: TextStyle(
              //           fontSize: 28,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white,
              //         ),
              //       ),
              //       const SizedBox(height: 8),
              //       Text(
              //         'Manage your account and preferences',
              //         style: TextStyle(
              //           fontSize: 16,
              //           color: Colors.blue.shade100,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Account Section
                      _buildSectionHeader('Account'),
                      _buildSettingItem(
                        icon: Icons.person_outline,
                        title: 'Profile',
                        subtitle: 'Edit your personal information',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile settings opened'),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        },
                      ),
                      _buildSettingItem(
                        icon: Icons.lock_outline,
                        title: 'Change Password',
                        subtitle: 'Update your account password',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password change opened'),
                            ),
                          );
                        },
                      ),
                      _buildSettingItem(
                        icon: Icons.visibility_outlined,
                        title: 'Privacy',
                        subtitle: 'Control your data and privacy',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Privacy settings opened'),
                            ),
                          );
                        },
                      ),

                      // Preferences Section
                      _buildSectionHeader('Preferences'),
                      _buildSettingItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Push notifications and alerts',
                        isToggle: true,
                        toggleValue: notifications,
                        onToggleChanged: (value) =>
                            setState(() => notifications = value),
                      ),
                      _buildSettingItem(
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        subtitle: 'Switch to dark theme',
                        isToggle: true,
                        toggleValue: darkMode,
                        onToggleChanged: (value) =>
                            setState(() => darkMode = value),
                      ),
                      _buildSettingItem(
                        icon: Icons.language_outlined,
                        title: 'Language',
                        subtitle: 'English (US)',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Language settings opened'),
                            ),
                          );
                        },
                      ),

                      // Security Section
                      _buildSectionHeader('Security'),
                      _buildSettingItem(
                        icon: Icons.security_outlined,
                        title: 'Two-Factor Authentication',
                        subtitle: 'Add an extra layer of security',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('2FA settings opened'),
                            ),
                          );
                        },
                      ),
                      _buildSettingItem(
                        icon: Icons.fingerprint_outlined,
                        title: 'Biometric Login',
                        subtitle: 'Use fingerprint or face recognition',
                        isToggle: true,
                        toggleValue: biometric,
                        onToggleChanged: (value) =>
                            setState(() => biometric = value),
                      ),

                      // Support Section
                      _buildSectionHeader('Support'),
                      _buildSettingItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        subtitle: 'Get help and contact support',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Help center opened')),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HelpSupportPage(),
                            ),
                          );
                        },
                      ),

                      // Account Actions
                      _buildSectionHeader('Account Actions'),
                      _buildSettingItem(
                        icon: Icons.logout_outlined,
                        title: 'Logout',
                        subtitle: 'Sign out of your account',
                        onTap: _showLogoutDialog,
                        hasArrow: false,
                      ),
                      // _buildSettingItem(
                      //   icon: Icons.delete_outline,
                      //   title: 'Delete Account',
                      //   subtitle: 'Permanently delete your account',
                      //   onTap: _showDeleteAccountDialog,
                      //   isDangerous: true,
                      //   hasArrow: false,
                      // ),

                      // Footer
                      const SizedBox(height: 32),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'App Version 1.0.1',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '© 2025 उpasthiti',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
