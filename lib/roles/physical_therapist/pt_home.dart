import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:rxdart/rxdart.dart';

class PtHome extends StatefulWidget {
  const PtHome({super.key});

  @override
  _PtHomeState createState() => _PtHomeState();
}

class _PtHomeState extends State<PtHome> {
  late DateTime _selectedDay; 

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
    //final String firestoreDateFormat = DateFormat('yyyy-MM-dd').format(DateTime.now());

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
                  shape: BoxShape.circle,
                  color: Color(0xFF00BFA6),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello, Juan!',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Today is $formattedDate',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFA0A0A0),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF00BFA6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 55),
                const Text(
                  'Number of active patients: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 71,
                  width: 399,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF00BFA6),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0xFF333333),
                        blurRadius: 4.0,
                        offset: Offset(0.0, 0.55),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Image.asset(AppImages.patientList),
                        const SizedBox(width: 20),
                        const Text(
                          'Patient List',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                        const SizedBox(width: 150),
                        Image.asset(
                          AppImages.forArrow,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Number of pending requests: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 71,
                  width: 399,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF00BFA6),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0xFF333333),
                        blurRadius: 4.0,
                        offset: Offset(0.0, 0.55),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Image.asset(AppImages.pending),
                        const SizedBox(width: 20),
                        const Text(
                          'Pending Requests',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                        const SizedBox(width: 100),
                        Image.asset(
                          AppImages.forArrow,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'Upcoming Appointments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
                ),
                const SizedBox(height: 10),
                StreamBuilder<List<QuerySnapshot>>(
                  stream: CombineLatestStream.list([
                    FirebaseFirestore.instance
                        .collection('appointments')
                        .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDay))
                        .snapshots(),
                    FirebaseFirestore.instance
                        .collection('patientAppointments')
                        .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDay))
                        .snapshots(),
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final appointments = snapshot.data![0].docs;
                    final patientAppointments = snapshot.data![1].docs;

                    if (appointments.isEmpty && patientAppointments.isEmpty) {
                      return const Text('No appointments available.');
                    }

                    final combinedAppointments = [
                      ...appointments,
                      ...patientAppointments
                    ];

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: combinedAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = combinedAppointments[index].data() as Map<String, dynamic>;
                        final title = appointment['title'] ?? 'No Title';
                        final appointmentTime = '${appointment['time_slot']}';

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF5A8DEE),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(title),
                                  subtitle: Text(appointmentTime),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
