import 'package:flutter/material.dart';
import 'package:mobile_app_2/Features/auth/data/datasources/local/auth_local_data_source_impl.dart';
import 'package:mobile_app_2/Features/auth/presentation/screens/login.dart';
import 'package:mobile_app_2/app/presentation/screens/boarding/boarding.dart';
import 'package:mobile_app_2/app/presentation/screens/main_navi_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  bool? firstTimeUser; // Make it nullable to handle initial state
  late Future<bool> isLoggedIn;

  Future<void> checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstTimeUser = prefs.getBool('first_time') ?? true; // Default to true for first time users
    });
  }

  Future<bool> _checkLoginStatus() async {
    final local = AuthLocalDataSourceImpl();
    final token = await local.getToken();
    return token != null;
  }

  @override
  void initState() {
    super.initState();
    isLoggedIn = _checkLoginStatus();
    checkFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking firstTimeUser
    if (firstTimeUser == null) {
      return Center(child: CircularProgressIndicator());
    }
    
    // Show onboarding for first time users
    if (firstTimeUser!) {
      return Boarding(); // Assuming this is your onboarding screen
    }
    
    // For returning users, check login status
    return FutureBuilder<bool>(
      future: isLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data!) {
          return LoginPage();
        } else if (snapshot.hasError) {
          return Center(child: Icon(Icons.error));
        } else {
          return LoginPage();
        }
      },
    );
  }
}
