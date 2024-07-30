import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/initials_avatar.dart';


class PatientAppbar extends StatefulWidget {
  const PatientAppbar({super.key});

  @override
  State<PatientAppbar> createState() => _PatientAppbarState();
}

class _PatientAppbarState extends State<PatientAppbar> {
    late User user;
    late String firstName = '';
    
    @override
    void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchFirstName();
  }

    void fetchFirstName() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          firstName = documentSnapshot.get('firstName') ?? '';
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
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 5,
      shadowColor: const Color.fromARGB(255, 212, 212, 212),
      surfaceTintColor: Colors.white,
      scrolledUnderElevation: 10,
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
          InitialsAvatar(firstName: firstName, radius: 20)
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }
}
