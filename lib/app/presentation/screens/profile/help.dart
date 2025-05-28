import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';


class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'Help',
          style: appbarTestStyle,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Contact us using contact details below.',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color(0xff404040),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xffE5E7EB),
                  child: Icon(
                    Icons.phone,
                    color: mainBgColor,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone number',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '082-8837710. 082-8837710. 082-8837710',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Color(0xff595959),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xffE5E7EB),
                  child: Icon(
                    Icons.email_outlined,
                    color: mainBgColor,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'mfumedicalcenter@mfu.ac.th',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Color(0xff595959),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
