import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';

class PtExerprograms extends StatefulWidget {
  const PtExerprograms({super.key});

  @override
  State<PtExerprograms> createState() => _PtExerprogramsState();
}

class _PtExerprogramsState extends State<PtExerprograms> {
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
                  color: Color(0xFF00BFA6),
                  shape: BoxShape.circle
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            children: [
              const Center(
                child: Text('Exercise Programs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333)
                ),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Create and personalize exercise programs',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xFF707070)
              ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 322,
                height: 86,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9E9EB),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Image.asset(AppImages.add),
                    const SizedBox(width: 20),
                    const Text('Tap to add a plan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333)
                    ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
        ),
      )
    );
  }
}