import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/patient_components/bar_graph.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/components/patient_components/pie_chart.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final String formattedDate =
      DateFormat('MMMM dd, yyyy').format(DateTime.now());

  late User user;
  late String firstName = '';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchFirstName();
  }

  void fetchFirstName() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          firstName = documentSnapshot.get('firstName') ?? '';
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching first name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<double> weeklySummary = [0, 0, 2, 0, 0, 0, 0];
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: PatientAppbar(),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
                        Text('Hello, $firstName!',
                          style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                        Text('Today is $formattedDate',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA0A0A0))),
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFF5A8DEE)),
                      )
                    ],
                  ),
                  const SizedBox(height: 60),
                  const Text('Active Programs',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 140),
                  const Text('Progress Report',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text('Pain Level',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Container(
                      height: 113,
                      width: 385,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            style: BorderStyle.solid,
                            width: 1.5,
                            color: const Color(0xFFA0A0A0),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Image.asset(AppImages.neutral),
                                const Text('Mild Plain',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                            const Column(
                              children: [
                                MyPieChart(painLevel: 5.0),
                                Text('Average',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Center(
                    child: Container(
                      height: 186,
                      width: 385,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            style: BorderStyle.solid,
                            width: 1.5,
                            color: const Color(0xFFA0A0A0),
                          )),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Text('Exercises Completed this Week',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ),
                          MyBarGraph(weeklySummary: weeklySummary)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
