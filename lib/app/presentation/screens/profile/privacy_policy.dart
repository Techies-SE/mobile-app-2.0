import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';


class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'Privacy Policy',
          style: appbarTestStyle,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            text:
                'Lorem ipsum dolor sit amet consectetur. Rhoncus vel turpis in imperdiet. Et aliquam urna nisi risus.Vitae donec convallis integer eget. Magna volutpat lobortis lacus consectetur eu tortor senectus.',
            style: GoogleFonts.poppins(
              color: Color(0xff404040),
            ),
            children: [
              TextSpan(
                  text:
                      '\n\nLorem ipsum dolor sit amet consectetur. Rhoncus vel turpis in imperdiet. Et aliquam urna nisi risus.Vitae donec convallis integer eget. Magna volutpat lobortis lacus consectetur eu tortor senectus.'),
              TextSpan(
                text: '\n\nTerms & Conditions',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(
                    0xff231F20,
                  ),
                ),
              ),
              TextSpan(
                  text:
                      '\n\nLorem ipsum dolor sit amet consectetur. Rhoncus vel turpis in imperdiet. Et aliquam urna nisi risus.Vitae donec convallis integer eget. Magna volutpat lobortis lacus consectetur eu tortor senectus.'),
              TextSpan(
                text:
                    '\n\nLorem ipsum dolor sit amet consectetur. Rhoncus vel turpis in imperdiet. Et aliquam urna nisi risus.Vitae donec convallis integer eget. Magna volutpat lobortis lacus consectetur eu tortor senectus.',
              )
            ],
          ),
        ),
      ),
    );
  }
}
