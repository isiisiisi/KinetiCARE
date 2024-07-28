import 'package:flutter/material.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';

class MedicalInformation extends StatefulWidget {
  const MedicalInformation({super.key});

  @override
  State<MedicalInformation> createState() => _MedicalInformationState();
}

class _MedicalInformationState extends State<MedicalInformation> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: PatientAppbar(),
        ),
    );
  }
}