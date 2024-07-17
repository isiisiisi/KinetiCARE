import 'package:flutter/material.dart';
import 'package:kineticare/ChatSystem/chatpreview.dart';
import 'package:kineticare/ChatSystem/onboarding_referral.dart';
import 'package:kineticare/components/app_images.dart';

class UserChat extends StatelessWidget {
  const UserChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Chat',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Chat with your personal physical therapist.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.link, color: Color(0xFF5A8DEE)),
                title: Text('Connect with a PT'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnboardingScreens(),
                  ),
                  
                );
                
                },
              ),
            ),
            Expanded(
              child: ChatPreviewList(),
            ),
          ],
        ),
      ),
    );
  }
}
