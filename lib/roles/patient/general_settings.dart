import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/components/patient_components/patient_navbar.dart';


class GeneralSettings extends StatelessWidget {
  const GeneralSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: PatientAppbar(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
          child: Column(
          children: [
            MyBackButtonRow(
              buttonText: 'General Settings',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                  builder: (context) => const PatientNavBar()));
              },
              space: 55,
            ),
            const SizedBox(height: 85),
            Container(
              width: 295,
              height: 87,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF5A8DEE),
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
                  Image.asset(AppImages.setInfo),
                  const SizedBox(width: 15),
                  const Text('Email and Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                  ),     
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: 295,
              height: 87,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF5A8DEE),
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
                  Image.asset(AppImages.notif),
                  const SizedBox(width: 15),
                  const Text('Notification Preferences',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: 295,
              height: 87,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF5A8DEE),
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
                  Image.asset(AppImages.privacy),
                  const SizedBox(width: 15),
                  const Text('Privacy Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: 295,
              height: 87,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF5A8DEE),
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
                  Image.asset(AppImages.trash),
                  const SizedBox(width: 15),
                  const Text('Delete Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                  ),
                ],
              ),
            ),
          ],
         ),
        ),
      ),
    );
    return const Placeholder();

  }
}