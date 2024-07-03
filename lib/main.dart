import 'package:flutter/material.dart';
import 'package:kineticare/components/bottom_navbar.dart';
import 'package:kineticare/components/pt_components/bot_navbar.dart';
import 'package:kineticare/account/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //   apiKey: "AIzaSyBI2-FkgQ-JzGCg_nuO86bSzp6FoywLWiM",
      //   appId: "1:145067539971:android:80069b455ed9f8d5cc1836",
      //   messagingSenderId: "145067539971",
      //   projectId: "kineticare-7cf80",
      // ),
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading user data'));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.exists) {
                  var userData = snapshot.data!.data() as Map<String, dynamic>?;

                  if (userData != null && userData['role'] != null) {
                    if (userData['role'] == 'Therapist') {
                      return const BottomNavBarPt();
                    } else {
                      return const BottomNavBar();
                    }
                  } else {
                    return const Center(child: Text('User data is incomplete'));
                  }
                } else {
                  return const LoginScreen();
                }
              },
            );
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
