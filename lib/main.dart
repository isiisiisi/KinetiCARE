import 'package:flutter/material.dart';
import 'package:kineticare/User/userhome.dart';
import 'startup/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBI2-FkgQ-JzGCg_nuO86bSzp6FoywLWiM",
      appId: "1:145067539971:android:80069b455ed9f8d5cc1836",
      messagingSenderId: "145067539971",
      projectId: "kineticare-7cf80",
    ),
  );

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const UserHome();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
