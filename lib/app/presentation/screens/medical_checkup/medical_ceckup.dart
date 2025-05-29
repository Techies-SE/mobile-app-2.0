import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_2/app/presentation/screens/medical_checkup/medical_checkup_detail.dart';
import 'package:mobile_app_2/app/utilities/api_service.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

class MedicalCheckup extends StatefulWidget {
  const MedicalCheckup({super.key});

  @override
  State<MedicalCheckup> createState() => _MedicalCheckupState();
}

class _MedicalCheckupState extends State<MedicalCheckup> {
  List<dynamic> labTests = [];
  bool? isLoading;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLabResults();
    });
  }

  Future<void> _fetchLabResults() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await ApiService().get('patients/lab-tests');
      //print('it is above the if');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // print('it is in the if');
        final data = json.decode(response.body);
        setState(() {
          labTests = data['data'];
          //generalService.setRecommendation(labTests);
          //print('Lab Test: $labTests');
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('Error $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Medical Checkup',
          style: appbarTestStyle,
        ),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )

          : labTests.isEmpty? Center(
              child: Text('No Lab Tests yet'),
            ): Padding(
              padding: const EdgeInsets.only(
                top: 25,
                right: 28,
                left: 28,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '2025',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: textColorSecondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: labTests.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (context, index) {
                        final labTestDetail = labTests[index];
                        DateTime dateTime =
                            DateTime.parse(labTestDetail['lab_test_date']);
                        final DateFormat formatter = DateFormat('MMMM d, yyyy');
                        String labTestDate = formatter.format(dateTime);
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          tileColor: Colors.white,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                labTestDetail['test_name'],
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                labTestDate,
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.chevron_right_outlined),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicalCheckupDetail(
                                  title: labTestDetail['test_name'],
                                  lab_test_id: labTestDetail['lab_test_id'],
                                  time: labTestDate,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
