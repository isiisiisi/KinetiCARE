import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/roles/patient/medical_information.dart';
import 'package:kineticare/roles/patient/personal_info.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/account/login_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late User user;
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchNameandEmail();
  }

  void fetchNameandEmail() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          name = documentSnapshot.get('name') ?? '';
          email = documentSnapshot.get('email') ?? '';
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching name and email: $e');
    }
  }

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: PatientAppbar(),
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
                      color: Color(0xFF5A8DEE),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    style: const TextStyle(
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
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PersonalInfo()));
                      },
                      child: profileOption(
                          AppImages.pinfo, 'Personal Information')),
                  const SizedBox(height: 20),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MedicalInformation()));
                      },
                      child: profileOption(
                          AppImages.medicInfo, 'Medical Information')),
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
