import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/roles/patient/change_referral.dart';
import 'package:kineticare/roles/patient/medical_information.dart';

class ViewReferral extends StatefulWidget {
  const ViewReferral({super.key});

  @override
  State<ViewReferral> createState() => _ViewReferralState();
}

class _ViewReferralState extends State<ViewReferral> {
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
                buttonText: 'Medical Information',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MedicalInformation()),
                  );
                },
                space: 25,
                color: const Color(0xFF707070),
            ),
            const SizedBox(height: 35),
            const Center(
              child: Text(
                'PT Referral Letter',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333)),
              ),
            ),
            const SizedBox(height: 35),
            Container(
              width: 325,
              height: 79,
              decoration: BoxDecoration(
                  color: const Color(0xFF5A8DEE),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(AppImages.downloadFile),
                    Image.asset(AppImages.deleteFile),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangeReferral()),
                        );
                      },
                      child: Image.asset(AppImages.editFile)
                    ),
                  ],
                )
              ),
            )
          ],
        ),
      )),
    );
  }
}
