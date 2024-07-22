import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/my_textfield.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/components/pt_components/pt_navbar.dart';
import 'package:table_calendar/table_calendar.dart';

class TimeSlot extends StatefulWidget {
  const TimeSlot({super.key});

  @override
  State<TimeSlot> createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;

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

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  String getCurrentTherapistEmail() {
    return FirebaseAuth.instance.currentUser!.email!;
  }

  Future<void> _addTimeSlot() async {
    final String startTime = startTimeController.text;
    final String endTime = endTimeController.text;
    final String therapistEmail = getCurrentTherapistEmail();

    if (startTime.isEmpty || endTime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('timeSlots').add({
      'startTime': startTime,
      'endTime': endTime,
      'date': DateFormat('yyyy-MM-dd').format(_selectedDay),
      'therapistEmail': therapistEmail, // Add therapist email here
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TimeSlot()),
    );
  }

  Future<void> _deleteTimeSlot(String id) async {
    await FirebaseFirestore.instance.collection('timeSlots').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00BFA6),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: PatientAppbar(),
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 190),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color(0xFF333333),
                  blurRadius: 4.0,
                  offset: Offset(0.0, 0.55),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: TableCalendar(
                    calendarFormat: CalendarFormat.week,
                    firstDay: _firstDay,
                    lastDay: _lastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: false,
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
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('timeSlots')
                        .where('date',
                            isEqualTo:
                                DateFormat('yyyy-MM-dd').format(_selectedDay))
                        .where('therapistEmail',
                            isEqualTo: getCurrentTherapistEmail())
                        .snapshots(),
                    builder: (context, snapshot) {
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

                      return ListView.builder(
                        itemCount: timeSlots.length,
                        itemBuilder: (context, index) {
                          final timeSlot = timeSlots[index];
                          final timeSlotData =
                              timeSlot.data() as Map<String, dynamic>;
                          final startTime = timeSlotData['startTime'];
                          final endTime = timeSlotData['endTime'];
                          final formattedTimeSlot = '$startTime to $endTime';

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9E9EB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formattedTimeSlot,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  icon: Image.asset(AppImages.delete),
                                  onPressed: () => _deleteTimeSlot(timeSlot.id),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const Center(
                  child: Text(
                    'Add Time Slot',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _selectTime(context, startTimeController);
                        },
                        child: AbsorbPointer(
                          child: MyTextField(
                            controller: startTimeController,
                            hintText: 'Start Time',
                            obscureText: false,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('to', style: TextStyle(fontSize: 17)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _selectTime(context, endTimeController);
                        },
                        child: AbsorbPointer(
                          child: MyTextField(
                            controller: endTimeController,
                            hintText: 'End Time',
                            obscureText: false,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: GestureDetector(
                    onTap: _addTimeSlot,
                    child: Container(
                      width: 320,
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BFA6),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Color(0xFF333333),
                              blurRadius: 4.0,
                              offset: Offset(0.0, 0.55))
                        ],
                      ),
                      child: const Text(
                        'Add Time Slot',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
              child: Column(
                children: [
                  MyBackButtonRow(
                    buttonText: 'Available Time Slots',
                    color: Colors.white,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PtNavBar()),
                      );
                    },
                    space: 40,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Create and edit available time slots',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFFFFFFF),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
