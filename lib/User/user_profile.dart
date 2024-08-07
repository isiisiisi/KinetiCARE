import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/initials_avatar.dart';
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
  String phone = '';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchNameAndEmail();
  }

  void fetchNameAndEmail() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          name = documentSnapshot.get('firstName') ?? '';
          email = documentSnapshot.get('email') ?? '';
          phone = documentSnapshot.get('phone') ?? ''; // Fetching phone number
        });
      } else {
        if (kDebugMode) {
          print('Document does not exist');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching name, email, and phone: $e');
      }
    }
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
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
              ),
              InitialsAvatar(firstName: name, radius: 20),
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
                InitialsAvatar(firstName: name, radius: 50),
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
                Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 25),
                profileOption(AppImages.pinfo, 'Personal Information'),
                const SizedBox(height: 20),
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
      ),
    );
  }

  Widget profileOption(String imagePath, String title, {bool isLogout = false}) {
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
