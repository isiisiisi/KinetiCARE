import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';

class MyBackButtonRow extends StatelessWidget {
  final String buttonText;
  final Function() onTap;
<<<<<<< Updated upstream
  final double space;
  final Color? color;
=======
  final Color? fillColor;
  final Color color;
>>>>>>> Stashed changes

  const MyBackButtonRow({
    super.key,
    required this.buttonText,
    required this.onTap,
<<<<<<< Updated upstream
    required this.space,
    this.color,
=======
    this.fillColor,
    this.color = const Color(0xFF333333),
>>>>>>> Stashed changes
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
<<<<<<< Updated upstream
          child: Image.asset(AppImages.backArrow,
          color: color),
=======
          child: Image.asset(
            AppImages.backArrow,
            color: color,
          ),
>>>>>>> Stashed changes
        ),
        SizedBox(width: space),
        Text(
          buttonText,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
