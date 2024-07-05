import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kineticare/components/app_images.dart';

class PtHome extends StatelessWidget {
  PtHome({super.key});

final String formattedDate =
    DateFormat('MMMM dd, yyyy').format(DateTime.now());

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
        ),
      ),
      body: SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text('Hello, Juan!',
                          style: TextStyle(
                              fontSize: 24, 
                              fontWeight: FontWeight.bold)),
                      Text('Today is $formattedDate',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA0A0A0)
                      )),
                    ],
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFF00BFA6)),
                  )
                ],
              ),
              const SizedBox(height: 55),
              const Text('Nubmer of active patients: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333)
              ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 71,
                width: 399,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF00BFA6),
                  boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0xFF333333),
                    blurRadius: 4.0,
                    offset: Offset(0.0, 0.55))
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Image.asset(AppImages.patientList),
                      const SizedBox(width: 20),
                      const Text('Pateint List',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                      ),
                      const SizedBox(width: 150),
                      Image.asset(AppImages.forArrow,
                      color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Nubmer of pending request: ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333)
              ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 71,
                width: 399,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF00BFA6),
                  boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0xFF333333),
                    blurRadius: 4.0,
                    offset: Offset(0.0, 0.55))
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Image.asset(AppImages.pending),
                      const SizedBox(width: 20),
                      const Text('Pending Request',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                      ),
                      const SizedBox(width: 110),
                      Image.asset(AppImages.forArrow,
                      color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              const Text('Upcoming Appointments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333)
              ),
              )
            ]
         ),
        ),
      ),
      )
    );
  }
}
