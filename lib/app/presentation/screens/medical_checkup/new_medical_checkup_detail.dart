import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_2/Features/auth/data/datasources/local/auth_local_data_source_impl.dart';
import 'package:mobile_app_2/app/presentation/screens/medical_checkup/lab_item_trend.dart';
import 'package:mobile_app_2/app/utilities/api_service.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

class NewMedicalCheckupDetail extends StatefulWidget {
  final String date;
  const NewMedicalCheckupDetail({super.key, required this.date});

  @override
  State<NewMedicalCheckupDetail> createState() =>
      _NewMedicalCheckupDetailState();
}

class _NewMedicalCheckupDetailState extends State<NewMedicalCheckupDetail> {
  bool isLoading = false;
  String date = '';
  List<dynamic> labTests = [];
  String doctor = '';
  String recommemdation = '';

  Future<void> fetchLabTestDetail() async {
    try {
      setState(() {
        isLoading = true;
      });
      final hnNumber = await AuthLocalDataSourceImpl().getHnNumber();
      final response =
          await ApiService().get('patients/lab-test/$hnNumber/${widget.date}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];
        setState(() {
          date = data['lab_test_date'];
          labTests = data['lab_tests'];
          doctor = labTests[0]['doctor_name'];
          recommemdation = labTests[0]['doctor_recommendation'] ?? 'Null';
        });
      } else {
        throw Exception('Error Fetching Data ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error Fetching Data $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLabTestDetail();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    if (date.isNotEmpty) {
      try {
        // Use .toLocal() as best practice since your API date is a UTC format (ISO 8601)
        DateTime dateTime = DateTime.parse(date).toLocal();
        DateFormat formatter = DateFormat('MMMM d, yyyy');
        formattedDate = formatter.format(dateTime);
      } catch (e) {
        // Handle case where the fetched string might still be malformed
        formattedDate = 'Invalid Date';
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Lab Test Details',
          style: appbarTestStyle,
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Test Summary',
                                style: GoogleFonts.inter(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Date of Test : $formattedDate',
                                style: GoogleFonts.inter(
                                  color: Colors.black54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Doctor : $doctor',
                                style: GoogleFonts.inter(
                                  color: Colors.black54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${labTests.length} Lab tests',
                                style: GoogleFonts.inter(
                                  color: Colors.black54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Doctor\'s Note',
                                style: GoogleFonts.inter(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              ...recommemdation
                                  .split('.')
                                  .where((line) => line.trim().isNotEmpty)
                                  .map((line) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 6.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '• ',
                                              style: GoogleFonts.inter(
                                                color: Colors.black54,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                line,
                                                style: GoogleFonts.inter(
                                                  color: Colors.black54,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                              // Text(
                              //   recommemdation,
                              //   style: GoogleFonts.inter(
                              //     color: Colors.black54,
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            String name = labTests[index]['test_name'];
                            List<dynamic> labItems =
                                labTests[index]['lab_items'];
                            return Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(height: 1),
                                    ...labItems.map(
                                      (item) => _buildLabItemRow(
                                        item as Map<String, dynamic>,
                                        context,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 20,
                            );
                          },
                          itemCount: labTests.length),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// Widget _buildLabItemRow(Map<String, dynamic> item) {
//   final name = item['lab_item_name'] as String? ?? 'N/A';
//   String value = item['lab_item_value']?.toString() ?? 'N/A';
//   final status = item['lab_item_status'] as String? ?? '';
//   final unit = item['unit'] as String? ?? '';
//   final normalRange = item['normal_range'] as String? ?? 'Not provided';

//   Color statusColor = Colors.black54;
//   FontWeight statusWeight = FontWeight.w500;
//   if (name == 'Gender' && value == '0') {
//     value = 'male';
//   } else if (name == 'Gender' && value == '1') {
//     value = 'male';
//   }

//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: GoogleFonts.inter(
//                     fontSize: 12,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 100,
//                   child: Text(
//                     'Range: $normalRange',
//                     style: GoogleFonts.inter(
//                       fontSize: 10,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               width: 100,
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   '$value $unit',
//                   textAlign: TextAlign.right,
//                   style: GoogleFonts.inter(
//                     fontSize: 12,
//                     fontWeight: statusWeight,
//                     color: statusColor,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 60,
//               child: Text(
//                 status,
//                 style: GoogleFonts.inter(
//                   fontSize: 12,
//                  color: Colors.black,
//                  fontWeight: FontWeight.w600
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         const Divider(height: 1),
//       ],
//     ),
//   );
// }

Widget _buildLabItemRow(Map<String, dynamic> item, BuildContext context) {
  final name = item['lab_item_name'] as String? ?? 'N/A';
  String value = item['lab_item_value']?.toString() ?? 'N/A';
  final status = item['lab_item_status'] as String? ?? '';
  final unit = item['unit'] as String? ?? '';
  final normalRange = item['normal_range'] as String? ?? 'Not provided';
  final int id = item['id'];

  // Handle Gender display
  if (name == 'Gender' && value == '0') {
    value = 'male';
  } else if (name == 'Gender' && value == '1') {
    value = 'female';
  }

  // Define status color based on the status value
  Color statusColor = Colors.black;

  final statusLower = status.toLowerCase().trim();

  if (statusLower == 'normal') {
    statusColor = Colors.green.shade700;
  } else if (statusLower == 'low') {
    statusColor = Colors.orange.shade600;
  } else if (statusLower == 'high') {
    statusColor = Colors.orange.shade800;
  } else if (statusLower == 'very high') {
    statusColor = Colors.red.shade700;
  } else if (statusLower == 'dangerously high') {
    statusColor = Colors.red.shade900;
  } else if (statusLower == 'stage 1') {
    statusColor = Colors.green.shade600;
  } else if (statusLower == 'stage 2') {
    statusColor = Colors.yellow.shade800;
  } else if (statusLower == 'stage 3') {
    statusColor = Colors.orange.shade700;
  } else if (statusLower == 'stage 4') {
    statusColor = Colors.red.shade700;
  } else if (statusLower == 'stage 5') {
    statusColor = Colors.red.shade900;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      children: [
        GestureDetector(
          onTap: () {
            // print(item);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LabItemTrend(
                  labTestName: name,
                  id: id,
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Range: $normalRange',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 100,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$value $unit',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Divider(height: 1),
      ],
    ),
  );
}
