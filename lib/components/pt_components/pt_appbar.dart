import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';

class PtAppbar extends StatelessWidget {
  const PtAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 5,
      shadowColor: const Color.fromARGB(255, 212, 212, 212),
      surfaceTintColor: Colors.white,
      scrolledUnderElevation: 10,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Image.asset(
              AppImages.appName,
              fit: BoxFit.contain,
              height: 175,
              width: 175,
            ),
          ),
          const SizedBox(width: 100),
          Image.asset(
            AppImages.bell,
            fit: BoxFit.contain,
            height: 35,
            color: const Color(0xFF00BFA6),
          ),
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
                color: Color(0xFF00BFA6), shape: BoxShape.circle),
          )
        ],
      ),
    );
  }
}
