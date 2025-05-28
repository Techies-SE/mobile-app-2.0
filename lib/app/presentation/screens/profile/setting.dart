import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_2/Features/auth/presentation/screens/change_password.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool getNoti = false;
  @override
  Widget build(BuildContext context) {
    //final profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'Setting',
          style: appbarTestStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xffE5E7EB),
                    child: Icon(
                      CupertinoIcons.bell,
                      color: mainBgColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Color(0xff404040),
                          ),
                        ),
                        Text(
                          'You won’t get any push notification on all of your devices when disabled.',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Color(0xff595959),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Switch(
                    activeColor: Color(0xffE5E7EB),
                    activeTrackColor: mainBgColor,
                    inactiveThumbColor: Color(0xffE5E7EB),
                    inactiveTrackColor: Color(0xffB9C0C9),
                    trackOutlineWidth: WidgetStatePropertyAll(0),
                    value: true,
                    onChanged: (value) {
                      
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xffE5E7EB),
                    child: Icon(
                      Icons.language,
                      color: mainBgColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text('Language'),
                  ),
                  
                  Text('English'),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      _showLanguageBottomSheet(context);
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: mainBgColor,
                      size: 25,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xffE5E7EB),
                    child: Icon(
                      Icons.lock,
                      color: mainBgColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text('Change Password'),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePassword(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: mainBgColor,
                      size: 25,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    // bool isEnglish = true;
    // bool isThai = false;
    showModalBottomSheet(
      context: context,
      builder: (context) {
    
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffB9C0C9),
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      // setModalState(() {
                      //   isEnglish = true;
                      //   isThai = false;
                      // });
                     // profileProvider.setLanguage(0);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('English'),
                        SizedBox(
                          width: 10,
                        ),
                        // isEnglish == true
                        // profileProvider.language == 0
                        //     ? Icon(Icons.check)
                        //     : SizedBox(
                        //         width: 23,
                        //       )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // setModalState(() {
                      //   isEnglish = false;
                      //   isThai = true;
                      // });
                     // profileProvider.setLanguage(1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Thai'),
                        SizedBox(
                          width: 10,
                        ),
                        // isThai == true
                        //profileProvider.language == 1
                        //     ? Icon(Icons.check)
                        //     : SizedBox(
                        //         width: 25,
                        //       ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
