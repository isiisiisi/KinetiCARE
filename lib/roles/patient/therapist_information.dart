import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/ChatSystem/onboarding_referral.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/initials_avatar.dart';
import 'package:kineticare/components/my_button.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/components/patient_components/patient_navbar.dart';

class TherapistInformation extends StatefulWidget {
  final Map<String, dynamic> therapist;

  const TherapistInformation({super.key, required this.therapist});

  @override
  State<TherapistInformation> createState() => _TherapistInformationState();
}

class _TherapistInformationState extends State<TherapistInformation> {
  late String firstName;
  late String lastName;
  late String email;
  String? selectedCertification;
  String requestStatus = 'Send Request';
  final List<String> certifications = [
    'Certification 1',
    'Certification 2',
    'Certification 3',
    'Certification 4'
  ];

  @override
  void initState() {
    super.initState();
    firstName = widget.therapist['firstName'] ?? '';
    lastName = widget.therapist['lastName'] ?? '';
    email = widget.therapist['email'] ?? '';
    fetchRequestStatus();
  }

  Future<void> fetchRequestStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('patientRequests')
            .doc(widget.therapist['id'])
            .get();

        if (doc.exists) {
          setState(() {
            requestStatus = doc.data()?['status'] ?? 'Send Request';
          });
        } else {
          setState(() {
            requestStatus = 'Send Request';
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching request status: $e');
        }
      }
    }
  }

  Future<void> sendRequest(String fileUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final requestRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('patientRequests')
          .doc(widget.therapist['id']);

      try {
        await requestRef.set({
          'status': 'Pending',
          'therapistId': widget.therapist['id'],
          'therapistName':
              '${widget.therapist['firstName']} ${widget.therapist['lastName']}',
          'timestamp': FieldValue.serverTimestamp(),
          'fileUrl': fileUrl,
        });
        setState(() {
          requestStatus = 'Pending';
        });
        if (kDebugMode) {
          print('Request successfully sent');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error sending request: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print('User is not authenticated');
      }
    }
  }

  void handleButtonTap() {
    if (requestStatus == 'Send Request') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OnboardingScreens(
            onFileUploaded: (String? url) async {
              if (url != null) {
                await sendRequest(url);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.popUntil(
                      context, ModalRoute.withName('/TherapistInformation'));
                });
              }
            },
          ),
        ),
      );
    } else if (requestStatus == 'Pending') {
    } else if (requestStatus == 'Accepted') {
      setState(() {
        requestStatus = 'Change Physical Therapist';
      });
    }
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
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacement(context, 
                            MaterialPageRoute(builder: (context) => const PatientNavBar()));
                        }
                      },
                      child: Image.asset(AppImages.backArrow),
                    ),
                    const SizedBox(width: 50),
                    const Text(
                      'Therapist Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                InitialsAvatar(
                  firstName: widget.therapist['firstName'],
                  radius: 60,
                ),
                const SizedBox(height: 15),
                Text(
                  '${widget.therapist['firstName']} ${widget.therapist['lastName']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.therapist['email'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF333333),
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 25),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Account Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                Container(
                  height: 67,
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
                    children: [
                      const SizedBox(width: 25),
                      Image.asset(AppImages.status),
                      const SizedBox(width: 15),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'Verified License',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF00BFA6)),
                          ),
                          Text(
                            'Expiry: ',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF58595B)),
                          ),
                        ],
                      ),
                      const SizedBox(width: 80),
                      Image.asset(AppImages.verified)
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'PT Rating',
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
                  child: Row(
                    children: [
                      const SizedBox(width: 25),
                      Image.asset(AppImages.review),
                      const SizedBox(width: 15),
                      const Text(
                        'Rating:',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF58595B)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Request Status',
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Text(
                      requestStatus,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Qualifications',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    hint: const Text(
                      'Certification',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF333333),
                      ),
                    ),
                    value: selectedCertification,
                    items: certifications.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCertification = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 35),
                MyButton(
                  onTap: handleButtonTap,
                  buttonText: requestStatus,
                  color: const Color(0xFF5A8DEE),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.all(15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
