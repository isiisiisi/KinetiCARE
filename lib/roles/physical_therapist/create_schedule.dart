import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_textField.dart';
//import 'package:kineticare/roles/physical_therapist/cancel_appointment.dart';

void showCreateAppointmentDialog(BuildContext context,
    {DocumentSnapshot? appointmentSnapshot,
    required void Function() refreshAppointments}) {
  final TextEditingController titleController =
      TextEditingController(text: appointmentSnapshot?.get('title') ?? '');
  final TextEditingController descriptionController = TextEditingController(
      text: appointmentSnapshot?.get('description') ?? '');
  final TextEditingController patientController =
      TextEditingController(text: appointmentSnapshot?.get('patient') ?? '');
  final TextEditingController selectedTimeSlotController =
      TextEditingController(text: appointmentSnapshot?.get('time_slot') ?? '');
  final TextEditingController dateController = TextEditingController(
    text: appointmentSnapshot != null
        ? appointmentSnapshot.get('date') is String
            ? appointmentSnapshot.get('date')
            : appointmentSnapshot.get('date') is Timestamp
                ? DateFormat('yyyy-MM-dd').format(
                    (appointmentSnapshot.get('date') as Timestamp)
                        .toDate()) // Format Timestamp to string
                : ''
        : '',
  );

  void saveAppointment() {
    final appointmentData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'patient': patientController.text,
      'time_slot': selectedTimeSlotController.text,
      'date': dateController.text,
    };

    if (appointmentSnapshot != null) {
      appointmentSnapshot.reference.update(appointmentData);
    }

    refreshAppointments();
    Navigator.pop(context);
  }

  void deleteAppointment() {
    if (appointmentSnapshot != null) {
      appointmentSnapshot.reference.delete();
    }
    Navigator.pop(context);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Future<void> selectTime(
      BuildContext context,
      TextEditingController controller,
      void Function(void Function()) setState) async {
    final timeSlotsSnapshot = await FirebaseFirestore.instance
        .collection('timeSlots')
        .where('date', isEqualTo: dateController.text)
        .get();

    if (timeSlotsSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No available time slots for selected date'),
        ),
      );
      return;
    }

    List<String> availableTimeSlots = timeSlotsSnapshot.docs
        .map((doc) => '${doc['startTime']} - ${doc['endTime']}')
        .toList();

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

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Appointment',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(AppImages.exit),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Title',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333)),
                          ),
                          MyTextField(
                            controller: titleController,
                            hintText: '',
                            obscureText: false,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 7),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Brief Description',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333)),
                          ),
                          MyTextField(
                            controller: descriptionController,
                            hintText: '',
                            obscureText: false,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 7),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Patient',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333)),
                          ),
                          MyTextField(
                            controller: patientController,
                            hintText: '',
                            obscureText: false,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 7),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333)),
                          ),
                          GestureDetector(
                            onTap: () {
                              selectDate(context);
                            },
                            child: AbsorbPointer(
                              child: MyTextField(
                                controller: dateController,
                                hintText: '',
                                obscureText: false,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 7),
                                suffixIcon: const AssetImage(AppImages.date),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Time',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333)),
                          ),
                          GestureDetector(
                            onTap: () {
                              selectTime(context, selectedTimeSlotController,
                                  setState);
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: MyTextField(
                                    controller: selectedTimeSlotController,
                                    hintText: '',
                                    obscureText: false,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 7),
                                    suffixIcon:
                                        const AssetImage(AppImages.time),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: deleteAppointment,
                            // {
                            //   Navigator.pushReplacement(context,
                            //       MaterialPageRoute(builder: (context) => const CancelAppointment()));
                            // },
                            child: Container(
                              width: 102,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 1.5,
                                  style: BorderStyle.solid,
                                  color: const Color(0xFFA0A0A0),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF00BFA6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: saveAppointment,
                            child: Container(
                              width: 102,
                              height: 34,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00BFA6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
