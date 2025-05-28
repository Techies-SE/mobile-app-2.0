// features/auth/presentation/pages/login.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_2/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mobile_app_2/Features/auth/presentation/bloc/auth_event.dart';
import 'package:mobile_app_2/Features/auth/presentation/bloc/auth_state.dart';
import 'package:mobile_app_2/app/presentation/screens/main_navi_bar.dart';
import 'package:mobile_app_2/app/presentation/screens/otp_screen.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _onLoginPressed() {
    final phoneNo = phoneController.text.trim();
    final password = passwordController.text.trim();
    context
        .read<AuthBloc>()
        .add(LoginRequest(phone_no: phoneNo, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoginSuccess) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text('Login Successful: ${state.token}')),
              // );
              if (state.authEntity.firstTimeLogin == false) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainNaviBar()),
                  (route) => false,
                );
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OtpScreen()));
              }
            } else if (state is AuthFail) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login Failed: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            // return Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     TextField(
            //       controller: phoneController,
            //       decoration: const InputDecoration(labelText: 'Phone Number'),
            //     ),
            //     const SizedBox(height: 16),
            //     TextField(
            //       controller: passwordController,
            //       decoration: const InputDecoration(labelText: 'Password'),
            //       obscureText: true,
            //     ),
            //     const SizedBox(height: 24),
            //     state is AuthLoading
            //         ? const CircularProgressIndicator()
            //         : ElevatedButton(
            //             onPressed: () async {
            //               final prefs = await SharedPreferences.getInstance();
            //               await prefs.setBool('first_time', true);
            //             },
            //             child: const Text('Login'),
            //           ),
            //   ],
            // );
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Spacer(
                      flex: 3,
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      width: 110,
                      height: 110,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'MFU',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: mainBgColor,
                        ),
                        children: [
                          TextSpan(
                            text: ' Wellness Center',
                            style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffC0B257),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      width: 339,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xffD9F2EF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Phone Number',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 13),
                          width: 339,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xffD9F2EF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(0.76, 0),
                          child: GestureDetector(
                            child: Text(
                              'Forget password?',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    TextButton(
                      // onPressed: () async {
                      //   final prefs = await SharedPreferences.getInstance();
                      //   await prefs.setBool('first_time', true);
                      // },
                      onPressed: _onLoginPressed,
                      style: TextButton.styleFrom(
                        minimumSize: Size(339, 64),
                        backgroundColor: mainBgColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: state is AuthLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Login',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    Spacer(
                      flex: 3,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
