import 'package:flutter/material.dart';
import 'package:kineticare/User/user_appoint.dart';
import 'package:kineticare/User/user_chat.dart';
import 'package:kineticare/User/user_exercise.dart';
import 'package:kineticare/User/user_profile.dart';
import 'package:kineticare/User/userhome.dart';
import 'package:kineticare/components/app_images.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<Widget> screenList = [
    const UserHome(),
    const UserAppoint(),
    const UserChat(),
    const UserExercise(),
    const UserProfile()
  ];

  void onItemTapped(int index) {
    setState(() {
      AppImages.currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: screenList.elementAt(
            AppImages.currentIndex.clamp(0, screenList.length - 1),
          ),
        ),
        bottomNavigationBar: bottomNavigationBars(),
      ),
    );
  }

  Widget bottomNavigationBars() {
    return Container(
      decoration: const BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(
            color: Color(0xFF333333),
            blurRadius: 15.0,
            offset: Offset(0.0, 0.75))
      ]),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 50,
        unselectedItemColor: const Color(0xFF5A8DEE),
        selectedIconTheme: const IconThemeData(
          size: 40,
          color: Colors.white,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 40,
        ),
        type: BottomNavigationBarType.fixed,
        currentIndex: AppImages.currentIndex.clamp(0, screenList.length - 1),
        selectedItemColor: Colors.white,
        onTap: onItemTapped,
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem(AppImages.home, 0),
          _buildBottomNavigationBarItem(AppImages.calendar, 1),
          _buildBottomNavigationBarItem(AppImages.chat, 2),
          _buildBottomNavigationBarItem(AppImages.exercise, 3),
          _buildBottomNavigationBarItem(AppImages.profile, 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      String imageAsset, int index) {
    bool isSelected = AppImages.currentIndex == index;
    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          if (isSelected)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF5A8DEE).withOpacity(0.9),
              ),
            ),
          ImageIcon(
            AssetImage(imageAsset),
            size: 40,
          ),
        ],
      ),
      label: '',
    );
  }
}
