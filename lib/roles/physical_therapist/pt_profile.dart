import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/roles/patient/medical_information.dart';
import 'package:kineticare/roles/patient/personal_info.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/account/login_screen.dart';
import 'package:kineticare/components/pt_components/pt_appbar.dart';
import 'package:kineticare/roles/physical_therapist/pt_general_settings.dart';

class PtProfile extends StatefulWidget {
  const PtProfile({super.key});

  @override
  State<PtProfile> createState() => _PtProfileState();
}

class _PtProfileState extends State<PtProfile> {
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
                Container(
                  height: 109,
                  width: 190,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00BFA6),
                    shape: BoxShape.circle,
                  ),
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
                GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PersonalInfo()));
                    },
                    child:
                        profileOption(AppImages.pinfo, 'Personal Information')),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                profileOption(AppImages.ptInfo, 'Therapist Information'),
                const SizedBox(height: 10),
                profileOption(AppImages.billing, 'Payment and Billing'),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, 
                    MaterialPageRoute(builder: (context) => const PtGeneralSettings()));
                  },
                child: profileOption(AppImages.settings, 'General Settings')),
                const SizedBox(height: 10),
                profileOption(AppImages.helpCenter, 'Help Center'),
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
      {bool isLogout = false}) {
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
          isLogout
              ? IconButton(
                  onPressed: () {
                    signUserOut();
                  },
                  icon: Image.asset(AppImages.forArrow))
              : IconButton(
                  onPressed: () {}, icon: Image.asset(AppImages.forArrow)),
        ],
      ),
    );
  }
}

// class PtProfile extends StatefulWidget {
//   const PtProfile({super.key});

//   @override
//   State<PtProfile> createState() => _PtProfileState();
// }

// class _PtProfileState extends State<PtProfile> {
//   void signUserOut() async {
//     await FirebaseAuth.instance.signOut();
//     if (!mounted) return;
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//           builder: (context) =>
//               const LoginScreen()),
//       (Route<dynamic> route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(70),
//           child: AppBar(
//             backgroundColor: Colors.white,
//             elevation: 5,
//             shadowColor: const Color(0xFF333333),
//             surfaceTintColor: Colors.white,
//             scrolledUnderElevation: 12,
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10, left: 10),
//                   child: Image.asset(
//                     AppImages.appName,
//                     fit: BoxFit.contain,
//                     height: 175,
//                     width: 175,
//                   ),
//                 ),
//                 const SizedBox(width: 100),
//                 Image.asset(
//                   AppImages.bell,
//                   fit: BoxFit.contain,
//                   height: 35,
//                   color: const Color(0xFF00BFA6),
//                 ),
//                 Container(
//                   height: 40,
//                   width: 40,
//                   decoration: const BoxDecoration(
//                       color: Color(0xFF00BFA6), shape: BoxShape.circle),
//                 )
//               ],
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//               child: Column(
//                 children: [
//                   const Center(
//                     child: Text(
//                       'My Profile',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF333333),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   Container(
//                     height: 109,
//                     width: 190,
//                     decoration: const BoxDecoration(
//                       color: Color(0xFF00BFA6),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   const Text(
//                     '',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF333333),
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   const Text(
//                     '',
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.normal,
//                       color: Color(0xFF333333),
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   const Text(
//                     '09234567891',
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.normal,
//                       color: Color(0xFF333333),
//                     ),
//                   ),
//                   const SizedBox(height: 25),
//                   // GestureDetector(
//                   //     onTap: () {
//                   //       Navigator.pushReplacement(
//                   //           context, MaterialPageRoute(builder: (context)=>const PersonalInfo())
//                   //         );
//                   //     },
//                   profileOption(AppImages.pinfo, 'Personal Information'),
//                   const SizedBox(height: 20),
//                   //  GestureDetector(
//                   //     onTap: () {
//                   //       Navigator.pushReplacement(
//                   //           context, MaterialPageRoute(builder: (context)=>const MedicalInformation())
//                   //         );
//                   //     },
//                   profileOption(AppImages.medicInfo, 'Medical Information'),
//                   const SizedBox(height: 20),
//                   profileOption(AppImages.ptInfo, 'Therapist Information'),
//                   const SizedBox(height: 20),
//                   profileOption(AppImages.billing, 'Payment and Billing'),
//                   const SizedBox(height: 20),
//                   profileOption(AppImages.settings, 'General Settings'),
//                   const SizedBox(height: 20),
//                   profileOption(AppImages.helpCenter, 'Help Center'),
//                   const SizedBox(height: 20),
//                   profileOption(AppImages.logout, 'Logout', isLogout: true),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }

//   Widget profileOption(String imagePath, String title,
//       {bool isLogout = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Image.asset(imagePath),
//             const SizedBox(width: 10),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         isLogout
//             ? IconButton(
//                 onPressed: signUserOut,
//                 icon: Image.asset(AppImages.forArrow),
//               )
//             : Image.asset(AppImages.forArrow),
//       ],
//     );
//   }
// }
