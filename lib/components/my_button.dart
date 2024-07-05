import 'package:flutter/material.dart';
import '../account/role_based.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  const MyButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.padding,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RoleBased()));
      },
      child: Container(
        padding: padding ?? const EdgeInsets.all(8.0), // Default padding if not provided
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 40.0), // Default margin if not provided
        decoration: BoxDecoration(
          color: color ?? const Color(0xFF333333), // Default color if not provided
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}



 // this.padding = const EdgeInsets.all(22),
    // this.margin = const EdgeInsets.symmetric(horizontal: 40.0),
    // this.color = const Color(0xFF333333),