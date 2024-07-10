import 'package:flutter/material.dart';
import 'package:kineticare/Services/auth.dart';
import 'package:kineticare/Widget/button.dart';
import 'package:kineticare/Widget/snackbar.dart';
import 'package:kineticare/components/my_textfield.dart';
import 'package:kineticare/components/pt_components/bot_navbar.dart';

class TherapistRegisterScreen extends StatefulWidget {
  const TherapistRegisterScreen({super.key});

  @override
  _TherapistRegisterScreenState createState() => _TherapistRegisterScreenState();
}

class _TherapistRegisterScreenState extends State<TherapistRegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final specializationController = TextEditingController();
  final experienceController = TextEditingController();
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
          builder: (context) => BottomNavBarPt(),
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
        title: const Text('Therapist Registration'),
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
                controller: licenseNumberController,
                hintText: 'Enter your license number',
                obscureText: false,
              ),
              MyTextField(
                controller: specializationController,
                hintText: 'Enter your specialization',
                obscureText: false,
              ),
              MyTextField(
                controller: experienceController,
                hintText: 'Enter your years of experience',
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
