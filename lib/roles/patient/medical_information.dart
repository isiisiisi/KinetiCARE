import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/bottom_navbar.dart';

class MedicalInformation extends StatefulWidget {
  const MedicalInformation({super.key});

  @override
  State<MedicalInformation> createState() => _MedicalInformationState();
}

class _MedicalInformationState extends State<MedicalInformation> {

String? selectedCertification;
  final List<String> certifications = [
    'Certification 1',
    'Certification 2',
    'Certification 3',
    'Certification 4'
  ];

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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomNavBar()));
                      },
                      child: Image.asset(AppImages.backArrow),
                    ),
                    const SizedBox(width: 50),
                    const Text(
                      'Medical Information',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF707070)),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                  Container(
                    height: 109,
                    width: 190,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEB3B),
                      shape: BoxShape.circle,
                    ),
                  ),
                   const SizedBox(height: 15),
                  const Text(
                    'Juan S. Dela Cruz',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'juanthept@gmail.com',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF333333),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                const SizedBox(height: 25),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Account Status',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)),
                    )),
                Container(
                  height: 60,
                  width: 395,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          style: BorderStyle.solid,
                          width: 1.5,
                          color: const Color(0xFFA0A0A0))),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Text(
                      '',
                      style:TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'PT Rating',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)),
                    )),
                Container(
                  height: 60,
                  width: 395,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          style: BorderStyle.solid,
                          width: 1.5,
                          color: const Color(0xFFA0A0A0))),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Text(
                      '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Request Status ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)),
                    )),
                Container(
                  height: 60,
                  width: 395,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          style: BorderStyle.solid,
                          width: 1.5,
                          color: const Color(0xFFA0A0A0))),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Text(
                      '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Qualifications',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333)
                ),
                ),
                const SizedBox(height: 35),
               Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      hint: const Text(
                        'Certification',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF333333),
                        ),
                      ),
                      value: selectedCertification,
                      items: certifications.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCertification = newValue!;
                        });
                      },
                    ),
                  ),
              ]
            )
          )
        )
      )
    );
  }
}