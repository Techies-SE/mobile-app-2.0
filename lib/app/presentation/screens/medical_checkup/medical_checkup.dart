import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_2/app/presentation/screens/medical_checkup/new_medical_checkup_detail.dart';
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
      final response = await ApiService().get('patients/labtests');
      //print('it is above the if');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // print('it is in the if');
        final data = json.decode(response.body);
        setState(() {
          labTests = data['data'];
          //generalService.setRecommendation(labTests);
          print('Lab Test: $labTests');
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
          'Lab Test Results',
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
                  Expanded(
                    child: ListView.separated(
                      itemCount: labTests.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 24,
                      ),
                      itemBuilder: (context, index) {
                        final labTestDetail = labTests[index];
                        DateTime dateTime =
                            DateTime.parse(labTestDetail['lab_test_date']);
                        final DateFormat formatter = DateFormat('MMMM d, yyyy');
                        List<dynamic> labtests = labTestDetail['lab_tests'];
                        String labTestDate = formatter.format(dateTime);
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          tileColor: Colors.white,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                labTestDate,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Card(
                                color: const Color(0xffd9f8eb),
                                child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal:  8, vertical: 4),
                                child: Text('${labtests.length} tests', style: GoogleFonts.inter(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),),
                                ),
                              ),
                               SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Result analyzed by ${labtests[0]['doctor_name']}',
                                style: GoogleFonts.inter(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              
                            ],
                          ),
                          trailing: Icon(Icons.chevron_right_outlined),
                          onTap: () {
                            DateTime dateTime =
                            DateTime.parse(labTestDetail['lab_test_date']);
                            DateFormat formatter = DateFormat('yyyy-MM-dd');
                            String date = formatter.format(dateTime);
                            // print(date);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // builder: (context) => MedicalCheckupDetail(
                                //   title: labTestDetail['test_name'],
                                //   lab_test_id: labTestDetail['lab_test_id'],
                                //   time: labTestDate,
                                // ),
                                builder: (context) => NewMedicalCheckupDetail(date: date,),
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
