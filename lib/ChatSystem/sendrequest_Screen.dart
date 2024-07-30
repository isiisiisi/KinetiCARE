import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';

class RequestScreen extends StatefulWidget {
  final String therapistId;

  const RequestScreen({super.key, required this.therapistId});

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _chatId;
  late String _therapistName = 'Unknown Therapist'; 
  List<types.Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchTherapistDetails();
  }

   Future<void> _fetchTherapistDetails() async {
    final therapistDoc =
        await _firestore.collection('users').doc(widget.therapistId).get();
    final therapistData = therapistDoc.data();

    if (therapistData != null) {
      setState(() {
        _therapistName =
            '${therapistData['firstName'] ?? 'Unknown'} ${therapistData['lastName'] ?? ''}';
      });
    }

    _initChat();
  }

  Future<void> _initChat() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _chatId = _generateChatId(user.uid, widget.therapistId);

    _firestore
        .collection('chats')
        .doc(_chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _messages = snapshot.docs.map((doc) {
          final data = doc.data();
          return types.TextMessage(
            id: doc.id,
            author: types.User(id: data['authorId']),
            text: data['text'],
            createdAt: (data['createdAt'] as Timestamp).millisecondsSinceEpoch,
          );
        }).toList();
      });
    });
  }

  String _generateChatId(String userId, String therapistId) {
    return userId.compareTo(therapistId) < 0
        ? '${userId}_$therapistId'
        : '${therapistId}_$userId';
  }

  Future<void> _sendMessage(types.PartialText message) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final newMessage = types.TextMessage(
      author: types.User(id: user.uid),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: '',
      text: message.text,
    );

    final messageData = {
      'authorId': newMessage.author.id,
      'createdAt': Timestamp.now(),
      'text': newMessage.text,
    };

    await _firestore
        .collection('chats')
        .doc(_chatId)
        .collection('messages')
        .add(messageData);

    await _firestore.collection('chats').doc(_chatId).set({
      'lastMessage': newMessage.text,
      'lastMessageTime': Timestamp.now(),
      'therapistId': widget.therapistId,
      'therapistName': _therapistName,
    }, SetOptions(merge: true));
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
              child: Chat(
                messages: _messages,
                onSendPressed: _sendMessage,
                user: types.User(id: _auth.currentUser!.uid),
                customBottomWidget: _buildCustomInput(),
                customMessageBuilder: _buildCustomMessage,
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
                _therapistName,
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

  Widget _buildCustomInput() {
  TextEditingController controller = TextEditingController();

  return Container(
      width: 560,
      height: 92,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child:Container(
    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
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
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF5A8DEE)),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    _sendMessage(types.PartialText(text: controller.text));
                    controller.clear(); 
                  }
                },
              ),
            ),
            onSubmitted: (text) {
              if (text.isNotEmpty) {
                _sendMessage(types.PartialText(text: text));
                controller.clear(); 
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}

 Widget _buildCustomMessage(types.Message message, {required int messageWidth}) {
    final bool isUserMessage = message.author.id == _auth.currentUser!.uid;

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isUserMessage ? const Color(0xFF5A8DEE) : const Color(0xFFE9E9EB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          (message as types.TextMessage).text,
          style: TextStyle(
            color: isUserMessage ? Colors.white : const Color(0xFF333333),
          ),
        ),
      ),
    );
  }
}
