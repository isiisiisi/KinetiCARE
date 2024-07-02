import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Image.asset(
                  AppImages.logoWOname,
                  fit: BoxFit.contain,
                  height: 75,
                  width: 75,
                ),
              ),
              Image.asset(
                AppImages.appName,
                fit: BoxFit.contain,
                height: 20,
              ),
              const SizedBox(width: 125),
              Image.asset(
                AppImages.bell,
                fit: BoxFit.contain,
                height: 35,
              ),
              const SizedBox(width: 10),
              Image.asset(
                AppImages.profile,
                fit: BoxFit.contain,
                height: 35,
              ),
            ],
          ),
        ),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('like'),
        ),
      ),
    );
  }
}
