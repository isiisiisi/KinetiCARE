import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/pt_components/pt_appbar.dart';
import 'package:kineticare/components/pt_components/pt_navbar.dart';

class PtGeneralSettings extends StatefulWidget {
  const PtGeneralSettings({super.key});

  @override
  State<PtGeneralSettings> createState() => _PtGeneralSettingsState();
}

class _PtGeneralSettingsState extends State<PtGeneralSettings> {
  Future<void> _showDeleteConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                _deleteAccount(); 
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.delete(); 
        await FirebaseAuth.instance.signOut(); 
        Navigator.pushReplacementNamed(context, '/LoginScreen'); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting account: $e'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No user is currently signed in.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: PtAppbar(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
          child: Column(
            children: [
              MyBackButtonRow(
                buttonText: 'General Settings',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PtNavBar(),
                    ),
                  );
                },
                space: 55,
              ),
              const SizedBox(height: 85),
              Container(
                width: 295,
                height: 87,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF5A8DEE),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0xFF333333),
                      blurRadius: 4.0,
                      offset: Offset(0.0, 0.55),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(AppImages.setInfo),
                    const SizedBox(width: 15),
                    const Text(
                      'Email and Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Container(
                width: 295,
                height: 87,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF5A8DEE),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0xFF333333),
                      blurRadius: 4.0,
                      offset: Offset(0.0, 0.55),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(AppImages.notif),
                    const SizedBox(width: 15),
                    const Text(
                      'Notification Preferences',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Container(
                width: 295,
                height: 87,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF5A8DEE),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0xFF333333),
                      blurRadius: 4.0,
                      offset: Offset(0.0, 0.55),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.asset(AppImages.privacy),
                    const SizedBox(width: 15),
                    const Text(
                      'Privacy Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: _showDeleteConfirmationDialog,
                child: Container(
                  width: 295,
                  height: 87,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF5A8DEE),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0xFF333333),
                        blurRadius: 4.0,
                        offset: Offset(0.0, 0.55),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(AppImages.trash),
                      const SizedBox(width: 15),
                      const Text(
                        'Delete Account',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
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
