import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/account/forgot_password.dart';
import 'package:kineticare/components/my_text_field.dart';
import 'package:kineticare/components/patient_components/patient_navbar.dart';
import 'package:kineticare/components/pt_components/pt_navbar.dart';
import 'package:kineticare/services/auth.dart';
import 'package:kineticare/Widget/snackbar.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_button.dart';
import 'package:kineticare/components/my_label.dart';
import 'package:kineticare/account/role_based.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    bool success = await AuthService().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (documentSnapshot.exists) {
          String accountType = documentSnapshot.get('accountType');

          if (accountType == "therapist") {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const PtNavBar(),
              ),
              (Route<dynamic> route) => false,
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const PatientNavBar(),
              ),
              (Route<dynamic> route) => false,
            );
          }

          showSnackBar(context, "Login successful");
        } else {
          showSnackBar(context, "User document does not exist.");
        }
      } else {
        showSnackBar(context, "No user is currently signed in.");
      }
    } else {
      showSnackBar(
          context, "Login failed. Please check your email and password.");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 70),
                SizedBox(
                  height: 270.0,
                  child: Image.asset(
                    AppImages.logoWname,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MyLabel(labelText: 'Email'),
                    const SizedBox(height: 5.0),
                    MyTextField(
                      controller: emailController,
                      hintText: 'Enter your email',
                      obscureText: false,
                      prefixIcon: const AssetImage(AppImages.email),
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MyLabel(labelText: 'Password'),
                    const SizedBox(height: 5.0),
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Enter your password',
                      obscureText: true,
                      prefixIcon: const AssetImage(AppImages.password),
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Align(
                  alignment: const Alignment(0.8, 0.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                          color: Color(0xFF707070),
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(
                        onTap: loginUser,
                        buttonText: "Log In",
                        padding: const EdgeInsets.all(22),
                        margin: const EdgeInsets.symmetric(horizontal: 60.0),
                        color: const Color(0xFF333333),
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No account yet?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RoleBased(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            color: Color(0xFF707070),
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.5),
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
  }
}
