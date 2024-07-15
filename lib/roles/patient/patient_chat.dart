import 'package:flutter/material.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';

class UserChat extends StatelessWidget {
  const UserChat({super.key});

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