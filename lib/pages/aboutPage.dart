// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AboutPage extends StatelessWidget {
//   const AboutPage({Key? key}) : super(key: key);

//   // Creator data - Replace with actual creator information
//   final List<Map<String, String>> creators = const [
//     // {
//     //   'name': 'Prateek Kalwar',
//     //   'role': 'Mobile Developer',
//     //   'email': 'prateekkalwar2005@gmail.com',
//     //   'linkedin': 'https://www.linkedin.com/in/prateekkalwar',
//     //   'image': 'assets/images/prateek.jpg',
//     // },
//     {
//       'name': 'Shivam Sharma',
//       'role': 'Web Developer',
//       'email': 'shiva@upasthiti.com',
//       'linkedin': 'https://www.linkedin.com/in/shivam-sharma0906',
//       'image': 'assets/images/shivam.jpg',
//     },
//     // {
//     //   'name': 'Amit Singh',
//     //   'role': 'Backend Developer',
//     //   'email': 'amit@upasthiti.com',
//     //   'linkedin': 'https://www.linkedin.com/in/amitsingh',
//     //   'image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
//     // },
//   ];

//   Future<void> _launchLinkedIn(String url) async {
//   try {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(
//         uri,
//         mode: LaunchMode.externalNonBrowserApplication, // ✅ Forces LinkedIn app if installed
//       );
//     } else {
//       throw 'Could not launch LinkedIn profile';
//     }
//   } catch (e) {
//     debugPrint('Error launching LinkedIn: $e');
//   }
// }

// Future<void> _launchEmail(String email) async {
//   try {
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: email,
//       query: Uri.encodeFull('subject=Regarding Upasthiti App'),
//     );
//     if (await canLaunchUrl(emailUri)) {
//       await launchUrl(
//         emailUri,
//         mode: LaunchMode.externalApplication, // ✅ Opens in email app
//       );
//     } else {
//       throw 'Could not launch email client';
//     }
//   } catch (e) {
//     debugPrint('Error launching email: $e');
//   }
// }


//   Widget _buildCreatorCard(Map<String, String> creator) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Material(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         elevation: 3,
//         shadowColor: Colors.black12,
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               // Profile Image
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.blue.shade300, width: 3),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.blue.shade100,
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: CircleAvatar(
//                   radius: 40,
//                   backgroundImage: AssetImage(creator['image']!),
//                   backgroundColor: Colors.blue.shade100,
//                   child: creator['image']!.isEmpty
//                       ? Icon(Icons.person, size: 40, color: Colors.blue.shade600)
//                       : null,
//                 ),
//               ),
//               const SizedBox(height: 16),
              
//               // Name
//               Text(
//                 creator['name']!,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 4),
              
//               // Role
//               Text(
//                 creator['role']!,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.blue.shade600,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
              
//               // Action Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   // LinkedIn Button
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () => _launchLinkedIn(creator['linkedin']!),
//                       icon: const Icon(Icons.work_outline, size: 18),
//                       label: const Text('LinkedIn'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue.shade600,
//                         foregroundColor: Colors.white,
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
                  
//                   // Email Button
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () => _launchEmail(creator['email']!),
//                       icon: const Icon(Icons.email_outlined, size: 18),
//                       label: const Text('Email'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.blue.shade600,
//                         side: BorderSide(color: Colors.blue.shade600),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'About उपस्थिति',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.blue.shade600,
//         elevation: 4,
//         shadowColor: Colors.blue.shade200,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             if (Navigator.of(context).canPop()) {
//               Navigator.of(context).pop();
//             }
//           },
//         ),
//         automaticallyImplyLeading: true,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.blue.shade50,
//               Colors.indigo.shade100,
//             ],
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // App Logo and Name
//               Center(
//                 child: Column(
//                   children: [
//                     SvgPicture.asset(
//                       'assets/images/upasthiti_SVG.svg',
//                       width: 200,
//                       height: 200,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Smart Attendance Management',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.blue.shade600,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 32),
              
//               // About Section
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.info_outline, 
//                              color: Colors.blue.shade600, size: 24),
//                         const SizedBox(width: 8),
//                         const Text(
//                           'About उpasthiti',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'उpasthiti is a comprehensive attendance management system designed to streamline the process of tracking and managing attendance for educational institutions and organizations.',
//                       style: TextStyle(
//                         fontSize: 16,
//                         height: 1.6,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Features:',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ...const [
//                       '• Real-time attendance tracking',
//                       '• Automated report generation',
//                       '• Multi-platform support',
//                       '• Secure data management',
//                       '• Easy-to-use interface',
//                       '• Analytics and insights',
//                     ].map((feature) => Padding(
//                       padding: const EdgeInsets.only(bottom: 4),
//                       child: Text(
//                         feature,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade700,
//                           height: 1.5,
//                         ),
//                       ),
//                     )),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 24),
              
//               // Our Team Section
//               const Text(
//                 'Our Team',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Meet the talented people behind उपस्थिति',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               const SizedBox(height: 20),
              
//               // Creator Cards
//               ...creators.map((creator) => _buildCreatorCard(creator)),
              
//               const SizedBox(height: 32),
              
//               // App Info
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.blue.shade100),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Version',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         Text(
//                           '1.0.1',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.blue.shade600,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Built with',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.favorite, 
//                                  color: Colors.red.shade400, size: 18),
//                             const SizedBox(width: 4),
//                             Text(
//                               'Flutter',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.blue.shade600,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 24),
              
