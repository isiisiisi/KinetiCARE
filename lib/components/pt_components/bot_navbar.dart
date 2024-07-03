import 'package:flutter/material.dart';
import 'package:kineticare/roles/physical_therapist/pt_chat.dart';
import 'package:kineticare/roles/physical_therapist/pt_exerprograms.dart';
import 'package:kineticare/roles/physical_therapist/pt_home.dart';
import 'package:kineticare/roles/physical_therapist/pt_profile.dart';
import 'package:kineticare/roles/physical_therapist/pt_sched.dart';
import 'package:kineticare/components/app_images.dart';


class BottomNavBarPt extends StatefulWidget {
  const BottomNavBarPt({super.key});

  @override
  State<BottomNavBarPt> createState() => _BottomNavBarPtState();
}

class _BottomNavBarPtState extends State<BottomNavBarPt> {
  List<Widget> screenList = [
    const PtHome(),
    const Appointment(),
    const PtChat(),
    const PtExerprograms(),
    const PtProfile()
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
        unselectedItemColor: const Color(0xFF00BFA6),
        selectedIconTheme: const IconThemeData(
          size: 40,
          color: Colors.white,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 40,
        ),
        type: BottomNavigationBarType.fixed,
        currentIndex: AppImages.currentIndex.clamp(0, screenList.length - 1),
        selectedItemColor: const Color(0xFF00BFA6),
        onTap: onItemTapped,
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem(AppImages.home, 0),
          _buildBottomNavigationBarItem(AppImages.calendar, 1),
          _buildBottomNavigationBarItem(AppImages.chat, 2),
          _buildBottomNavigationBarItem(AppImages.ptPrograms, 3),
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
                color: const Color(0xFF00BFA6).withOpacity(0.9),
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