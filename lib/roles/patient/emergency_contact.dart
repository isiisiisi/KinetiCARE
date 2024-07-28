import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/components/initials_avatar.dart';
import 'package:kineticare/roles/patient/edit_emergency_contact.dart';
import 'package:kineticare/roles/patient/personal_info.dart';
import 'package:kineticare/components/app_images.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({super.key});

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}
class _EmergencyContactState extends State<EmergencyContact> {
  late User user;
  String firstName = '';
  String contactFirstName = '', contactLastName = '', contactMiddleName = '';
  String contactPhone = '';
  String relationship = '';

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
          contactFirstName = documentSnapshot.get('contactFirstName') ?? '';
          contactLastName = documentSnapshot.get('contactLastName') ?? '';
          contactMiddleName = documentSnapshot.get('contactMiddleName') ?? '';
          contactPhone = documentSnapshot.get('contactPhone') ?? '';
          relationship = documentSnapshot.get('relationship') ?? '';
        });
      } else {
        if (kDebugMode) {
          print('Document does not exist');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching first name: $e');
      }
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
                InitialsAvatar(firstName: firstName, radius: 20),
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
                                builder: (context) => const PersonalInfo()));
                      },
                      child: Image.asset(AppImages.backArrow),
                    ),
                    const SizedBox(width: 50),
                    const Text(
                      'Emergency Contact',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF707070)),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                 InitialsAvatar(
                  firstName: contactFirstName,
                  radius: 30,
                  backgroundColor: Colors.blue,
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

                      '$contactFirstName $contactLastName $contactMiddleName',

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
                      'Relationship',
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
                      relationship,
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
                      'Contact Number',
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
                      contactPhone,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 55),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditEmergencyContact()));
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
