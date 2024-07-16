import 'package:flutter/material.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';

class PatientExercise extends StatelessWidget {
  const PatientExercise({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: PatientAppbar(),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 35),
            child: Text('Exercise Programs',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333)
            ),
            ),
          )
        ),
      ),
    );
  }
}
