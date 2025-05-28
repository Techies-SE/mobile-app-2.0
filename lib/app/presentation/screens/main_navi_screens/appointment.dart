import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_2/app/presentation/screens/appointment/all_category.dart';
import 'package:mobile_app_2/app/presentation/screens/appointment/cancelled.dart';
import 'package:mobile_app_2/app/presentation/screens/appointment/completed.dart';
import 'package:mobile_app_2/app/presentation/screens/appointment/upcoming.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Appointment',
            style: appbarTestStyle,
          ),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllCategories(),
                        ),
                      );
                    },
                    icon: Icon(
                      CupertinoIcons.plus,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Book New Appointment',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: mainBgColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                  ),
                ),
              ),
              Text(
                'My Bookings',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TabBar(
                //indicatorSize: TabBarIndicatorSize.tab,
                tabAlignment: TabAlignment.fill,
                indicatorColor: mainBgColor,
                labelColor: Colors.black,
                labelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelColor: textColorSecondary,
                tabs: [
                  Tab(
                    child: Text(
                      'Upcoming',
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Tab(
                    text: 'Completed',
                  ),
                  Tab(
                    text: 'Cancelled',
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Upcoming(),
                    Completed(),
                    Cancelled(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
