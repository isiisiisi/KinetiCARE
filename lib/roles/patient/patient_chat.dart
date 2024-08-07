import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kineticare/ChatSystem/choosing_therapist.dart';
import 'package:kineticare/ChatSystem/sendrequest_screen.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/initials_avatar.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';

class PatientChat extends StatefulWidget {
  const PatientChat({super.key});

  @override
  State<PatientChat> createState() => _PatientChatState();
}

class _PatientChatState extends State<PatientChat> {
  final PageController _pageController = PageController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  String firstName = '';
  String? _selectedTherapistId;
  List<Map<String, dynamic>> therapists = [];

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!;
    fetchName();
    fetchTherapists();
  }

  Future<void> fetchName() async {
    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    if (snapshot.exists && snapshot.data() != null) {
      setState(() {
        firstName = snapshot.data()!['firstName'] ?? 'Unknown';
      });
    }
  }

  Future<void> fetchTherapists() async {
    final snapshot = await _firestore
        .collection('users')
        .where('accountType', isEqualTo: 'therapist')
        .get();
    setState(() {
      therapists = snapshot.docs
          .map((doc) => {
                'firstName': doc.data()['firstName'] ?? 'Unknown',
                'lastName': doc.data()['lastName'] ?? 'Unknown',
                'userId': doc.id, 
              })
          .toList();
    });
  }

  void _onTherapistSelected(String therapistId) {
    setState(() {
      _selectedTherapistId = therapistId;
    });
    _pageController.jumpToPage(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9EB),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: PatientAppbar(),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Chat with your personal physical therapist.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF707070),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 86,
                    width: 336,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Image.asset(AppImages.connect),
                          const SizedBox(width: 15),
                          const Text(
                            'Connect with a Therapist',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF707070),
                            ),
                          ),
                          const SizedBox(width: 45),
                          GestureDetector(
                            onTap: () {
                              _pageController.jumpToPage(1);
                            },
                            child: Image.asset(AppImages.forArrow),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: AcceptedRequestsStream(userUid: user.uid),
                  ),
                ],
              ),
            ),
          ),
          ChooseTherapistScreen(onTherapistSelected: _onTherapistSelected),
          if (_selectedTherapistId != null)
            RequestScreen(therapistId: _selectedTherapistId!),
        ],
      ),
    );
  }
}

class AcceptedRequestsStream extends StatelessWidget {
  final String userUid;

  const AcceptedRequestsStream({super.key, required this.userUid});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('users')
          .doc(userUid)
          .collection('patientRequests')
          .where('status', isEqualTo: 'Accepted')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          if (kDebugMode) {
            print("No accepted requests found");
          }
          return const Center(child: Text('No messages yet.'));
        }

        final patientRequests = snapshot.data!.docs;
        if (kDebugMode) {
          print("Accepted requests found: ${patientRequests.length}");
        }

        return ListView.builder(
          itemCount: patientRequests.length,
          itemBuilder: (context, index) {
            final request = patientRequests[index].data() as Map<String, dynamic>;
            final therapistName = request['therapistName'] ?? 'Unknown Therapist';
            final therapistId = request['therapistId'] ?? '';

            if (kDebugMode) {
              print('Therapist Name: $therapistName, Therapist ID: $therapistId');
            }

            return Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ListTile(
                leading: InitialsAvatar(
                  firstName: therapistName.split(' ').first,
                ),
                title: Text(therapistName),
                subtitle: const Text('You can now communicate with your therapist'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestScreen(
                        therapistId: therapistId,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
