import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';

class PatientAppbar extends StatelessWidget {
  const PatientAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 5,
          shadowColor: const Color(0xFF333333),
          surfaceTintColor: Colors.white,
          scrolledUnderElevation: 12,
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
              ),
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                    color: Color(0xFF5A8DEE), shape: BoxShape.circle),
              )
            ],
          ),
        ),
      ),
    );
  }
}
