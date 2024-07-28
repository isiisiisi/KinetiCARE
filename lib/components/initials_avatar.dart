import 'package:flutter/material.dart';

class InitialsAvatar extends StatelessWidget {
  final String firstName;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  const InitialsAvatar({super.key, 
    required this.firstName,
    this.radius = 30,
    this.backgroundColor = const Color(0xFF5A8DEE),
    this.textColor = Colors.white,
  });

  String getInitial(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        getInitial(firstName),
        style: TextStyle(
          color: textColor,
          fontSize: radius / 2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
