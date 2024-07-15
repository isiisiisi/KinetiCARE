import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/components/patient_components/patient_appbar.dart';
import 'package:kineticare/roles/patient/personal_info.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_textfield.dart';

class EditPersonalInfo extends StatefulWidget {
  const EditPersonalInfo({super.key});

  @override
  State<EditPersonalInfo> createState() => _EditPersonalInfoState();
}

class _EditPersonalInfoState extends State<EditPersonalInfo> {
final nameController = TextEditingController();
final emailController = TextEditingController();
 late User user;
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchNameandEmail();
  }

  void fetchNameandEmail() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          name = documentSnapshot.get('name') ?? '';
          email = documentSnapshot.get('email') ?? '';
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching name and email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF5A8DEE),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70),
         child: PatientAppbar(),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
                child: Column(children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PersonalInfo()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 35, left: 35),
                      child:
                          Image.asset(AppImages.backArrow, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 50),
                  const Padding(
                    padding: EdgeInsets.only(top: 35),
                    child: Text(
                      'Editing Personal Info',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                height: 107.14,
                width: 109,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFFFFFFFF)),
                child: Image.asset(AppImages.editProfile),
              ),
              const SizedBox(height: 40),
              Container(
                width: 460,
                height: 1116,
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
                        'Personal Information',
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
                        child: Text('First Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)
                         ),
                        ),
                       ),
                      ),
                      MyTextField(
                      controller: nameController,
                      hintText: name,
                      obscureText: false,
                      prefixIcon: null,
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Middle Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)
                         ),
                        ),
                       ),
                      ),
                      MyTextField(
                      controller: nameController,
                      hintText: name,
                      obscureText: false,
                      prefixIcon: null,
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Last Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)
                         ),
                        ),
                       ),
                      ),
                      MyTextField(
                      controller: nameController,
                      hintText: name,
                      obscureText: false,
                      prefixIcon: null,
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Sex',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)
                         ),
                        ),
                       ),
                      ),
                      MyTextField(
                      controller: nameController,
                      hintText: name,
                      obscureText: false,
                      prefixIcon: null,
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Contact Number',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)
                         ),
                        ),
                       ),
                      ),
                      MyTextField(
                      controller: nameController,
                      hintText: name,
                      obscureText: false,
                      prefixIcon: null,
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Email Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)
                         ),
                        ),
                       ),
                      ),
                      MyTextField(
                      controller: emailController,
                      hintText: email,
                      obscureText: false,
                      prefixIcon: null,
                    ),
                    const SizedBox(height: 20),
               const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Birthdate',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333)),
                      )),
                ),
                Container(
                  height: 97,
                  width: 360,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFFD8D8D8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'Month',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Container(
                            width: 70,
                            height: 50,
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white
                            ),
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: nameController, 
                              obscureText: false,
                              decoration: const InputDecoration(
                                border: InputBorder.none
                              ),
                            ),  
                          )
                        ],
                      ),
                      const SizedBox(width: 25),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'Day',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Container(
                            width: 70,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white
                            ),
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: nameController, 
                              obscureText: false,
                              decoration: const InputDecoration(
                                border: InputBorder.none
                              ),
                            ),  
                          )
                        ],
                      ),
                      const SizedBox(width: 25),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'Year',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Container(
                            width: 82,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white
                            ),
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: nameController, 
                              obscureText: false,
                              decoration: const InputDecoration(
                                border: InputBorder.none
                              ),
                            ),  
                          ),
                        ],
                      ),
                    ],
                  ),
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
                    MaterialPageRoute(builder: (context)=> const PersonalInfo())
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
