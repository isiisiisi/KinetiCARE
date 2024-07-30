import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/components/patient_components/patient_navbar.dart';
import 'package:kineticare/roles/patient/edit_description.dart';
import 'package:kineticare/roles/patient/view_referral.dart';

class MedicalInformation extends StatefulWidget {
  const MedicalInformation({super.key});

  @override
  State<MedicalInformation> createState() => _MedicalInformationState();
}

class _MedicalInformationState extends State<MedicalInformation> {
  late User user;
  String briefDescription = '';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchBriefDescription();
  }

  void fetchBriefDescription() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (documentSnapshot.exists) {
      setState(() {
        briefDescription = documentSnapshot.get('briefDescription') ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: PatientAppbar(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyBackButtonRow(
                buttonText: 'Medical Information',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PatientNavBar(),
                    ),
                  );
                },
                space: 30,
                color: const Color(0xFF707070),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Physical Health Concern',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Brief Description',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 395,
                height: 271,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFFA0A0A0),
                    width: 1.5,
                    strokeAlign: BorderSide.strokeAlignInside,
                    style: BorderStyle.solid,
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    briefDescription,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
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
                      builder: (context) => const EditDescription(),
                    ),
                  );
                },
                child: Center(
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
              ),
              const SizedBox(height: 35),
              const Center(
                child: Text(
                  'Pt Referral Letter',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  const SizedBox(width: 15),
                  Image.asset(AppImages.file),
                  const SizedBox(width: 35),
                  const Text(
                    'View Referral Letter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(width: 95),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewReferral(),
                        ),
                      );
                    },
                    child: Image.asset(AppImages.forArrow)
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
