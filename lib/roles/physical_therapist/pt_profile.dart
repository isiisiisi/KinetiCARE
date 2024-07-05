import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/account/login_screen.dart';

class PtProfile extends StatefulWidget {
  const PtProfile({super.key});

  @override
  State<PtProfile> createState() => _PtProfileState();
}

class _PtProfileState extends State<PtProfile> {
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const LoginScreen()), // Replace with your login screen
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 5,
            shadowColor: const Color(0xFF333333),
            surfaceTintColor: Colors.white,
            scrolledUnderElevation: 12,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Image.asset(
                    AppImages.appName,
                    fit: BoxFit.contain,
                    height: 175,
                    width: 175,
                  ),
                ),
                const SizedBox(width: 100),
                Image.asset(
                  AppImages.bell,
                  fit: BoxFit.contain,
                  height: 35,
                  color: const Color(0xFF00BFA6),
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                      color: Color(0xFF00BFA6), shape: BoxShape.circle),
                )
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 109,
                    width: 190,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00BFA6),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF333333),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '09234567891',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // GestureDetector(
                  //     onTap: () {
                  //       Navigator.pushReplacement(
                  //           context, MaterialPageRoute(builder: (context)=>const PersonalInfo())
                  //         );
                  //     },
                  profileOption(AppImages.pinfo, 'Personal Information'),
                  const SizedBox(height: 20),
                  //  GestureDetector(
                  //     onTap: () {
                  //       Navigator.pushReplacement(
                  //           context, MaterialPageRoute(builder: (context)=>const MedicalInformation())
                  //         );
                  //     },
                  profileOption(AppImages.medicInfo, 'Medical Information'),
                  const SizedBox(height: 20),
                  profileOption(AppImages.ptInfo, 'Therapist Information'),
                  const SizedBox(height: 20),
                  profileOption(AppImages.billing, 'Payment and Billing'),
                  const SizedBox(height: 20),
                  profileOption(AppImages.settings, 'General Settings'),
                  const SizedBox(height: 20),
                  profileOption(AppImages.helpCenter, 'Help Center'),
                  const SizedBox(height: 20),
                  profileOption(AppImages.logout, 'Logout', isLogout: true),
                ],
              ),
            ),
          ),
        ));
  }

  Widget profileOption(String imagePath, String title,
      {bool isLogout = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(imagePath),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        isLogout
            ? IconButton(
                onPressed: signUserOut,
                icon: Image.asset(AppImages.forArrow),
              )
            : Image.asset(AppImages.forArrow),
      ],
    );
  }
}
