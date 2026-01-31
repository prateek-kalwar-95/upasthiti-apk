// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:sih/auth/detailPage.dart';
// import 'package:sih/pages/home.dart';
// import 'package:sih/service/auth.dart';

// class SignUpPage extends StatefulWidget {
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isPasswordVisible = false;
//   bool _isReenterPasswordVisible = false;

//   // Text Controllers
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _universityRollController = TextEditingController();
//   TextEditingController _studentIdController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   TextEditingController _reenterPasswordController = TextEditingController();

//   // Dropdown values
//   String? _selectedDepartment;
//   String? _selectedSection;
//   String? _selectedSemester;
//   String? _selectedBatch;

//   // Dropdown options
//   final List<String> _departments = [
//     'Computer Science Engineering',
//     'Information Technology',
//     'Electronics and Communication Engineering',
//     'Electrical Engineering',
//     'Mechanical Engineering',
//     'Civil Engineering',
//     'Chemical Engineering',
//     'Biotechnology',
//     'Aerospace Engineering',
//     'Automobile Engineering',
//     'Data Science and Engineering',
//     'Artificial Intelligence and Machine Learning',
//   ];

//   final List<String> _sections = [
//     'Section A',
//     'Section B',
//     'Section C',
//     'Section D',
//     'Section E',
//   ];

//   final List<String> _semesters = [
//     '1st Semester',
//     '2nd Semester',
//     '3rd Semester',
//     '4th Semester',
//     '5th Semester',
//     '6th Semester',
//     '7th Semester',
//     '8th Semester',
//   ];

//   final List<String> _batches = [
//     '2025-2029',
//     '2024-2028',
//     '2023-2027',
//     '2022-2026',
//     '2021-2025',
//     '2020-2024',
//   ];

//   // Simple email validation using a regex pattern
//   bool _isValidEmail(String email) {
//     final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
//     return emailRegex.hasMatch(email);
//   }

//   void _handleContinue() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         print('Name: ${_nameController.text}');
//         print('Email: ${_emailController.text}');
//         print('University Roll: ${_universityRollController.text}');
//         print('Student ID: ${_studentIdController.text}');
//         print('Department: $_selectedDepartment');
//         print('Section: $_selectedSection');
//         print('Semester: $_selectedSemester');
//         print('Batch: $_selectedBatch');

//         // Create user account with email and password
//         UserCredential userCredential = await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text,
//         );

//         // Get the created user
//         User? user = userCredential.user;

//         if (user != null) {
//           String email = user.email ?? _emailController.text.trim();
//           String uid = user.uid;

//           // Store user data in Firestore with additional fields
//           await FirebaseFirestore.instance
//               .collection('Students')
//               .doc(email) // Using email as document ID
//               .set({
//             'name': _nameController.text.trim(),
//             'email': email,
//             'uid': uid,
//             'universityRollNo': _universityRollController.text.trim(),
//             'studentId': _studentIdController.text.trim(),
//             'department': _selectedDepartment,
//             'section': _selectedSection,
//             'semester': _selectedSemester,
//             'batch': _selectedBatch,
//             'isDetails': true, // Updated since we now have all details
//             'createdAt': FieldValue.serverTimestamp(),
//           });

//           // Show success message
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Account created successfully!'),
//               backgroundColor: Colors.green,
//             ),
//           );

