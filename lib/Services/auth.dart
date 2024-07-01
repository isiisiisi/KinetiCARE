import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        return "Please enter all the fields";
      }

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection("users").doc(credential.user!.uid).set({
        "name": name,
        "email": email,
        'uid': credential.user!.uid,
      });

      return "Success";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return "Please enter all the fields";
      }

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return "Success";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
