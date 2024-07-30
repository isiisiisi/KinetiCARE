import 'package:flutter/material.dart';
import '../account/role_based.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BoxShadow? boxShadow;

  const MyButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.padding,
    this.margin,
    this.color,
    this.boxShadow
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RoleBased()));
      },
      child: Container(
        padding: padding ?? const EdgeInsets.all(8.0), 
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 40.0), 
        decoration: BoxDecoration(
          color: color ?? const Color(0xFF333333), 
          borderRadius: BorderRadius.circular(20),
          boxShadow:  <BoxShadow>[
                boxShadow ?? const BoxShadow(
                  color: Color(0xFF333333),
                  blurRadius: 4.0,
                  offset: Offset(0.0, 0.55),
                ),
              ], 
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