//           // Navigate to UserDetailsPage or directly to home
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => UserDetailsPage(
//                 email: email,
//                 password: _passwordController.text,
//               ),
//             ),
//           );
//         }
//       } on FirebaseAuthException catch (e) {
//         // Handle Firebase Auth specific errors
//         String errorMessage = '';
//         switch (e.code) {
//           case 'weak-password':
//             errorMessage = 'The password provided is too weak.';
//             break;
//           case 'email-already-in-use':
//             errorMessage = 'The account already exists for that email.';
//             break;
//           case 'invalid-email':
//             errorMessage = 'The email address is not valid.';
//             break;
//           default:
//             errorMessage = 'An error occurred: ${e.message}';
//         }

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(errorMessage),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } catch (e) {
//         // Handle any other errors
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error creating account: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Widget _buildDropdown({
//     required String label,
//     required String? value,
//     required List<String> items,
//     required Function(String?) onChanged,
//     required String? Function(String?) validator,
//   }) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       decoration: InputDecoration(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           borderSide: BorderSide(color: Colors.blue, width: 2.0),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         labelText: label,
//         labelStyle: TextStyle(color: Colors.grey.shade600),
//         filled: true,
//         fillColor: Colors.grey.shade50,
//         contentPadding: EdgeInsets.symmetric(
//           horizontal: 16.0,
//           vertical: 16.0,
//         ),
//       ),
//       items: items.map((String item) {
//         return DropdownMenuItem<String>(
//           value: item,
//           child: Text(item),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       validator: validator,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           'Create Account',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.grey.shade800,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         physics: ClampingScrollPhysics(),
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Header Section
//               Container(
//                 margin: EdgeInsets.only(bottom: 30.0),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 70,
//                       height: 70,
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade100,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.person_add_rounded,
//                         size: 35,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       'Join उpasthiti',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey.shade800,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Fill in your details to get started',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Name TextField
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                     borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   labelText: 'Full Name',
//                   labelStyle: TextStyle(color: Colors.grey.shade600),
//                   hintText: 'Enter your full name',
//                   hintStyle: TextStyle(color: Colors.grey.shade400),
//                   filled: true,
//                   fillColor: Colors.grey.shade50,
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 16.0,
//                     vertical: 16.0,
//                   ),
//                   prefixIcon: Icon(
//                     Icons.person_outline,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//                 textCapitalization: TextCapitalization.words,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Name cannot be empty';
//                   }
//                   if (value.trim().length < 2) {
//                     return 'Name must be at least 2 characters';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),

//               // Email TextField
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                     borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   labelText: 'Email Address',
//                   labelStyle: TextStyle(color: Colors.grey.shade600),
//                   hintText: 'e.g., student@university.edu',
//                   hintStyle: TextStyle(color: Colors.grey.shade400),
//                   filled: true,
//                   fillColor: Colors.grey.shade50,
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 16.0,
//                     vertical: 16.0,
//                   ),
//                   prefixIcon: Icon(
//                     Icons.email_outlined,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Email cannot be empty';
//                   } else if (!_isValidEmail(value)) {
//                     return 'Please enter a valid email address';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),

//               // University Roll Number TextField
//               TextFormField(
//                 controller: _universityRollController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                     borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   labelText: 'University Roll Number',
//                   labelStyle: TextStyle(color: Colors.grey.shade600),
//                   hintText: 'e.g., 13000124018  ',
//                   hintStyle: TextStyle(color: Colors.grey.shade400),
//                   filled: true,
//                   fillColor: Colors.grey.shade50,
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 16.0,
//                     vertical: 16.0,
//                   ),
//                   prefixIcon: Icon(
//                     Icons.badge_outlined,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//                 textCapitalization: TextCapitalization.characters,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'University Roll Number cannot be empty';
//                   }
//                   if (value.length < 5) {
//                     return 'Please enter a valid roll number';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),

//               // Student ID TextField
//               TextFormField(
//                 controller: _studentIdController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                     borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   labelText: 'Student ID',
//                   labelStyle: TextStyle(color: Colors.grey.shade600),
//                   hintText: 'e.g., 13024001132',
//                   hintStyle: TextStyle(color: Colors.grey.shade400),
//                   filled: true,
//                   fillColor: Colors.grey.shade50,
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 16.0,
//                     vertical: 16.0,
//                   ),
//                   prefixIcon: Icon(
//                     Icons.credit_card_outlined,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//                 textCapitalization: TextCapitalization.characters,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Student ID cannot be empty';
//                   }
//                   if (value.length < 5) {
//                     return 'Please enter a valid Student ID';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),

//               // Department Dropdown
//               _buildDropdown(
//                 label: 'Department',
//                 value: _selectedDepartment,
//                 items: _departments,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedDepartment = value;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please select your department';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),

//               // Section Dropdown
//               _buildDropdown(
//                 label: 'Section',
//                 value: _selectedSection,
//                 items: _sections,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedSection = value;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please select your section';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),

//               // Semester Dropdown
//               _buildDropdown(
//                 label: 'Current Semester',
//                 value: _selectedSemester,
//                 items: _semesters,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedSemester = value;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please select your current semester';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),

//               // Batch Dropdown
//               _buildDropdown(
//                 label: 'Batch',
//                 value: _selectedBatch,
//                 items: _batches,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedBatch = value;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please select your batch';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),

//               // Password TextField
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                     borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   labelText: 'Password',
//                   labelStyle: TextStyle(color: Colors.grey.shade600),
//                   filled: true,
//                   fillColor: Colors.grey.shade50,
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 16.0,
//                     vertical: 16.0,
//                   ),
//                   prefixIcon: Icon(
//                     Icons.lock_outline,
//                     color: Colors.grey.shade600,
//                   ),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isPasswordVisible
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                       color: Colors.grey.shade600,
//                     ),
//                     splashRadius: 20.0,
//                     onPressed: () {
//                       setState(() {
//                         _isPasswordVisible = !_isPasswordVisible;
//                       });
//                     },
//                   ),
//                 ),
//                 obscureText: !_isPasswordVisible,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Password cannot be empty';
//                   }
//                   if (value.length < 6) {
//                     return 'Password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),

//               // Re-enter Password TextField
//               TextFormField(
//                 controller: _reenterPasswordController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                     borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   labelText: 'Confirm Password',
//                   labelStyle: TextStyle(color: Colors.grey.shade600),
//                   filled: true,
//                   fillColor: Colors.grey.shade50,
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 16.0,
//                     vertical: 16.0,
//                   ),
//                   prefixIcon: Icon(
//                     Icons.lock_outline,
//                     color: Colors.grey.shade600,
//                   ),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isReenterPasswordVisible
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                       color: Colors.grey.shade600,
//                     ),
//                     splashRadius: 20.0,
//                     onPressed: () {
//                       setState(() {
//                         _isReenterPasswordVisible =
//                             !_isReenterPasswordVisible;
//                       });
//                     },
//                   ),
//                 ),
//                 obscureText: !_isReenterPasswordVisible,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please confirm your password';
//                   } else if (value != _passwordController.text) {
//                     return 'Passwords do not match';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 24.0),

//               // Sign Up Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50.0,
//                 child: ElevatedButton(
//                   onPressed: _handleContinue,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     elevation: 2.0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     textStyle: TextStyle(
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   child: const Text('Create Account'),
//                 ),
//               ),
//               SizedBox(height: 16.0),

//               // Back to Login
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Already have an account? ',
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 14.0,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.blue,
//                       padding: EdgeInsets.symmetric(horizontal: 4.0),
//                     ),
//                     child: const Text(
//                       'Back to Login',
//                       style: TextStyle(fontWeight: FontWeight.w600),
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
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _universityRollController.dispose();
//     _studentIdController.dispose();
//     _passwordController.dispose();
//     _reenterPasswordController.dispose();
//     super.dispose();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sih/pages/home.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isReenterPasswordVisible = false;

  // Text Controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _universityRollController = TextEditingController();
  TextEditingController _studentIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _reenterPasswordController = TextEditingController();

  // Dropdown values
  String? _selectedDepartment;
  String? _selectedSection;
  String? _selectedSemester;
  String? _selectedBatch;

  // Dropdown options
  final List<String> _departments = [
    'Computer Science Engineering',
    'Information Technology',
    'Electronics and Communication Engineering',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Chemical Engineering',
    'Biotechnology',
    'Aerospace Engineering',
    'Automobile Engineering',
    'Data Science and Engineering',
    'Artificial Intelligence and Machine Learning',
  ];

  final List<String> _sections = [
    'A',
    'B',
    'C',
    'D',
    'E',
  ];

  final List<String> _semesters = [
    '1st Semester',
    '2nd Semester',
    '3rd Semester',
    '4th Semester',
    '5th Semester',
    '6th Semester',
    '7th Semester',
    '8th Semester',
  ];

  final List<String> _batches = [
    '2025-2029',
    '2024-2028',
    '2023-2027',
    '2022-2026',
    '2021-2025',
    '2020-2024',
  ];

  // Simple email validation using a regex pattern
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      try {
        print('Name: ${_nameController.text}');
        print('Email: ${_emailController.text}');
        print('University Roll: ${_universityRollController.text}');
        print('Student ID: ${_studentIdController.text}');
        print('Department: $_selectedDepartment');
        print('Section: $_selectedSection');
        print('Semester: $_selectedSemester');
        print('Batch: $_selectedBatch');

        // Create user account with email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );
        await userCredential.user?.updateDisplayName(
          _nameController.text.trim(),
        );
        await userCredential.user?.reload();
        // Get the created user
        User? user = userCredential.user;
        debugPrint('User created: ${user}');
        if (user != null) {
          String email = user.email ?? _emailController.text.trim();
          String uid = user.uid;

          // Store user data in Firestore with additional fields
          await FirebaseFirestore.instance
              .collection('users')
              .doc(
                user.uid,
              ) // Using university roll number as document ID
              .set({
                'name': _nameController.text.trim(),
                'email': email,
                'uid': uid,
                'universityRollNo': _universityRollController.text.trim(),
                'studentId': _studentIdController.text.trim(),
                'department': _selectedDepartment,
                'section': _selectedSection,
                'semester': _selectedSemester,
                'batch': _selectedBatch,
                'isDetails': true, // Updated since we now have all details
                'createdAt': FieldValue.serverTimestamp(),
              });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Account created successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to UserDetailsPage or directly to home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(title: 'Home')),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle Firebase Auth specific errors
        String errorMessage = '';
        switch (e.code) {
          case 'weak-password':
            errorMessage = 'The password provided is too weak.';
            break;
          case 'email-already-in-use':
            errorMessage = 'The account already exists for that email.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          default:
            errorMessage = 'An error occurred: ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      } catch (e) {
        // Handle any other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating account: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true, // This fixes the overflow issue
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            overflow: TextOverflow.ellipsis, // Prevents text overflow
            maxLines: 1, // Ensures single line display
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      // Custom dropdown style to ensure proper width
      style: TextStyle(color: Colors.grey.shade800, fontSize: 16.0),
      dropdownColor: Colors.white,
      menuMaxHeight: 200, // Limits dropdown height for better UX
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Container(
                margin: EdgeInsets.only(bottom: 30.0),
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_add_rounded,
                        size: 35,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Join उpasthiti',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Fill in your details to get started',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Name TextField
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  hintText: 'Enter your full name',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Colors.grey.shade600,
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Email TextField
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  labelText: 'Email Address',
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  hintText: 'e.g., student@university.edu',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.grey.shade600,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be empty';
                  } else if (!_isValidEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // University Roll Number TextField
              TextFormField(
                controller: _universityRollController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  labelText: 'University Roll Number',
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  hintText: 'e.g., 13000124018',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  prefixIcon: Icon(
                    Icons.badge_outlined,
                    color: Colors.grey.shade600,
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'University Roll Number cannot be empty';
                  }
                  if (value.length < 5) {
                    return 'Please enter a valid roll number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Student ID TextField
              TextFormField(
                controller: _studentIdController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  labelText: 'Student ID',
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  hintText: 'e.g., 13024001132',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  prefixIcon: Icon(
                    Icons.credit_card_outlined,
                    color: Colors.grey.shade600,
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Student ID cannot be empty';
                  }
                  if (value.length < 5) {
                    return 'Please enter a valid Student ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Department Dropdown
              _buildDropdown(
                label: 'Department',
                value: _selectedDepartment,
                items: _departments,
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your department';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Section Dropdown
              _buildDropdown(
                label: 'Section',
                value: _selectedSection,
                items: _sections,
                onChanged: (value) {
                  setState(() {
                    _selectedSection = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your section';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Semester Dropdown
              _buildDropdown(
                label: 'Current Semester',
                value: _selectedSemester,
                items: _semesters,
                onChanged: (value) {
                  setState(() {
                    _selectedSemester = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your current semester';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Batch Dropdown
              _buildDropdown(
                label: 'Batch',
                value: _selectedBatch,
                items: _batches,
                onChanged: (value) {
                  setState(() {
                    _selectedBatch = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your batch';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Password TextField
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.grey.shade600,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey.shade600,
                    ),
                    splashRadius: 20.0,
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Re-enter Password TextField
              TextFormField(
                controller: _reenterPasswordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.grey.shade600,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isReenterPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey.shade600,
                    ),
                    splashRadius: 20.0,
                    onPressed: () {
                      setState(() {
                        _isReenterPasswordVisible = !_isReenterPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isReenterPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    textStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Create Account'),
                ),
              ),
              SizedBox(height: 16.0),

              // Back to Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                    ),
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(fontWeight: FontWeight.w600),
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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _universityRollController.dispose();
    _studentIdController.dispose();
    _passwordController.dispose();
    _reenterPasswordController.dispose();
    super.dispose();
  }
}
