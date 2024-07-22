import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/pt_components/pt_appbar.dart';
import 'package:kineticare/roles/physical_therapist/create_schedule.dart';
import 'package:kineticare/roles/physical_therapist/pt_appointment.dart';
import 'package:kineticare/roles/physical_therapist/time_slot.dart';
import 'package:rxdart/rxdart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  List<DocumentSnapshot> combinedAppointments = [];

  void refreshAppointments() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDay))
        .get();

    setState(() {
      combinedAppointments = snapshot.docs;
    });
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    refreshAppointments();


    FirebaseFirestore.instance
        .collection('appointments')
        .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDay))
        .snapshots()
        .listen((snapshot) {
      setState(() {
        combinedAppointments = snapshot.docs;
      });
    });

    
    FirebaseFirestore.instance
        .collection('patientAppointments')
        .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDay))
        .snapshots()
        .listen((snapshot) {
      setState(() {
        combinedAppointments.addAll(snapshot.docs);
      });
    });
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _onLeftArrowTap,
        ),
        Text(
          DateFormat.yMMMM().format(focusedDay),
          style: const TextStyle(fontSize: 20.0),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _onRightArrowTap,
        ),
      ],
    );
  }

  String getCurrentTherapistEmail() {
    return FirebaseAuth.instance.currentUser!.email!;
  }

  Future<bool> isTimeSlotBooked(String date, String startTime, String endTime) async {
    final appointmentSnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('date', isEqualTo: date)
        .where('time_slot', isEqualTo: '$startTime - $endTime')
        .get();

    final patientAppointmentSnapshot = await FirebaseFirestore.instance
        .collection('patientAppointments')
        .where('date', isEqualTo: date)
        .where('time_slot', isEqualTo: '$startTime - $endTime')
        .get();

    return appointmentSnapshot.docs.isNotEmpty || patientAppointmentSnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: PtAppbar(),
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
                const SizedBox(height: 25),
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
                    refreshAppointments();
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    headerPadding: EdgeInsets.zero,
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                    titleTextFormatter: (date, locale) =>
                        DateFormat.yMMM(locale).format(date),
                    titleTextStyle: const TextStyle(fontSize: 20.0),
                  ),
                  calendarBuilders: CalendarBuilders(
                    headerTitleBuilder: (context, date) {
                      return _customHeader(context, date);
                    },
                  ),
                  calendarStyle: const CalendarStyle(
                    defaultTextStyle: TextStyle(fontSize: 20.0),
                    weekendTextStyle: TextStyle(fontSize: 20.0),
                    selectedTextStyle:
                        TextStyle(fontSize: 20.0, color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Color(0xFF00BFA6),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFF00BFA6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Available Time Slots',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TimeSlot()));
                      },
                      child: Image.asset(AppImages.slot),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('timeSlots')
                      .where('date',
                          isEqualTo:
                              DateFormat('yyyy-MM-dd').format(_selectedDay))
                      .where('therapistEmail',
                          isEqualTo: getCurrentTherapistEmail())
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final timeSlots = snapshot.data!.docs;

                    if (timeSlots.isEmpty) {
                      return const Center(
                        child: Text(
                          'No time slots plotted for today.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3,
                      ),
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        final timeSlot = timeSlots[index];
                        final timeSlotData =
                            timeSlot.data() as Map<String, dynamic>;
                        final startTime = timeSlotData['startTime'];
                        final endTime = timeSlotData['endTime'];
                        final formattedTimeSlot = '$startTime to $endTime';

                        return FutureBuilder<bool>(
                          future: isTimeSlotBooked(
                              DateFormat('yyyy-MM-dd').format(_selectedDay),
                              startTime,
                              endTime),
                          builder: (context, snapshot) {
                            final isBooked = snapshot.data ?? false;
                            final color = isBooked ? Colors.white : const Color(0xFFE9E9EB);

                            return Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  formattedTimeSlot,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Activity Schedule',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PtAppointment(),
                          ),
                        );
                      },
                      child: Image.asset(AppImages.schedule),
                    ),
                  ],
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
                          onTap: () => showCreateAppointmentDialog(context,
                              appointmentSnapshot: combinedAppointments[index],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
