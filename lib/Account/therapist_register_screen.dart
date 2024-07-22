import 'package:flutter/material.dart';
import 'package:kineticare/account/role_based.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/my_dropdown.dart';
import 'package:kineticare/components/my_label.dart';
import 'package:kineticare/services/auth.dart';
import 'package:kineticare/components/my_button.dart';
import 'package:kineticare/Widget/snackbar.dart';
import 'package:kineticare/components/my_textfield.dart';
import 'package:kineticare/components/pt_components/pt_navbar.dart';

class TherapistRegisterScreen extends StatefulWidget {
  const TherapistRegisterScreen({super.key});

  @override
  TherapistRegisterScreenState createState() => TherapistRegisterScreenState();
}

class TherapistRegisterScreenState extends State<TherapistRegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final specializationController = TextEditingController();
  final experienceController = TextEditingController();
  String? _selectedGender;
  bool isLoading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    licenseNumberController.dispose();
    specializationController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  void registerUser() async {
    setState(() {
      isLoading = true;
    });

    bool success = await AuthService().registerUser(
      email: emailController.text,
      password: passwordController.text,
      accountType: 'therapist',
      additionalDetails: {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'phone': phoneController.text,
        'licenseNumber': licenseNumberController.text,
        'specialization': specializationController.text,
        'experience': experienceController.text,
        'gender': _selectedGender,
      },
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (success) {
      showSnackBar(context, "Registration successful");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const PtNavBar(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      showSnackBar(context, "Registration failed. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00BFA6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 80,
                child: MyBackButtonRow(
                    buttonText: 'Create an account',
                    space: 40,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RoleBased()),
                      );
                    },
                    color: Colors.white),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.all(35.0),
                child: const Text(
                  'Please fill in your details. Your data is necessary for communicating with your patient. Rest assured that your data will be protected and secured.',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 150),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment(-1.2, 0.0),
                            child: MyLabel(
                              labelText: 'First Name',
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          MyTextField(
                            controller: firstNameController,
                            hintText: 'Enter your first name',
                            obscureText: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment(-1.2, 0.0),
                            child: MyLabel(
                              labelText: 'Last Name',
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          MyTextField(
                            controller: lastNameController,
                            hintText: 'Enter your last name',
                            obscureText: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyDropdown(
                              hintText: 'Select Gender',
                              labelText: 'Gender',
                              items: const ['Female', 'Male'],
                              value: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              }),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment(-1.2, 0.0),
                            child: MyLabel(
                              labelText: 'Email',
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          MyTextField(
                            controller: emailController,
                            hintText: 'Enter your email',
                            obscureText: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment(-1.2, 0.0),
                            child: MyLabel(
                              labelText: 'Password',
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          MyTextField(
                            controller: passwordController,
                            hintText: 'Enter your password',
                            obscureText: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment(-1.2, 0.0),
                            child: MyLabel(
                              labelText: 'Phone Number',
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          MyTextField(
                            controller: phoneController,
                            hintText: 'Enter your phone number',
                            obscureText: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment(-1.2, 0.0),
                            child: MyLabel(
                              labelText: 'License Number',
                            ),
                          ),
                          MyTextField(
                            controller: licenseNumberController,
                            hintText: 'Enter your license number',
                            obscureText: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment(-1.2, 0.0),
                            child: MyLabel(
                              labelText: 'Specialization',
                            ),
                          ),
                          MyTextField(
                            controller: specializationController,
                            hintText: 'Enter your specialization',
                            obscureText: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment(-1.2, 0.0),
                            child: MyLabel(
                              labelText: 'Years of Experience',
                            ),
                          ),
                          MyTextField(
                            controller: experienceController,
                            hintText: 'Enter your years of experience',
                            obscureText: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      isLoading
                          ? const CircularProgressIndicator()
                          : MyButton(
                              onTap: registerUser,
                              buttonText: "Register",
                              padding: const EdgeInsets.all(22),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 35.0),
                              color: const Color(0xFF00BFA6),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
