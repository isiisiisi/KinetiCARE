import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/components/patient_components/patient_navbar.dart';

class PaymentAndBilling extends StatelessWidget {
  const PaymentAndBilling({super.key});

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
                buttonText: 'Payment and Billing',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PatientNavBar()),
                  );
                },
                space: 30,
                color: const Color(0xFF707070),
              ),
              const SizedBox(height: 100),
              Container(
                padding: const EdgeInsets.all(20),
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
                    Image.asset(AppImages.rate),
                    const SizedBox(width: 15),
                    const Text(
                      'Pay',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
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
                    Image.asset(AppImages.rate),
                    const SizedBox(width: 15),
                    const Text(
                      'Bills',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
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
                    Image.asset(AppImages.helpCenter, color: Colors.white),
                    const SizedBox(width: 15),
                    const Text(
                      'Transactions',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
