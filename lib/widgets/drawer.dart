// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:sih/auth/loginPage.dart';
// import 'package:sih/pages/profilePage.dart';

// class CustomDrawer extends StatefulWidget {
//   const CustomDrawer({super.key});

//   @override
//   State<CustomDrawer> createState() => _CustomDrawerState();
// }

// class _CustomDrawerState extends State<CustomDrawer> {
//   User? currentUser = FirebaseAuth.instance.currentUser;

//   void _signOut() async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       // Clear any stored user information
//       currentUser = null;
//       Navigator.of(context).pop(); // Close the drawer
//       // Navigate back to login/welcome screen
//       //close the home page
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => LoginForm()),
//         (Route<dynamic> route) => false,
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error signing out: ${e.toString()}')),
//       );
//     }
//   }

//   void _showSignOutDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Sign Out'),
//           content: const Text('Are you sure you want to sign out?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _signOut();
//               },
//               child: const Text('Sign Out'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           // Profile Section
//           UserAccountsDrawerHeader(
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             accountName: Text(
//               currentUser?.displayName ?? 'User Name',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             accountEmail: Text(
//               currentUser?.email ?? 'user@example.com',
//               style: const TextStyle(fontSize: 14),
//             ),
//             currentAccountPicture: CircleAvatar(
//               backgroundColor: Colors.white,
//               backgroundImage: currentUser?.photoURL != null 
//                   ? NetworkImage(currentUser!.photoURL!) 
//                   : null,
//               child: currentUser?.photoURL == null
//                   ? Icon(
//                       Icons.person,
//                       size: 40,
//                       color: Theme.of(context).colorScheme.primary,
//                     )
//                   : null,
//             ),
//           ),
          
//           // Menu Items
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.person),
//                   title: const Text('Profile'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Navigate to profile page
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.settings),
//                   title: const Text('Settings'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Navigate to settings page
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.info),
//                   title: const Text('About'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Navigate to about page
//                   },
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.help),
//                   title: const Text('Help & Support'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Navigate to help page
//                   },
//                 ),
//               ],
//             ),
//           ),
          
//           // Sign Out Section at the bottom
//           const Divider(),
//           ListTile(
//             leading: const Icon(
//               Icons.logout,
//               color: Colors.red,
//             ),
//             title: const Text(
//               'Sign Out',
//               style: TextStyle(
//                 color: Colors.red,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             onTap: _showSignOutDialog,
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sih/pages/aboutPage.dart';
import 'package:sih/pages/helpSupport.dart';
import 'package:sih/pages/profilePage.dart';
import 'package:sih/pages/settingPage.dart';
import 'package:sih/root/splace.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Clear any stored user information
      currentUser = null;
      Navigator.of(context).pop(); // Close the drawer
      // Navigate back to login/welcome screen
      //close the home page
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: ${e.toString()}')),
      );
    }
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: Colors.red.shade600,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Sign Out',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey.shade50,
        child: Column(
          children: [
            // Profile Section with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade700,
                    Colors.blue.shade500,
                  ],
                ),
              ),
              child: UserAccountsDrawerHeader(
                onDetailsPressed: () {
                  Navigator.pop(context);
                  // Navigate to profile page
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                },
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                accountName: Text(
                  currentUser?.displayName ?? 'User Name',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  currentUser?.email ?? 'user@example.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                currentAccountPicture: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: currentUser?.photoURL != null 
                        ? NetworkImage(currentUser!.photoURL!) 
                        : null,
                    child: currentUser?.photoURL == null
                        ? Icon(
                            Icons.person_rounded,
                            size: 40,
                            color: Colors.blue.shade600,
                          )
                        : null,
                  ),
                ),
              ),
            ),
            
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Profile',
                    iconColor: Colors.blue.shade600,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to profile page
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    iconColor: Colors.blue.shade600,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to settings page
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: 'About',
                    iconColor: Colors.blue.shade600,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to about page
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    iconColor: Colors.blue.shade600,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to help page
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HelpSupportPage()));
                    },
                  ),
                ],
              ),
            ),
            
            // Sign Out Section at the bottom
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        color: Colors.red.shade600,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    onTap: _showSignOutDialog,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hoverColor: Colors.red.shade50,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey.shade400,
          size: 24,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hoverColor: Colors.blue.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }
}