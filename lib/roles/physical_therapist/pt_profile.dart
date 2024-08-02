import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/components/initials_avatar.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/account/login_screen.dart';
import 'package:kineticare/components/pt_components/pt_appbar.dart';
import 'package:kineticare/roles/physical_therapist/educational_info.dart';
import 'package:kineticare/roles/physical_therapist/payout_earnings.dart';
import 'package:kineticare/roles/physical_therapist/professional_information.dart';
import 'package:kineticare/roles/physical_therapist/pt_general_settings.dart';
import 'package:kineticare/roles/physical_therapist/pt_help_center.dart';
import 'package:kineticare/roles/physical_therapist/therapist_info.dart';

class PtProfile extends StatefulWidget {
  const PtProfile({super.key});

  @override
  State<PtProfile> createState() => _PtProfileState();
}

class _PtProfileState extends State<PtProfile> {
  late User user;
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  Map<String, dynamic>? acceptedTherapist;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          firstName = documentSnapshot.get('firstName') ?? '';
          lastName = documentSnapshot.get('lastName') ?? '';
          email = documentSnapshot.get('email') ?? '';
          phone = documentSnapshot.get('phone') ?? '';
        });
      } else {
        if (kDebugMode) {
          print('Document does not exist');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user details: $e');
      }
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
          preferredSize: Size.fromHeight(70), child: PtAppbar()),
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
                  radius: 50,
                  backgroundColor: const Color(0xFF00BFA6),
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
                profileOption(AppImages.medicInfo, 'Professional Information',
                    isProfessionalInfo: true),
                const SizedBox(height: 10),
                profileOption(AppImages.ptInfo, 'Educational Information',
                    isEducationalInfo: true),
                const SizedBox(height: 10),
                profileOption(AppImages.billing, 'Payout and Earnings',
                    isPayAndEarn: true),
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
      bool isProfessionalInfo = false,
      bool isEducationalInfo = false,
      bool isPayAndEarn = false,
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
                          builder: (context) => const TherapistInfo()),
                    );
                  },
                  icon: Image.asset(AppImages.forArrow),
                ),
              if (isProfessionalInfo)
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ProfessionalInformation()), 
                    );
                  },
                  icon: Image.asset(AppImages.forArrow),
                ),
              if (isEducationalInfo)
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EducationalInfo(),
                      ),
                    );
                  },
                  icon: Image.asset(AppImages.forArrow),
                ),
              if (isPayAndEarn)
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const PayoutEarnings()), 
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
                              const PtGeneralSettings()), 
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
                          builder: (context) =>
                              const PtHelpCenter()), 
                    );
                  },
                  icon: Image.asset(AppImages.forArrow),
                ),
              if (isLogout)
                IconButton(
                  onPressed: signUserOut,
                  icon: Image.asset(AppImages.forArrow),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
