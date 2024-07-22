import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/account/get_started_screen.dart';
import 'package:kineticare/components/patient_components/patient_navbar.dart';
import 'package:kineticare/components/pt_components/pt_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kineticare/account/login_screen.dart';
import 'package:kineticare/components/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const GetStarted(),
          ),
        );
      } else {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          if (userData['accountType'] == 'therapist') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PtNavBar(),
              ),
            );
          } else if (userData['accountType'] == 'patient') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PatientNavBar(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.logoWOname,
              width: 270,
            ),
          ],
        ),
      ),
    );
  }
}
