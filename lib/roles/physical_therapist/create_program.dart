import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/my_button.dart';
import 'package:kineticare/components/my_text_field.dart';
import 'package:kineticare/components/pt_components/pt_appbar.dart';
import 'package:kineticare/components/pt_components/pt_navbar.dart';

class CreateProgram extends StatefulWidget {
  const CreateProgram({super.key});

  @override
  State<CreateProgram> createState() => _CreateProgramState();
}

class _CreateProgramState extends State<CreateProgram> {
  final planController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70), 
          child: PtAppbar()),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyBackButtonRow(
                  buttonText: 'Create a Program',
                  onTap: () {
                    Navigator.pushReplacement(context, 
                    MaterialPageRoute(builder: (context) => const PtNavBar()),
                    );
                  },
                  space: 30,
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text('Create and personalize exercise programs', 
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF707070)
                  )
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Plan Name:',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333)
                  )
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: planController, 
                  hintText: 'Plan Name', 
                  obscureText: false,
                  padding: const EdgeInsets.only(left: 1, right: 1),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
                const SizedBox(height: 15),
                const Text('Duration:',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333)
                  )
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: planController, 
                  hintText: 'Duration', 
                  obscureText: false,
                  padding: const EdgeInsets.only(left: 1, right: 1),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 95,
                      height: 92,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(AppImages.upload),
                    ),
                    const SizedBox(width: 45),
                    const Text('Upload Video',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF707070)
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                MyButton(
                  onTap: () {
                    Navigator.pushReplacement(context, 
                    MaterialPageRoute(builder: (context) => const PtNavBar()),
                    );
                  }, 
                  buttonText: 'Next',
                  color: const Color(0xFF00BFA6),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 60),
                  boxShadow: const BoxShadow(
                    color: Color(0xFF333333),
                    blurRadius: 4.0,
                    offset: Offset(0.0, 0.40),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
