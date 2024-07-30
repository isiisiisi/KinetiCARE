import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late CollectionReference _chatCollection;

  ChatService(String therapistId) {
    _chatCollection = _firestore.collection('chats').doc(therapistId).collection('messages');
  }

  Future<void> sendMessage(String content, String type) async {
    await _chatCollection.add({
      'content': content,
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final storageRef = _storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await sendMessage(downloadUrl, 'image');
    }
  }

  Future<void> sendVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final storageRef = _storage.ref().child('videos/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await sendMessage(downloadUrl, 'video');
    }
  }

  Future<void> sendFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = File(result.files.single.path!);
      final storageRef = _storage.ref().child('files/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await sendMessage(downloadUrl, 'file');
    }
  }
}