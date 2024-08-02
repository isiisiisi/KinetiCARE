import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/pt_components/pt_appbar.dart';
import 'package:kineticare/components/pt_components/pt_navbar.dart';

class PayoutEarnings extends StatelessWidget {
  const PayoutEarnings({super.key});

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
                buttonText: 'Payment and Earnings',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PtNavBar()),
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
                    const Text(
                      'Payouts',
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
                    const Text(
                      'Earnings',
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
