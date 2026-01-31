import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthServices extends ChangeNotifier {

  Future<bool> signIn(String email,String password)async{
    try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
   }
  }
  Future<bool> signUp(String email,String password)async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    }on FirebaseAuthException catch (e) {
      if(e.code=='weak-password'){
        print('The Password provided is too weak');
      }else if(e.code=='email-already-in-use'){
        print('The account already exists for that email.');
      }else if(e.code=='invalid-email'){
        print('invalid email address');
      }
      return false;
    }catch(e){
      print(e.toString());
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
  Future<bool> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.code}');
      if (e.code == 'user-not-found') {
        return false;
      }
      // For other errors, you might want to throw instead of returning false
      return false;
    }
  }

  Future<void> updateProfileName(String name) async {
    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    } catch (e) {
      print(e.toString());
    }
  }
}
