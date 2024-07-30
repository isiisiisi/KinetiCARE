import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/my_text_field.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/roles/patient/medical_information.dart';

class EditDescription extends StatefulWidget {
  const EditDescription({super.key});

  @override
  State<EditDescription> createState() => _EditDescriptionState();
}

class _EditDescriptionState extends State<EditDescription> {
final briefDescriptionController = TextEditingController();
 late User user;
 String briefDescription = '';


  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchDetails();
  }

  void fetchDetails() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          briefDescription = documentSnapshot.get('briefDescription') ?? '';
        });
      } else {
        if (kDebugMode) {
          print('Document does not exist');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching first name: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF5A8DEE),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: PatientAppbar()
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
                child: Column(
                  children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: MyBackButtonRow(
                  buttonText: 'Editing Medical Information', 
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicalInformation()));
                  }, 
                  space: 30,
                  color: Colors.white,
                  ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 460,
                height: 920,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(0xFF333333),
                          blurRadius: 4.0,
                          offset: Offset(0.0, 0.75))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      const Text(
                        'Physical Health Concern',
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Brief Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)
                         ),
                        ),
                       ),
                      ),
                      MyTextField(
                      controller: briefDescriptionController,
                      hintText: briefDescription,
                      obscureText: false,
                      prefixIcon: null,
                      maxLines: 10,
                    ),   
                const SizedBox(height: 35),
                Container(
                  width: 320,
                  height: 54,
                  decoration: BoxDecoration(
                      color: const Color(0xFF5A8DEE),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Color(0xFF333333),
                            blurRadius: 4.0,
                            offset: Offset(0.0, 0.55))
                      ]),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      'Save',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, 
                    MaterialPageRoute(builder: (context)=> const MedicalInformation())
                    );
                  },
                  child: Container(
                    width: 320,
                    height: 54,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            width: 2, color: const Color(0xFF5A8DEE)),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Color(0xFF333333),
                              blurRadius: 4.0,
                              offset: Offset(0.0, 0.55))
                        ]),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5A8DEE)),
                      ),
                    ),
                  ),
                ),
                    ],
                  ),
                ),
              ),
            ]
          )
        )
      )
    );
  }
}
