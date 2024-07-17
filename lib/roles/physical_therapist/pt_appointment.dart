import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/my_textfield.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/components/pt_components/pt_navbar.dart';
import 'package:table_calendar/table_calendar.dart';

class PtAppointment extends StatefulWidget {
  const PtAppointment({super.key});

  @override
  State<PtAppointment> createState() => _PtAppointmentState();
}

class _PtAppointmentState extends State<PtAppointment> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final patientController = TextEditingController();
  final dateController = TextEditingController();
  final selectedTimeSlotController = TextEditingController();
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

  Future<void> _selectDate(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _customHeader(context, _focusedDay),
                TableCalendar(
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
                      dateController.text =
                          DateFormat('yyyy-MM-dd').format(selectedDay);
                    });
                    Navigator.pop(context);
                  },
                  headerVisible: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final timeSlotsSnapshot = await FirebaseFirestore.instance
        .collection('timeSlots')
        .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDay))
        .get();

    if (timeSlotsSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No available time slots for selected date'),
        ),
      );
      return;
    }

    List<String> allTimeSlots = timeSlotsSnapshot.docs
        .map<String>((doc) => '${doc['startTime']} - ${doc['endTime']}')
        .toList();

    final appointmentsSnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDay))
        .get();

    final patientAppointmentsSnapshot = await FirebaseFirestore.instance
        .collection('patientAppointments')
        .where('date', isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDay))
        .get();

    List<String> bookedTimeSlots = [
      ...appointmentsSnapshot.docs.map((doc) => doc['time_slot'] as String),
      ...patientAppointmentsSnapshot.docs
          .map((doc) => doc['time_slot'] as String)
    ];

    List<String> availableTimeSlots =
        allTimeSlots.where((slot) => !bookedTimeSlots.contains(slot)).toList();

    if (availableTimeSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No available time slots for selected date'),
        ),
      );
      return;
    }

    final selectedTimeSlot = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Time Slot'),
          content: SingleChildScrollView(
            child: ListBody(
              children: availableTimeSlots
                  .map((slot) => RadioListTile<String>(
                        title: Text(slot),
                        value: slot,
                        groupValue: controller.text,
                        onChanged: (value) {
                          Navigator.of(context).pop(value);
                        },
                      ))
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (selectedTimeSlot != null) {
      setState(() {
        controller.text = selectedTimeSlot;
      });
    }
  }

  Future<void> _bookAppointment() async {
    final String title = titleController.text;
    final String description = descriptionController.text;
    final String patient = patientController.text;
    final String date = dateController.text;
    final String selectedTimeSlot = selectedTimeSlotController.text;

    if (title.isEmpty ||
        description.isEmpty ||
        date.isEmpty ||
        selectedTimeSlot.isEmpty ||
        patient.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('date', isEqualTo: date)
        .where('time_slot', isEqualTo: selectedTimeSlot)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selected time slot is already booked'),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('appointments').add({
      'title': title,
      'description': description,
      'date': date,
      'time_slot': selectedTimeSlot,
      'patient': patient,
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PtNavBar()),
    );
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
            margin: const EdgeInsets.only(top: 160),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color(0xFF333333),
                  blurRadius: 4.0,
                  offset: Offset(0.0, 0.55),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height - 150,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 35, left: 20),
                    child: Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  MyTextField(
                    controller: titleController,
                    hintText: 'Create title',
                    obscureText: false,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 35, left: 20),
                    child: Text(
                      'Brief Description',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  MyTextField(
                    controller: descriptionController,
                    hintText: 'Provide brief description',
                    obscureText: false,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 35, left: 20),
                    child: Text(
                      'Patient',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  MyTextField(
                    controller: patientController,
                    hintText: "Patient's Name",
                    hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                    obscureText: false,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 35, left: 20),
                    child: Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: AbsorbPointer(
                      child: MyTextField(
                        controller: dateController,
                        hintText: 'Select Date',
                        obscureText: false,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        suffixIcon: const AssetImage(AppImages.date),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 35, left: 20),
                    child: Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectTime(context, selectedTimeSlotController);
                    },
                    child: AbsorbPointer(
                      child: MyTextField(
                        controller: selectedTimeSlotController,
                        hintText: 'Select time slot',
                        obscureText: false,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        suffixIcon: const AssetImage(AppImages.time),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    child: GestureDetector(
                      onTap: _bookAppointment,
                      child: Container(
                        width: 320,
                        height: 54,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00BFA6),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          'Book Appointment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PtNavBar(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 10,
                      ),
                      child: Container(
                        width: 320,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 2,
                            color: const Color(0xFF00BFA6),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF00BFA6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
              child: Column(
                children: [
                  MyBackButtonRow(
                    buttonText: 'Create an Appointment',
                    color: Colors.white,
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PtNavBar()));
                    },
                    space: 40,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Create an appointment with your patient',
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
