import 'package:flutter/material.dart';
import 'package:kineticare/account/registration.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/account/login_screen.dart';

class RoleBased extends StatelessWidget {
  const RoleBased({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                     Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
                  },
                child: Image.asset(AppImages.backArrow),
                ),
                const SizedBox(width: 30.0),
                const Text(
                  'Choose your account',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333)),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Column(children: [
              Container(
                  height: 245,
                  width: 305,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5A8DEE),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(AppImages.patient),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                              const RegistrationForm(
                                                  role: 'Patient')),
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
              const SizedBox(height: 40),
              Container(
                  height: 245,
                  width: 303,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BFA6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(AppImages.ptChar),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                              const RegistrationForm(
                                                  role: 'Therapist')),
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
      )),
    );
  }
}
