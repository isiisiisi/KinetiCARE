import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  String name = '';
  String email = '';

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
          name = documentSnapshot.get('name') ?? '';
          email = documentSnapshot.get('email') ?? '';
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching first name: $e');
    }
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
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                      color: Color(0xFF5A8DEE), shape: BoxShape.circle),
                )
              ],
            ),
          ),
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
                                builder: (context) => const BottomNavBar()));
                      },
                      child: Image.asset(AppImages.backArrow),
                    ),
                    const SizedBox(width: 50),
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF707070)),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  height: 107.14,
                  width: 109,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFF5A8DEE)),
                ),
                const SizedBox(height: 30),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Full Name',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)),
                    )),
                Container(
                  height: 60,
                  width: 395,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          style: BorderStyle.solid,
                          width: 1.5,
                          color: const Color(0xFFA0A0A0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Text(
                      name,
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
                          color: Color(0xFF333333)),
                    )),
                Container(
                  height: 60,
                  width: 395,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          style: BorderStyle.solid,
                          width: 1.5,
                          color: const Color(0xFFA0A0A0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Text(
                      name,
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
                          color: Color(0xFF333333)),
                    )),
                Container(
                  height: 60,
                  width: 395,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          style: BorderStyle.solid,
                          width: 1.5,
                          color: const Color(0xFFA0A0A0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Text(
                      name,
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
                          color: Color(0xFF333333)),
                    )),
                Container(
                  height: 60,
                  width: 395,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          style: BorderStyle.solid,
                          width: 1.5,
                          color: const Color(0xFFA0A0A0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
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
                          color: Color(0xFF333333)),
                    )),
                Container(
                  height: 97,
                  width: 395,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          style: BorderStyle.solid,
                          width: 1.5,
                          color: const Color(0xFFA0A0A0))),
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0xFFA0A0A0),
                                    style: BorderStyle.solid,
                                    width: 1.0)),
                          )
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0xFFA0A0A0),
                                    style: BorderStyle.solid,
                                    width: 1.0)),
                          )
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0xFFA0A0A0),
                                    style: BorderStyle.solid,
                                    width: 1.0)),
                          )
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
                            builder: (context) => const EmergencyContact()));
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
                              offset: Offset(0.0, 0.55))
                        ]),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        'View Emergency Contact',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
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
                            builder: (context) => const EditPersonalInfo()));
                  },
                  child: Container(
                    width: 300,
                    height: 54,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            width: 2, color: const Color(0xFF5A8DEE)),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Color(0xFF333333),
                              blurRadius: 4.0,
                              offset: Offset(0.0, 0.55))
                        ]),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        'Edit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5A8DEE)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
