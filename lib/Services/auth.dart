import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Error logging in user: $e'); 
      return false;
    }
  }

  Future<bool> registerUser({
    required String email,
    required String password,
    required String accountType,
    Map<String, dynamic>? additionalDetails,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'accountType': accountType,
          ...?additionalDetails,
        });
      }

      return true;
    } catch (e) {
      print('Error registering user: $e'); 
      return false;
    }
  }
}

