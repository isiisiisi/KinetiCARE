import 'package:flutter/material.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';

class PatientChat extends StatelessWidget {
  const PatientChat({super.key});

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
