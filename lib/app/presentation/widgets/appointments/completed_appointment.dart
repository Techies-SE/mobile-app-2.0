// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

class CompletedAppointment extends StatelessWidget {
  final String doctor;
  final int doctor_id;
  final String specialization;
  final String date;
  final String time;
  final String status;
  const CompletedAppointment({
    super.key,
    required this.doctor,
    required this.doctor_id,
    required this.specialization,
    required this.date,
    required this.time,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
   final appointmentDate = DateFormat('MMM d, y').format(DateTime.parse(date));
    final appointmentTime = DateFormat('h:mm a').format(
      DateFormat('HH:mm:ss').parse(time.split('.')[0]),
    );
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(
          color: mainBgColor,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ClipOval(
                //   child: Image.asset(
                //     'assets/images/doctorPic.png',
                //     width: 32,
                //     height: 32,
                //   ),
                // ),
                // SizedBox(
                //   width: 10,
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: textColor,
                      ),
                    ),
                   
                    Text(
                      specialization,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: textColorSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xffA9E8FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color:Color(0xff043778),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
           
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: textColorSecondary,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      appointmentDate,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: textColorSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10,),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.time,
                      size: 20,
                      color: textColorSecondary,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      appointmentTime,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: textColorSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
