import 'package:flutter/material.dart';
import 'startup/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
