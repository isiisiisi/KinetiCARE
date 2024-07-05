import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';

class MyBackButtonRow extends StatelessWidget {
  final String buttonText;
  final Function() onTap;

  const MyBackButtonRow({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Image.asset(AppImages.backArrow),
        ),
        const SizedBox(width: 30.0),
        Text(
          buttonText,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }
}
