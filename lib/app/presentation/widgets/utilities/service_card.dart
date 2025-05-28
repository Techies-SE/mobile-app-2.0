import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.image,
    required this.service,
  });

  final String image;
  final String service;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Image.asset(
              image,
              width: 60,
              height: 60,
            ),
            SizedBox(
              height: 19,
            ),
            Text(
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              service,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
