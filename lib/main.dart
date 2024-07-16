// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:kineticare/components/patient_components/patient_navbar.dart';
// import 'package:kineticare/components/pt_components/pt_navbar.dart';
// import 'package:kineticare/account/login_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData && snapshot.data != null) {
//             return FutureBuilder<DocumentSnapshot>(
//               future: FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(snapshot.data!.uid)
//                   .get(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return const Center(child: Text('Error loading user data'));
//                 } else if (snapshot.connectionState ==
//                     ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasData &&
//                     snapshot.data != null &&
//                     snapshot.data!.exists) {
//                   var userData = snapshot.data!.data() as Map<String, dynamic>?;

//                   if (userData != null && userData['accountType'] != null) {
//                     if (userData['accountType'] == 'therapist') {
//                       return const PtNavBar();
//                     } else if (userData['accountType'] == 'patient') {
//                       return const PatientNavBar();
//                     }
//                   } else {
//                     return const Center(child: Text('User data is incomplete'));
//                   }
//                 } else {
//                   return const LoginScreen();
//                 }

//                 return const SizedBox.shrink();
//               },
//             );
//           } else {
//             return const LoginScreen();
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:kineticare/components/patient_components/patient_navbar.dart';
import 'package:kineticare/components/pt_components/pt_navbar.dart';
import 'package:kineticare/account/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kineticare/account/splash_screen.dart';

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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}