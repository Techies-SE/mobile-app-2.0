import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_2/Features/auth/presentation/screens/login.dart';
import 'package:mobile_app_2/app/presentation/screens/boarding/boarding1.dart';
import 'package:mobile_app_2/app/presentation/screens/boarding/boarding2.dart';
import 'package:mobile_app_2/app/presentation/screens/boarding/boarding3.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Boarding extends StatefulWidget {
  const Boarding({super.key});

  @override
  State<Boarding> createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Boarding> {
  final PageController _pageController = PageController();
  bool lastPage = false;

  Future<void> _completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('first_time', false);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error completing onboarding')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: NeverScrollableScrollPhysics(),
            allowImplicitScrolling: false,
            onPageChanged: (index) {
              if (index == 2) {
                setState(() {
                  lastPage = true;
                });
              }
            },
            controller: _pageController,
            children: [
              Boarding1(),
              Boarding2(),
              Boarding3(),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment(0, 0.5),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                    dotHeight: 11.31,
                    dotWidth: 11.31,
                    dotColor: Color(0xffE9F6FE),
                    activeDotColor: mainBgColor,
                  ),
                ),
              ),
              SizedBox(height: 80),
              lastPage == false
                  ? TextButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size(100, 50),
                        backgroundColor: mainBgColor,
                      ),
                      child: Text(
                        'Next',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : TextButton(
                      onPressed: _completeOnboarding,
                      style: TextButton.styleFrom(
                        minimumSize: Size(150, 50),
                        backgroundColor: mainBgColor,
                      ),
                      child: Text(
                        'Get Started',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
              SizedBox(height: 50),
            ],
          )
        ],
      ),
    );
  }
}
