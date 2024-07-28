import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/initials_avatar.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';

class ChatScreen extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String therapistId;
  final String chatId;  // Add chatId as a parameter

  const ChatScreen({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.therapistId,
    required this.chatId,  // Initialize chatId here
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final user = _auth.currentUser!;
    final message = {
      'authorId': user.uid,
      'createdAt': Timestamp.now(),
      'text': _messageController.text.trim(),
    };

    await _firestore
        .collection('chats')
        .doc(widget.chatId)  // Use chatId from widget
        .collection('messages')
        .add(message);

    await _firestore.collection('chats').doc(widget.chatId).update({
      'lastMessage': _messageController.text.trim(),
      'lastMessageTime': Timestamp.now(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: PatientAppbar(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .doc(widget.chatId)  // Use chatId from widget
                    .collection('messages')
                    .orderBy('createdAt', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    if (kDebugMode) {
                      print("No data found");
                    }
                    return const Center(child: Text('No messages yet.'));
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    if (kDebugMode) {
                      print("Docs are empty");
                    }
                    return const Center(child: Text('No messages yet.'));
                  }

                  final messages = snapshot.data!.docs;
                  if (kDebugMode) {
                    print("Number of messages: ${messages.length}");
                    for (var message in messages) {
                      print("Message: ${message.data()}");
                    }
                  }

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index].data() as Map<String, dynamic>;
                      if (kDebugMode) {
                        print("Message: $message");
                      }
                      final isMe = message['authorId'] == _auth.currentUser!.uid;
                      final authorName = isMe ? 'Kryz' : widget.patientName;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                DateFormat('HH:mm').format((message['createdAt'] as Timestamp).toDate()),
                                style: TextStyle(
                                  color: isMe ? const Color(0xFF333333) : Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isMe) InitialsAvatar(firstName: authorName.split(' ').first),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    constraints: BoxConstraints(
                                      minWidth: MediaQuery.of(context).size.width * 0.7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isMe ? const Color(0xFF00BFA6) : const Color(0xFFE9E9EB),
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(15),
                                        topRight: const Radius.circular(15),
                                        bottomLeft: isMe ? const Radius.circular(15) : const Radius.circular(0),
                                        bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(15),
                                      ),
                                    ),
                                    child: Text(
                                      message['text'],
                                      style: TextStyle(
                                        color: isMe ? Colors.white : const Color(0xFF333333),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.white,
                child: Row(
                  children: [
                    Image.asset(AppImages.mic),
                    const SizedBox(width: 8),
                    Image.asset(AppImages.image),
                    const SizedBox(width: 8),
                    Image.asset(AppImages.emoji),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send, color: Color(0xFF00BFA6)),
                            onPressed: _sendMessage,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE6E6E6), width: 2),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF707070)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.patientName,
                style: const TextStyle(color: Color(0xFF333333), fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Image.asset(AppImages.phone),
            const SizedBox(width: 15),
            Image.asset(AppImages.video),
            const SizedBox(width: 8),
          ],
        ),
        centerTitle: true,
      ),
    );
  }
}
