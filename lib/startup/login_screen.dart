import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/Account/forgot_password.dart';
import 'package:kineticare/PhysicalTherapist/pt_home.dart';
import 'package:kineticare/Services/auth.dart';
import 'package:kineticare/User/userhome.dart';
import 'package:kineticare/Widget/button.dart';
import 'package:kineticare/Widget/snackbar.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_textfield.dart';
import 'package:kineticare/components/my_label.dart';
import 'package:kineticare/startup/role_based.dart';

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

    setState(() {
      isLoading = false;
    });

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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const PtHome(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserHome(),
              ),
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
      showSnackBar(context, "Login failed. Please check your email and password.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 55),
                SizedBox(
                  height: 270.0,
                  child: Image.asset(
                    AppImages.logoWname,
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MyLabel(labelText: 'Email'),
                    const SizedBox(height: 8.0),
                    MyTextField(
                      controller: emailController,
                      hintText: 'Enter your email',
                      obscureText: false,
                      prefixIcon: const AssetImage(AppImages.email),
                    ),
                  ],
                ),
                const SizedBox(height: 23),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MyLabel(labelText: 'Password'),
                    const SizedBox(height: 8.0),
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Enter your password',
                      obscureText: true,
                      prefixIcon: const AssetImage(AppImages.password),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
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
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(onTab: loginUser, text: "Log In"),
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
                        style: TextStyle(color: Colors.blue),
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
