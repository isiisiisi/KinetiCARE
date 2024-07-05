import 'package:flutter/material.dart';
import '../account/role_based.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const MyButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.padding = const EdgeInsets.all(22),
    this.margin = const EdgeInsets.symmetric(horizontal: 40.0),
    // this.color = const const Color(0xFF333333)
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RoleBased()));
      },
      child: Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          //color
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
