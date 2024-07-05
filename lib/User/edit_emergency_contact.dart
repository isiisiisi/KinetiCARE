import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/User/emergency_contact.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_textfield.dart';

class EditEmergencyContact extends StatefulWidget {
  const EditEmergencyContact({super.key});

  @override
  State<EditEmergencyContact> createState() => _EditEmergencyContactState();
}

class _EditEmergencyContactState extends State<EditEmergencyContact> {
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
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                      color: Color(0xFF5A8DEE), shape: BoxShape.circle),
                )
              ],
            ),
          ),
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
                              builder: (context) => const EmergencyContact()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 35, left: 35),
                      child:
                          Image.asset(AppImages.backArrow, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 30),
                  const Padding(
                    padding: EdgeInsets.only(top: 35),
                    child: Text(
                      'Editing Emergency Contact',
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
                        child: Text('Relationship',
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
                    MaterialPageRoute(builder: (context)=> const EmergencyContact())
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
