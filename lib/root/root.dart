// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:sih/auth/loginPage.dart';
// import 'package:sih/pages/home.dart';

// enum AuthState{
//   notLoggedIn,
//   loggedIn,
// }

// class OurRoot extends StatefulWidget {
//   @override
//   _OurRootState createState() => _OurRootState();
// }

// class _OurRootState extends State<OurRoot> {
//   AuthState _authState=AuthState.notLoggedIn;
//   @override
//   void didChangeDependencies()async{
//     super.didChangeDependencies();
//     try {
//       var _firebaseUser=FirebaseAuth.instance.currentUser!;
//       var _uid=_firebaseUser.uid;
//       if(_uid.isNotEmpty){
//         setState(() {
//           _authState=AuthState.loggedIn;
//         });
//       }else{
//         setState(() {
//           _authState=AuthState.notLoggedIn;
//         });
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     Widget ?retVal;
//     switch (_authState) {
//       case AuthState.notLoggedIn:
//         retVal=LoginForm();
//         break;
//       case AuthState.loggedIn:
//         retVal=MyHomePage(title: 'Home',);
//         break;
//       default:
//     }
//     return retVal!;
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:sih/auth/loginPage.dart';
// import 'package:sih/pages/home.dart';

// class OurRoot extends StatefulWidget {
//   @override
//   _OurRootState createState() => _OurRootState();
// }

// class _OurRootState extends State<OurRoot> {
//   bool _isLoading = true;
//   User? _currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _checkAuthState();
//   }

//   void _checkAuthState() async {
//     // Listen to auth state changes
//     await FirebaseAuth.instance.currentUser?.reload();
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       setState(() {
//         _currentUser = user;
//         _isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Show loading screen while checking authentication
//     if (_isLoading) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     // If user is logged in, show home page, otherwise show login page
//     if (_currentUser != null) {
//       return MyHomePage(title: 'Home');
//     } else {
//       return LoginForm();
//     }
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sih/auth/loginPage.dart';
import 'package:sih/pages/home.dart';
import 'package:sih/root/path.dart';

class OurRoot extends StatefulWidget {
  @override
  _OurRootState createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
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

    if (user == null) {
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
    if (_currentUser != null ) {
      if (_currentUser!.displayName == null) {
        return UserSelectionPage();
      }
      return HomePage(title: 'Home');
    } else {
      return LoginForm();
    }
  }
}
