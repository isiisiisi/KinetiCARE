import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/dashed_border.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/my_button.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/roles/patient/view_referral.dart';

class ChangeReferral extends StatefulWidget {
  const ChangeReferral({super.key});

  @override
  State<ChangeReferral> createState() => _ChangeReferralState();
}

class _ChangeReferralState extends State<ChangeReferral> {
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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyBackButtonRow(
                  buttonText: 'Medical Information',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewReferral(),
                      ),
                    );
                  },
                  space: 25,
                  color: const Color(0xFF707070),
                ),
                const SizedBox(height: 35),
                const Center(
                  child: Text(
                    'Change Referral Letter',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                const Text(
                  'Upload Referral Letter',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 15),
                DashedBorder(
                  strokeWidth: 1,
                  color: const Color(0xFF333333),
                  dashWidth: 20,
                  dashGap: 10,
                  child: Container(
                    width: 395,
                    height: 271,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 85),
                          Image.asset(AppImages.uploadFile),
                          const SizedBox(height: 10),
                          const Text(
                            'Choose file',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF58595B)),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Uploaded Referral Letter',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(
                  onTap: () {},
                  buttonText: 'Change Letter',
                  color: const Color(0xFF5A8DEE),
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ViewReferral()),
                      );
                    },
                    child: Container(
                      width: 372,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF5A8DEE),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0xFF333333),
                            blurRadius: 4.0,
                            offset: Offset(0.0, 0.55),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5A8DEE),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
