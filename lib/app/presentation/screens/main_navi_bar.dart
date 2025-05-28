import 'package:flutter/material.dart';
import 'package:mobile_app_2/app/presentation/screens/main_navi_screens/appointment.dart';
import 'package:mobile_app_2/app/presentation/screens/main_navi_screens/home.dart';
import 'package:mobile_app_2/app/presentation/screens/main_navi_screens/profile.dart';
import 'package:mobile_app_2/app/presentation/screens/main_navi_screens/recommendation.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

// ignore: must_be_immutable
class MainNaviBar extends StatefulWidget {
 int? pageIndex= 0;
   MainNaviBar({super.key, this.pageIndex});
  @override
  State<MainNaviBar> createState() => _MainNaviBarState();
}

class _MainNaviBarState extends State<MainNaviBar> {
  List<Widget> screens = [
    Home(),
    Recommendation(),
    Appointment(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 100,
        child: BottomNavigationBar(
          currentIndex: widget.pageIndex ?? 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: mainBgColor,
          unselectedItemColor: Color(0xff929CAD),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Recommendation',
              icon: Icon(Icons.filter_frames_sharp),
            ),
            BottomNavigationBarItem(
              label: 'Appointment',
              icon: Icon(
                Icons.calendar_today_outlined,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(Icons.person),
            ),
          ],
          onTap: (index) {
            setState(() {
              widget.pageIndex = index;
            });
          },
        ),
      ),
      body: screens[widget.pageIndex ?? 0],
    );
  }
}
