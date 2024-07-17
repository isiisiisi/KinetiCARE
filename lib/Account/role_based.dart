import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/account/login_screen.dart';
import 'package:kineticare/account/patient_register_screen.dart';
import 'package:kineticare/account/therapist_register_screen.dart';
import 'package:kineticare/components/my_backbutton.dart';

class RoleBased extends StatelessWidget {
  const RoleBased({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
            children: [
              MyBackButtonRow(
                buttonText: 'Choose your account',
                space: 40,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
              const SizedBox(height: 70),
              Column(children: [
                Container(
                    height: 245,
                    width: 320,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5A8DEE),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(AppImages.patient),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('PATIENT',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PatientRegisterScreen()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(145, 43),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    ),
                                    child: const Text('Register Now!',
                                        style: TextStyle(
                                            color: Color(0xFF5A8DEE),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 60),
                Container(
                    height: 245,
                    width: 320,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BFA6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(AppImages.ptChar),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('PHYSICAL\n THERAPIST',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TherapistRegisterScreen()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(145, 43),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                    child: const Text('Register Now!',
                                        style: TextStyle(
                                            color: Color(0xFF00BFA6),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))
              ])
            ],
                    ),
                  ),
          )),
    );
  }
}
