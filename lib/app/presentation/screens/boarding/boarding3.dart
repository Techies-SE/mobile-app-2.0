import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

class Boarding3 extends StatelessWidget {
  const Boarding3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            'assets/images/boarding3.png',
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
                'Get Recommendation',
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
                  'Get Ai recommendations along with personalized notes from your '
                  'doctor based on your symptoms and medical history.',
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
