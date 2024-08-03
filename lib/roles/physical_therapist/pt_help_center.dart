import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/pt_components/pt_appbar.dart';
import 'package:kineticare/components/pt_components/pt_navbar.dart';

class PtHelpCenter extends StatelessWidget {
  const PtHelpCenter({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: PtAppbar(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
          child: Column(
          children: [
            MyBackButtonRow(
              buttonText: 'Help Center',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                  builder: (context) => const PtNavBar()));
              },
              space: 60,
              color: const Color(0xFF707070),
            ),
            const SizedBox(height: 100),
            Container(
              padding: const EdgeInsets.all(20),
              width: 295,
              height: 87,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF00BFA6),
                boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0xFF333333),
                  blurRadius: 4.0,
                  offset: Offset(0.0, 0.55),
                ),
              ], 
              ),
              child: Row(
                children: [
                  Image.asset(AppImages.rate),
                  const SizedBox(width: 15),
                  const Text('Rate your Patient',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                  ),     
                ],
              ),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(20),
              width: 295,
              height: 87,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF00BFA6),
                boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0xFF333333),
                  blurRadius: 4.0,
                  offset: Offset(0.0, 0.55),
                ),
              ], 
              ),
              child: Row(
                children: [
                  Image.asset(AppImages.rate),
                  const SizedBox(width: 15),
                  const Text('Rate KinetiCare',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(20),
              width: 295,
              height: 87,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF00BFA6),
                boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0xFF333333),
                  blurRadius: 4.0,
                  offset: Offset(0.0, 0.55),
                ),
              ], 
              ),
              child: Row(
                children: [
                  Image.asset(AppImages.helpCenter, color: Colors.white),
                  const SizedBox(width: 15),
                  const Text('Chat Support',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                  ),
                ],
              ),
            )
          ],
         ),
        ),
      ),
    );
    //return const Placeholder();

  }
}