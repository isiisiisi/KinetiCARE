import 'package:flutter/material.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_datefield.dart';
import 'package:kineticare/components/my_text_field.dart';
import 'package:kineticare/services/auth.dart';
import 'package:kineticare/widget/snackbar.dart';
import 'package:kineticare/components/patient_components/patient_navbar.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/account/role_based.dart';
import 'package:kineticare/components/my_label.dart';
import 'package:kineticare/components/my_button.dart';
import 'package:kineticare/components/my_dropdown.dart';

class PatientRegisterScreen extends StatefulWidget {
  const PatientRegisterScreen({super.key});

  @override
  PatientRegisterScreenState createState() => PatientRegisterScreenState();
}

class PatientRegisterScreenState extends State<PatientRegisterScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final birthDateController = TextEditingController();
  final briefDescriptionController = TextEditingController();
  final contactFirstNameController = TextEditingController();
  final contactMiddleNameController = TextEditingController();
  final contactLastNameController = TextEditingController();
  final contactPhoneController = TextEditingController();
  String? _selectedGender;
  String? _selectedRelationship;
  bool isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    birthDateController.dispose();
    briefDescriptionController.dispose();
    contactFirstNameController.dispose();
    contactMiddleNameController.dispose();
    contactLastNameController.dispose();
    contactPhoneController.dispose();
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
        'middleName': middleNameController.text,
        'lastName': lastNameController.text,
        'phone': phoneController.text,
        'briefDescription': briefDescriptionController.text,
        'birthDate': birthDateController.text,
        'contactFirstName': contactFirstNameController.text,
        'contactMiddleName': contactMiddleNameController.text,
        'contactLastName': contactLastNameController.text,
        'contactPhone': contactPhoneController.text,
        'relationship': _selectedRelationship,
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
          builder: (context) => const PatientNavBar(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      showSnackBar(context, "Registration failed. Please try again.");
    }
  }

  void onBackButtonPressed() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RoleBased()),
      );
    }
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );

  //   if (picked != null) {
  //     setState(() {
  //       birthDateController.text =
  //           "${picked.month}/${picked.day}/${picked.year}";
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5A8DEE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30),
                padding: const EdgeInsets.all(35.0),
                child: const Text(
                  'Please fill in your details. Your data is necessary for communicating with your physical therapist. Rest assured that your data will be protected and secured.',
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
                child: Column(
                  children: [
                    RoundedRectanglePageIndicator(
                      itemCount: 3,
                      currentPage: _currentPage,
                    ),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: [
                          _buildPersonalInfoScreen(),
                          _buildAdditionalInfoScreen(),
                          _buildLoginCredentialsScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 80,
                child: MyBackButtonRow(
                  buttonText: 'Patient Registration',
                  onTap: onBackButtonPressed,
                  color: Colors.white,
                  space: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(
              'First Name', 'Enter your first name', firstNameController),
          const SizedBox(height: 15),
          _buildTextField(
              'Middle Name', 'Enter your middle name', middleNameController),
          const SizedBox(height: 15),
          _buildTextField(
              'Last Name', 'Enter your last name', lastNameController),
          const SizedBox(height: 15),
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
          const SizedBox(height: 15),
          _buildTextField(
              'Phone Number', 'Enter your phone number', phoneController),
          const SizedBox(height: 15),
          MyDateField(
            controller: birthDateController,
            hintText: 'Select Date of Birth',
            labelText: 'Date of Birth',
            suffixIcon: const AssetImage(AppImages.calendarIcon),
          ),
          const SizedBox(height: 50),
          isLoading
              ? const CircularProgressIndicator()
              : MyButton(
                  onTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  buttonText: "Next",
                  padding: const EdgeInsets.all(22),
                  margin: const EdgeInsets.symmetric(horizontal: 35.0),
                  color: const Color(0xFF5A8DEE),
                ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'Physical Health Concern',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(
            'Condition',
            'Briefly describe your health concern',
            briefDescriptionController,
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Emergency Contact',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField('Contact First Name', 'Enter contact first name',
              contactFirstNameController),
          const SizedBox(height: 15),
          _buildTextField('Contact Middle Name', 'Enter contact middle name',
              contactMiddleNameController),
          const SizedBox(height: 15),
          _buildTextField('Contact Last Name', 'Enter contact last name',
              contactLastNameController),
          const SizedBox(height: 15),
          MyDropdown(
              hintText: 'Select Relationship',
              labelText: 'Relationship',
              items: const ['Sibling', 'Parent', 'Other'],
              value: _selectedRelationship,
              onChanged: (value) {
                setState(() {
                  _selectedRelationship = value;
                });
              }),
          const SizedBox(height: 15),
          _buildTextField(
              'Contact Phone', 'Enter contact phone', contactPhoneController),
          const SizedBox(height: 50),
          isLoading
              ? const CircularProgressIndicator()
              : MyButton(
                  onTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  buttonText: "Next",
                  padding: const EdgeInsets.all(22),
                  margin: const EdgeInsets.symmetric(horizontal: 35.0),
                  color: const Color(0xFF5A8DEE),
                ),
        ],
      ),
    );
  }

  Widget _buildLoginCredentialsScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'Login Credentials',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField('Email', 'Enter your email', emailController),
          const SizedBox(height: 15),
          _buildTextField('Password', 'Enter your password', passwordController,
              obscureText: true),
          const SizedBox(height: 50),
          isLoading
              ? const CircularProgressIndicator()
              : MyButton(
                  onTap: registerUser,
                  buttonText: "Register",
                  padding: const EdgeInsets.all(22),
                  margin: const EdgeInsets.symmetric(horizontal: 35.0),
                  color: const Color(0xFF5A8DEE),
                ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String labelText,
    String hintText,
    TextEditingController controller, {
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: const Alignment(-1.2, 0.0),
          child: MyLabel(
            labelText: labelText,
          ),
        ),
        const SizedBox(height: 1.0),
        MyTextField(
          controller: controller,
          hintText: hintText,
          obscureText: obscureText,
        ),
      ],
    );
  }

//   Widget _buildDropdown(String labelText, List<String> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Align(
//           alignment: const Alignment(-1.2, 0.0),
//           child: MyLabel(
//             labelText: labelText,
//           ),
//         ),
//         MyDropdown(
//           hintText: 'Select your $labelText',
//           hintStyle: const TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
//           items: items,
//           onChanged: (value) {
//             setState(() {
//               _selectedGender = value;
//             });
//           },
//         ),
//       ],
//     );
//   }
}

class RoundedRectanglePageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentPage;

  const RoundedRectanglePageIndicator({
    super.key,
    required this.itemCount,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            height: 10.0,
            width: 30,
            // width: currentPage == index ? 30.0 : 30.0,
            decoration: BoxDecoration(
              color:
                  currentPage == index ? const Color(0xFF58ADEE) : Colors.grey,
              borderRadius: BorderRadius.circular(5.0),
            ),
          );
        }),
      ),
    );
  }
}
