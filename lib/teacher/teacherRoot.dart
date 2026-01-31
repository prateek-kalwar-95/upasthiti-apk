import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sih/root/path.dart';
import 'package:sih/teacher/teacherHome.dart';
import 'package:sih/teacher/teacherLogin.dart';

class TeacherOurRoot extends StatefulWidget {
  @override
  _TeacherOurRootState createState() => _TeacherOurRootState();
}

class _TeacherOurRootState extends State<TeacherOurRoot> {
  bool _isLoading = true;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Reload the current user
    await FirebaseAuth.instance.currentUser?.reload();

    // Get the updated user after reload
    User? user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;
    debugPrint('User after reload: $user');

    if (user == null && user?.displayName == null) {
      // User is logged out after reload
      setState(() {
        _currentUser = null;
        _isLoading = false;
      });
    } else {
      // Listen to auth state changes for future updates
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (!mounted) return;
        setState(() {
          _currentUser = user;
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    }

    // If user is logged in, show home page, otherwise show login page
    if (_currentUser != null) {
      if(_currentUser?.displayName == null){
        return TeacherHomePage();
      }
      return UserSelectionPage();
    } else {
      return TeacherLoginForm();
    }
  }
}