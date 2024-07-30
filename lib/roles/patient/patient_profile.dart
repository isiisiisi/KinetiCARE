import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/components/initials_avatar.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/roles/patient/medical_information.dart';
import 'package:kineticare/roles/patient/personal_info.dart';
import 'package:kineticare/roles/patient/therapist_info.dart';
import 'package:kineticare/roles/patient/payment_and_billing.dart';
import 'package:kineticare/roles/patient/general_settings.dart';
import 'package:kineticare/roles/patient/help_center.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/account/login_screen.dart';
//import 'package:kineticare/roles/patient/therapist_information.dart';
//import 'package:kineticare/roles/patient/therapist_information.dart';

class PatientProfile extends StatefulWidget {
  const PatientProfile({super.key});

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  late User users;
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    users = FirebaseAuth.instance.currentUser!;
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(users.uid)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          firstName = documentSnapshot.get('firstName') ?? '';
          lastName = documentSnapshot.get('lastName') ?? '';
          email = documentSnapshot.get('email') ?? '';
          phone = documentSnapshot.get('phone') ?? '';
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching user details: $e');
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
          preferredSize: Size.fromHeight(70), child: PatientAppbar()),
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
                InitialsAvatar(
                  firstName: firstName,
                  radius: 30,
                  backgroundColor: const Color(0xFF5A8DEE),
                  textColor: Colors.white,
                ),
                const SizedBox(height: 15),
                Text(
                  '$firstName $lastName',
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
                profileOption(AppImages.pinfo, 'Personal Information',
                    isPersonalInfo: true),
                const SizedBox(height: 10),
                profileOption(AppImages.medicInfo, 'Medical Information',
                    isMedInfo: true),
                const SizedBox(height: 10),
                profileOption(AppImages.ptInfo, 'Therapist Information',
                    isTherapistInfo: true),
                const SizedBox(height: 10),
                profileOption(AppImages.billing, 'Payment and Billing',
                    isPayAndBill: true),
                const SizedBox(height: 10),
                profileOption(AppImages.settings, 'General Settings',
                    isGenSettings: true),
                const SizedBox(height: 10),
                profileOption(AppImages.helpCenter, 'Help Center',
                    isHelpCenter: true),
                const SizedBox(height: 10),
                profileOption(AppImages.logout, 'Logout', isLogout: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileOption(String imagePath, String title,
      {bool isLogout = false,
      bool isPersonalInfo = false,
      bool isMedInfo = false,
      bool isTherapistInfo = false,
      bool isPayAndBill = false,
      bool isGenSettings = false,
      bool isHelpCenter = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
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
          Row(
            children: [
              if (isPersonalInfo)
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PersonalInfo()),
                    );
                  },
                  icon: Image.asset(AppImages.forArrow),
                ),
              if (isMedInfo)
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MedicalInformation()),
                    );
                  },
                  icon: Image.asset(AppImages.forArrow),
                ),
              if (isTherapistInfo)
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const TherapistInfo()), 
                    );
                  },
                  icon: Image.asset(AppImages.forArrow),
                ),
              if (isPayAndBill)
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const PaymentAndBilling()), 
                    );
                  },
                  icon: Image.asset(AppImages.forArrow),
                ),
              if (isGenSettings)
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const GeneralSettings()), 
                    );
                  },
                  icon: Image.asset(AppImages.forArrow),
                ),
              if (isHelpCenter)
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpCenter()),
                    );
                  },
                  icon: Image.asset(AppImages.forArrow),
                ),
              if (isLogout)
                IconButton(
                  onPressed: signUserOut,
                  icon: Image.asset(AppImages.forArrow),
                ),
              if (!isLogout &&
                  !isPersonalInfo &&
                  !isMedInfo &&
                  !isTherapistInfo &&
                  !isPayAndBill &&
                  !isGenSettings &&
                  !isHelpCenter)
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(AppImages.forArrow),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
