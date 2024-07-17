import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/components/my_button.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/roles/patient/book_appointment.dart';
import 'package:kineticare/roles/patient/edit_appointment.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class UserAppoint extends StatefulWidget {
  const UserAppoint({super.key});

  @override
  State<UserAppoint> createState() => _UserAppointState();
}

class _UserAppointState extends State<UserAppoint> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  List<DocumentSnapshot> combinedAppointments = [];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
  }

  void _onLeftArrowTap() {
    setState(() {
      _focusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month - 1,
      );
    });
  }

  void _onRightArrowTap() {
    setState(() {
      _focusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month + 1,
      );
    });
  }

  Widget _customHeader(BuildContext context, DateTime focusedDay) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: _onLeftArrowTap,
        ),
        Text(
          DateFormat.yMMMM().format(focusedDay),
          style: const TextStyle(fontSize: 20.0),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, size: 30),
          onPressed: _onRightArrowTap,
        ),
      ],
    );
  }

  void refreshAppointments() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('patientAppointments')
        .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDay))
        .get();

    // if (kDebugMode) {
    //   print('Snapshot docs: ${snapshot.docs.length}');
    // }
    // for (var doc in snapshot.docs) {
    //   if (kDebugMode) {
    //     print('Appointment: ${doc.data()}');
    //   }
    // }

    setState(() {
      combinedAppointments = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Schedule',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 20),
                _customHeader(context, _focusedDay),
                const SizedBox(height: 20),
                TableCalendar(
                  calendarFormat: CalendarFormat.week,
                  focusedDay: _focusedDay,
                  firstDay: _firstDay,
                  lastDay: _lastDay,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  headerVisible: false,
                  calendarStyle: const CalendarStyle(
                    defaultTextStyle: TextStyle(fontSize: 20.0),
                    weekendTextStyle: TextStyle(fontSize: 20.0),
                    selectedTextStyle:
                        TextStyle(fontSize: 20.0, color: Colors.white),
                    todayDecoration: BoxDecoration(
                        color: Color(0xFF5A8DEE), shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(
                        color: Color(0xFF5A8DEE), shape: BoxShape.circle),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Appointment Schedule',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333)),
                ),
                const SizedBox(height: 10),
                StreamBuilder<List<QuerySnapshot>>(
                  stream: CombineLatestStream.list([
                    FirebaseFirestore.instance
                        .collection('appointments')
                        .where('date',
                            isEqualTo:
                                DateFormat('yyyy-MM-dd').format(_selectedDay))
                        .snapshots(),
                    FirebaseFirestore.instance
                        .collection('patientAppointments')
                        .where('date',
                            isEqualTo:
                                DateFormat('yyyy-MM-dd').format(_selectedDay))
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
                        final appointment = combinedAppointments[index].data()
                            as Map<String, dynamic>;
                        final title = appointment['title'] ?? 'No Title';
                        final appointmentTime = '${appointment['time_slot']}';

                        return GestureDetector(
                          onTap: () => showBookAppointmentDialog(context,
                           patientAppointmentSnapshot: combinedAppointments[index],
                           refreshAppointments: refreshAppointments),
                          child: Container(
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
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF5A8DEE),
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
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                MyButton(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BookAppointment()));
                  },
                  buttonText: 'Book Appointment',
                  color: const Color(0xFF5A8DEE),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  padding: const EdgeInsets.all(15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
