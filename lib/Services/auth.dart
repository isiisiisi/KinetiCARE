import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to log in the user
  Future<bool> loginUser({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Method to register a user
  Future<bool> registerUser({
    required String email,
    required String password,
    required String accountType,
    Map<String, dynamic>? additionalDetails,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Store additional details in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'accountType': accountType,
          ...?additionalDetails, // Spread operator to add additional details if provided
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
