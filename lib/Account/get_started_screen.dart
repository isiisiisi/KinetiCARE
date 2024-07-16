import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';
import 'login_screen.dart';
import 'package:kineticare/components/my_button.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              AppImages.logoWname,
              width: 320,
            ),
            const SizedBox(height: 25),
            MyButton(
              buttonText: 'Get Started',
              padding: const EdgeInsets.all(22),
              margin: const EdgeInsets.symmetric(horizontal: 50.0),
              color: const Color(0xFF333333),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
