import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';


class Boarding2 extends StatelessWidget {
  const Boarding2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return
        Stack(
          children: [
            SizedBox.expand(
          child: Image.asset(
            'assets/images/boarding2.png',
            fit: BoxFit.cover,
          ),
        ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(
                  flex: 2,
                ),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    'Schedule Appointment',
                    style: GoogleFonts.inter(
                      color: mainBgColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      textAlign: TextAlign.center,
                      'Book your doctor’s appointment in just a few taps. Choose your'
                      ' preferred date,time, and consultation type',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
              ],
                ),
          ],
        );
  }
}
