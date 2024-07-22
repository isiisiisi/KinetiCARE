import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';

class MyBackButtonRow extends StatelessWidget {
  final String buttonText;
  final Function() onTap;
  final double space;
  final Color? fillColor;
  final Color color;

  const MyBackButtonRow({
    super.key,
    required this.buttonText,
    required this.onTap,
    required this.space,
    this.fillColor,
    this.color = const Color(0xFF333333),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Image.asset(
              AppImages.backArrow,
              color: color,
            ),
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
      ),
    );
  }
}
