import 'package:flutter/material.dart';
import 'package:kineticare/Services/auth.dart';
import 'package:kineticare/Widget/button.dart';
import 'package:kineticare/Widget/snackbar.dart';
import 'package:kineticare/components/my_textfield.dart';
import 'package:kineticare/components/patient_components/patient_navbar.dart';

class PatientRegisterScreen extends StatefulWidget {
  const PatientRegisterScreen({super.key});

  @override
  _PatientRegisterScreenState createState() => _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final briefDescriptionController = TextEditingController();
  final emergencyContactNameController = TextEditingController();
  final emergencyContactPhoneController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    briefDescriptionController.dispose();
    emergencyContactNameController.dispose();
    emergencyContactPhoneController.dispose();
    super.dispose();
  }

  void registerUser() async {
    setState(() {
      isLoading = true;
    });

    bool success = await AuthService().registerUser(
      email: emailController.text,
      password: passwordController.text,
      accountType: 'patient',
      additionalDetails: {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'phone': phoneController.text,
        'briefDescription': briefDescriptionController.text,
        'emergencyContactName': emergencyContactNameController.text,
        'emergencyContactPhone': emergencyContactPhoneController.text,
        // Add more fields as needed
      },
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (success) {
      showSnackBar(context, "Registration successful");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>const BottomNavBarPatient(),
        ),
      );
    } else {
      showSnackBar(context, "Registration failed. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Registration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              MyTextField(
                controller: firstNameController,
                hintText: 'Enter your first name',
                obscureText: false,
              ),
              MyTextField(
                controller: lastNameController,
                hintText: 'Enter your last name',
                obscureText: false,
              ),
              MyTextField(
                controller: emailController,
                hintText: 'Enter your email',
                obscureText: false,
              ),
              MyTextField(
                controller: passwordController,
                hintText: 'Enter your password',
                obscureText: true,
              ),
              MyTextField(
                controller: phoneController,
                hintText: 'Enter your phone number',
                obscureText: false,
              ),
              MyTextField(
                controller: briefDescriptionController,
                hintText: 'Brief description',
                obscureText: false,
              ),
              MyTextField(
                controller: emergencyContactNameController,
                hintText: 'Emergency contact name',
                obscureText: false,
              ),
              MyTextField(
                controller: emergencyContactPhoneController,
                hintText: 'Emergency contact phone',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(onTab: registerUser, text: "Register"),
            ],
          ),
        ),
      ),
    );
  }
}
