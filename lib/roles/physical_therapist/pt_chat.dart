import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kineticare/components/initials_avatar.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/roles/physical_therapist/chat_system/chat_screen.dart';

class PtChat extends StatefulWidget {
  const PtChat({super.key});

  @override
  State<PtChat> createState() => _PtChatState();
}

class _PtChatState extends State<PtChat> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!;
  }

  Future<Map<String, dynamic>> _fetchChatDetails(String chatId) async {
    if (chatId.isEmpty) {
      return {
        'lastMessage': 'No message',
        'lastMessageTime': DateTime.now(),
        'authorId': 'Unknown',
        'patientName': 'Unknown',
      };
    }

    try {
      final messagesCollection = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(1);

      final messageSnapshot = await messagesCollection.get();
      if (messageSnapshot.docs.isNotEmpty) {
        final messageData = messageSnapshot.docs.first.data();
        final authorId = messageData['authorId'] ?? 'Unknown';

        final firstMessageCollection = _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('createdAt', descending: false)
            .limit(1);

        final firstMessageSnapshot = await firstMessageCollection.get();
        if (firstMessageSnapshot.docs.isNotEmpty) {
          final firstMessageData = firstMessageSnapshot.docs.first.data();
          final firstAuthorId = firstMessageData['authorId'] ?? 'Unknown';

          final userSnapshot = await _firestore.collection('users').doc(firstAuthorId).get();
          final userData = userSnapshot.data();
          final patientName = userData?['firstName'] + ' ' + (userData?['lastName'] ?? '');

          return {
            'lastMessage': messageData['text'] ?? 'No message',
            'lastMessageTime': (messageData['createdAt'] as Timestamp).toDate(),
            'authorId': authorId,
            'patientName': patientName,
          };
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching chat details: $e');
      }
    }

    return {
      'lastMessage': 'No message',
      'lastMessageTime': DateTime.now(),
      'authorId': 'Unknown',
      'patientName': 'Unknown',
    };
  }

  String _generateChatId(String therapistId, String patientId) {
  return therapistId.compareTo(patientId) < 0
      ? '${therapistId}_$patientId'
      : '${patientId}_$therapistId';
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9EB),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: PatientAppbar(),
      ),
      body: SafeArea(
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
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chats')
                      .where('therapistId', isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No messages yet.'));
                    }

                    final chats = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chatId = chats[index].id;

                        return FutureBuilder<Map<String, dynamic>>(
                          future: _fetchChatDetails(chatId),
                          builder: (context, chatDetailsSnapshot) {
                            if (chatDetailsSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (!chatDetailsSnapshot.hasData) {
                              return const Center(
                                  child: Text('No messages yet.'));
                            }

                            final chatDetails = chatDetailsSnapshot.data!;
                            final lastMessage = chatDetails['lastMessage'] ?? 'No message';
                            final lastMessageTime = chatDetails['lastMessageTime'] as DateTime;
                            final patientName = chatDetails['patientName'] ?? 'Unknown';
                            final authorId = chatDetails['authorId'] ?? 'Unknown';
                            final formattedTime =
                                "${lastMessageTime.hour}:${lastMessageTime.minute.toString().padLeft(2, '0')}";

                            return Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
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
                                  firstName: patientName.split(' ').first,
                                ),
                                title: Text(patientName),
                                subtitle: Text(lastMessage),
                                trailing: Text(formattedTime),
                                onTap: () {
                                  if (authorId != 'Unknown') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          therapistId: user.uid,
                                          patientId: authorId,
                                          patientName: patientName,
                                          chatId: chatId,  // Pass the chatId here
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Error: Patient ID not found.'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
