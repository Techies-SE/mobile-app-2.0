import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_2/Features/auth/presentation/screens/change_password.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';


class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(),
            Text(
              'Enter verification code',
              style: GoogleFonts.poppins(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Code had been to your phone.',
              style: GoogleFonts.poppins(
                fontSize: 13,
              ),
            ),
            Spacer(),
            OtpTextField(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              margin: EdgeInsets.symmetric(horizontal: 0),
              fieldHeight: 60,
              fieldWidth: 46,
              numberOfFields: 6,
              enabledBorderColor: mainBgColor,
              focusedBorderColor: mainBgColor,
              fillColor: mainBgColor,
              cursorColor: Colors.black,
              showFieldAsBox: true,
            ),
            Spacer(),
            Text(
              'Don\'t get OTP code?',
              style: GoogleFonts.poppins(
                fontSize: 15,
              ),
            ),
            GestureDetector(
              child: Text(
                'Resend code.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: mainBgColor,
                ),
              ),
            ),
            Spacer(
              flex: 3,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePassword(),
                  ),
                );
              //    ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text('Otp success'),
              // ),);
              },
              style: TextButton.styleFrom(
                minimumSize: Size(339, 64),
                backgroundColor: mainBgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Verify',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
