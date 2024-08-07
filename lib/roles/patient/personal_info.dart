import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/components/initials_avatar.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/roles/patient/edit_personal_info.dart';
import 'package:kineticare/roles/patient/emergency_contact.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/patient_components/patient_navbar.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  late User user;
  String firstName = '';
  String middleName = '';
  String lastName = '';
  String email = '';
  String gender = '';
  String phone = '';
  String birthDate = '';
  String birthMonth = '';
  String birthDay = '';
  String birthYear = '';


  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchName();
  }

  void fetchName() async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (documentSnapshot.exists) {
      setState(() {
        firstName = documentSnapshot.get('firstName') ?? '';
        email = documentSnapshot.get('email') ?? '';
        gender = documentSnapshot.get('gender') ?? '';
        phone = documentSnapshot.get('phone') ?? '';
        lastName = documentSnapshot.get('lastName') ?? '';
        middleName = documentSnapshot.get('middleName') ?? '';
        birthDate = documentSnapshot.get('birthDate') ?? '';

        if (birthDate.isNotEmpty) {
          List<String> dateParts = birthDate.split('/');
          if (dateParts.length == 3) {
            birthMonth = dateParts[0];
            birthDay = dateParts[1];
            birthYear = dateParts[2];
          }
        }
      });
    } else {
      if (kDebugMode) {
        print('Document does not exist');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching data: $e');
    }
  }
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
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PatientNavBar(),
                          ),
                        );
                      },
                      child: Image.asset(AppImages.backArrow),
                    ),
                    const SizedBox(width: 50),
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                InitialsAvatar(
                  firstName: firstName,
                  radius: 50,
                  backgroundColor: const Color(0xFF5A8DEE),
                  textColor: Colors.white,
                ),

                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 395,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 1.5,
                      color: const Color(0xFFA0A0A0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Text(
                      '$firstName $middleName $lastName',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sex',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 395,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 1.5,
                      color: const Color(0xFFA0A0A0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Text(
                      gender,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 395,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 1.5,
                      color: const Color(0xFFA0A0A0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Text(
                      phone,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: 395,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 1.5,
                      color: const Color(0xFFA0A0A0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Text(
                      email,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Birthdate',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                Container(
                  height: 97,
                  width: 395,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 1.5,
                      color: const Color(0xFFA0A0A0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'Month',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Container(
                            width: 70,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFA0A0A0),
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              birthMonth,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 25),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'Day',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Container(
                            width: 70,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFA0A0A0),
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              birthDay,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 25),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'Year',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Container(
                            width: 82,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFA0A0A0),
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              birthYear,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmergencyContact(),
                      ),
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5A8DEE),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0xFF333333),
                          blurRadius: 4.0,
                          offset: Offset(0.0, 0.55),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        'View Emergency Contact',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditPersonalInfo(),
                      ),
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 2,
                        color: const Color(0xFF5A8DEE),
                      ),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0xFF333333),
                          blurRadius: 4.0,
                          offset: Offset(0.0, 0.55),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        'Edit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5A8DEE),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
