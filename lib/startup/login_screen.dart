import 'package:flutter/material.dart';
import 'package:kineticare/Account/forgot_password.dart';
import 'package:kineticare/Services/auth.dart';
import 'package:kineticare/User/userhome.dart';
import 'package:kineticare/Widget/button.dart';
import 'package:kineticare/Widget/snackbar.dart';
import 'package:kineticare/components/my_textfield.dart';
import 'package:kineticare/components/my_label.dart';
import 'package:kineticare/components/main_button.dart';
import 'package:kineticare/startup/role_based.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

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

    String res = await AuthServices().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res == "success") {
      setState(() {
        isLoading = true;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const UserHome(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
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
                    'lib/assets/images/logoWname.png',
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
                      prefixIcon:
                          const AssetImage('lib/assets/images/vectorEmail.png'),
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
                      prefixIcon: const AssetImage(
                          'lib/assets/images/vectorPassword.png'),
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
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                isLoading
                    ? CircularProgressIndicator()
                    : MyButton(onTab: loginUser, text: "Log In"),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No account yet?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoleBased(),
                          ),
                        );
                      },
                      child: Text(
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