//               // Footer
//               Center(
//                 child: Text(
//                   '© 2025 उpasthiti Team. All rights reserved.',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey.shade600,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  // Creator data - Replace with actual creator information
  final List<Map<String, String>> creators = const [
    {
      'name': 'Prateek Kalwar',
      'role': 'Mobile Developer',
      'email': 'prateekkalwar2005@gmail.com',
      'linkedin': 'https://www.linkedin.com/in/prateekkalwar',
      'image': 'assets/images/prateek.jpg',
    },
    {
      'name': 'Shivam Sharma',
      'role': 'Web Developer',
      'email': 'shivam17sharma2004@gmail.com',
      'linkedin': 'https://www.linkedin.com/in/shivam-sharma0906',
      'image': 'assets/images/shivam.jpg',
    },
    {
      'name': 'Aditya Kumar Sah',
      'role': 'AI/ML Developer',
      'email': 'adityasah2030@gmail.com',
      'linkedin': 'https://www.linkedin.com/in/adityasah2030/',
      'image': 'assets/images/aditya.jpg',
    },
    {
      'name': 'Udita Baid',
      'role': 'Web Developer',
      'email': 'uditabaid9@gmail.com',
      'linkedin': 'https://www.linkedin.com/in/udita-baid-6b7258330/',
      'image': 'assets/images/udita.jpg',
    },
    {
      'name': 'Piyush Chhangani',
      'role': 'UI/UX Designer',
      'email': 'piyushc4527@gmail.com',
      'linkedin': 'https://www.linkedin.com/in/piyush-chhangani-106005331/',
      'image': 'assets/images/piyush.jpg',
    },
    {
      'name': 'Akash Jalui',
      'role': 'Backend Developer',
      'email': 'akashjalui05@gmail.com',
      'linkedin': 'https://www.linkedin.com/in/akash-jalui-7a265a243/',
      'image': 'assets/images/akash.jpg',
    },
  ];

  Future<void> _launchLinkedIn(String url, BuildContext context) async {
    try {
      final Uri uri = Uri.parse(url);
      
      // First try to open in LinkedIn app
      final Uri linkedinAppUri = Uri.parse('linkedin://profile/${_extractLinkedInUsername(url)}');
      
      if (await canLaunchUrl(linkedinAppUri)) {
        await launchUrl(linkedinAppUri);
      } else if (await canLaunchUrl(uri)) {
        // Fallback to browser
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showErrorSnackBar(context, 'Could not launch LinkedIn profile');
      }
    } catch (e) {
      debugPrint('Error launching LinkedIn: $e');
      _showErrorSnackBar(context, 'Error opening LinkedIn profile');
    }
  }

  String _extractLinkedInUsername(String url) {
    // Extract username from LinkedIn URL
    final RegExp regex = RegExp(r'linkedin\.com/in/([^/]+)');
    final Match? match = regex.firstMatch(url);
    return match?.group(1) ?? '';
  }

  Future<void> _launchEmail(String email, BuildContext context) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          'subject': 'Regarding Upasthiti App',
          'body': 'Hello,\n\nI would like to get in touch regarding the Upasthiti app.\n\nBest regards,',
        },
      );
      
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        _showErrorSnackBar(context, 'Could not launch email client');
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
      _showErrorSnackBar(context, 'Error opening email client');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildCreatorCard(Map<String, String> creator, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 3,
        shadowColor: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue.shade300, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: creator['image']!.isNotEmpty
                      ? Image.asset(
                          creator['image']!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.blue.shade100,
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.blue.shade600,
                              ),
                            );
                          },
                        )
                      : Container(
                          width: 80,
                          height: 80,
                          color: Colors.blue.shade100,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.blue.shade600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Name
              Text(
                creator['name']!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              
              // Role
              Text(
                creator['role']!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade600,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // LinkedIn Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _launchLinkedIn(creator['linkedin']!, context),
                      icon: const Icon(Icons.work_outline, size: 18),
                      label: const Text('LinkedIn'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Email Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _launchEmail(creator['email']!, context),
                      icon: const Icon(Icons.email_outlined, size: 18),
                      label: const Text('Email'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade600,
                        side: BorderSide(color: Colors.blue.shade600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About उपस्थिति',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade600,
        elevation: 4,
        shadowColor: Colors.blue.shade200,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.indigo.shade100,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Logo and Name
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade200,
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SvgPicture.asset(
                          'assets/images/upasthiti_SVG.svg',
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                          placeholderBuilder: (context) => Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade600, Colors.indigo.shade600],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.how_to_reg,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'उपस्थिति',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Smart Attendance Management',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // About Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, 
                             color: Colors.blue.shade600, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'About उpasthiti',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'उpasthiti is a comprehensive attendance management system designed to streamline the process of tracking and managing attendance for educational institutions and organizations.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Features:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...const [
                      '• Real-time attendance tracking',
                      '• Automated report generation',
                      '• Multi-platform support',
                      '• Secure data management',
                      '• Easy-to-use interface',
                      '• Analytics and insights',
                    ].map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Our Team Section
              const Text(
                'Our Team',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Meet the talented people behind उपस्थिति',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              
              // Creator Cards
              ...creators.map((creator) => _buildCreatorCard(creator, context)),
              
              const SizedBox(height: 32),
              
              // App Info
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Version',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '1.0.1',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Built with',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.favorite, 
                                 color: Colors.red.shade400, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              'Flutter',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Footer
              Center(
                child: Text(
                  '© 2025 उpasthiti Team. All rights reserved.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}