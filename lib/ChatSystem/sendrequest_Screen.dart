// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:kineticare/User/user_chat.dart';
// import 'package:kineticare/components/bottom_navbar.dart';

// class RequestScreen extends StatefulWidget {
//   final String therapistId;

//   const RequestScreen({Key? key, required this.therapistId}) : super(key: key);

//   @override
//   _RequestScreenState createState() => _RequestScreenState();
// }

// class _RequestScreenState extends State<RequestScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   late String _chatId;
//   List<types.Message> _messages = [];

//   @override
//   void initState() {
//     super.initState();
//     _initChat();
//   }

//   Future<void> _initChat() async {
//     final user = _auth.currentUser;
//     if (user == null) return;


//     _chatId = _generateChatId(user.uid, widget.therapistId);

 
//     _firestore
//         .collection('chats')
//         .doc(_chatId)
//         .collection('messages')
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .listen((snapshot) {
//       setState(() {
//         _messages = snapshot.docs.map((doc) {
//           final data = doc.data();
//           return types.TextMessage(
//             id: doc.id,
//             author: types.User(id: data['authorId']),
//             text: data['text'],
//             createdAt: (data['createdAt'] as Timestamp).millisecondsSinceEpoch,
//           );
//         }).toList();
//       });
//     });
//   }

//   String _generateChatId(String userId, String therapistId) {
    
//     return userId.compareTo(therapistId) < 0 ? '$userId\_$therapistId' : '$therapistId\_$userId';
//   }

//   Future<void> _sendMessage(types.PartialText message) async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     final newMessage = types.TextMessage(
//       author: types.User(id: user.uid),
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: '',
//       text: message.text,
//     );

//     await _firestore.collection('chats').doc(_chatId).collection('messages').add({
//       'authorId': newMessage.author.id,
//       'createdAt': Timestamp.now(),
//       'text': newMessage.text,
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (context) => const BottomNavBar()),
//               );
//             },
//             child: const Text(
//               'Skip for Now',
//               style: TextStyle(color: Colors.blue),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.close, color: Colors.black),
//             onPressed: () {
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (context) => const BottomNavBar()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           LinearProgressIndicator(
//             value: 3 / 3, 
//             backgroundColor: Colors.grey[300],
//             valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
//           ),
//           Expanded(
//             child: Chat(
//               messages: _messages,
//               onSendPressed: _sendMessage,
//               user: types.User(id: _auth.currentUser!.uid),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }