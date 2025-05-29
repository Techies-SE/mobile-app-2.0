import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_2/app/presentation/screens/profile/help.dart';
import 'package:mobile_app_2/app/presentation/screens/profile/privacy_policy.dart';
import 'package:mobile_app_2/app/presentation/screens/profile/profile_detail.dart';
import 'package:mobile_app_2/app/presentation/screens/profile/setting.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            ListTiles(
              icon: Icons.person_outlined,
              title: 'Profile',
              function: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileDetail()));
              },
            ),
            SizedBox(
              height: 40,
            ),
            ListTiles(
              icon: CupertinoIcons.book,
              title: 'Privacy Policy',
              function: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicy()));
              },
            ),
            SizedBox(
              height: 40,
            ),
            ListTiles(
              icon: CupertinoIcons.question_circle,
              title: 'Help',
              function: () {
                 Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Help()));
              },
            ),
            SizedBox(
              height: 40,
            ),
            ListTiles(
              icon: Icons.settings,
              title: 'Setting',
              function: () {
                 Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Setting()));
              },
            ),
            SizedBox(
              height: 40,
            ),
            ListTiles(
              icon: Icons.logout,
              title: 'Log out',
              function: () {},
            )
          ],
        ),
      ),
    );
  }
}

class ListTiles extends StatelessWidget {
  const ListTiles({
    super.key,
    required this.icon,
    required this.title,
    required this.function,
  });

  final IconData icon;
  final String title;
  final void Function() function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: cancelButtonColor,
        child: Icon(
          icon,
          size: 22,
          color: mainBgColor,
        ),
      ),
      title: Text(title),
      trailing: IconButton(
        onPressed: function,
        icon: Icon(
          CupertinoIcons.right_chevron,
          size: 28,
          color: mainBgColor,
        ),
      ),
    );
  }
}
