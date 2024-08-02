import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/pt_components/pt_appbar.dart';
import 'package:kineticare/components/pt_components/pt_navbar.dart';
import 'package:rxdart/rxdart.dart';

class TherapistNotifications extends StatefulWidget {
  const TherapistNotifications({super.key});

  @override
  _TherapistNotificationsState createState() => _TherapistNotificationsState();
}

class _TherapistNotificationsState extends State<TherapistNotifications> {
  Stream<List<QuerySnapshot>>? _requestsStream;
  late User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchRequests();
  }

  void fetchRequests() async {
    try {
      QuerySnapshot patientsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('accountType', isEqualTo: 'patient')
          .get();

      if (patientsSnapshot.docs.isNotEmpty) {
        List<Stream<QuerySnapshot>> requestStreams = [];

        for (var patient in patientsSnapshot.docs) {
          requestStreams.add(FirebaseFirestore.instance
              .collection('users')
              .doc(patient.id)
              .collection('patientRequests')
              .orderBy('timestamp', descending: true)
              .snapshots());
        }

        setState(() {
          _requestsStream = CombineLatestStream.list(requestStreams);
        });
      } else {
        if (kDebugMode) {
          print('No patient documents found.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching patient requests: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: PtAppbar(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
              child: MyBackButtonRow(
                buttonText: 'Notifications',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PtNavBar()),
                  );
                },
                space: 30,
              ),
            ),
            Expanded(
              child: _requestsStream == null
                  ? const Center(child: Text('No user is authenticated.'))
                  : StreamBuilder<List<QuerySnapshot>>(
                      stream: _requestsStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No notifications.'));
                        }

                        List<DocumentSnapshot> allDocs = [];
                        for (var snap in snapshot.data!) {
                          allDocs.addAll(snap.docs);
                        }

                        return ListView(
                          children: allDocs.map((DocumentSnapshot document) {
                            final data = document.data() as Map<String, dynamic>;
                            return ListTile(
                              title: Text(data['therapistName'] ?? 'No Name'),
                              subtitle: Text('Status: ${data['status']}'),
                              trailing: data['status'] == 'Pending'
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          await document.reference.update({'status': 'Accepted'});
                                        } catch (e) {
                                          if (kDebugMode) {
                                            print("Error updating status: $e");
                                          }
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Error updating status: $e'),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Accept'),
                                    )
                                  : const Text('Accepted'),
                            );
                          }).toList(),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
