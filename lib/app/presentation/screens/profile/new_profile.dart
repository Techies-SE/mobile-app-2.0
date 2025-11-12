import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_2/Features/auth/data/datasources/local/auth_local_data_source_impl.dart';
import 'package:mobile_app_2/Features/auth/presentation/screens/login.dart';
import 'package:mobile_app_2/Features/patient/data/models/patient_model.dart';
import 'package:mobile_app_2/Features/patient/domain/entities/patient_entity.dart';
import 'package:mobile_app_2/Features/patient/presentaion/bloc/patient_cubit.dart';
import 'package:mobile_app_2/Features/patient/presentaion/bloc/patient_state.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';
import 'package:http/http.dart' as http;

class NewProfile extends StatefulWidget {
  const NewProfile({super.key});

  @override
  State<NewProfile> createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  bool onEditMode = false;
  final bloodTypeController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final bmiController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      context.read<PatientCubit>().getPatientInfo();
    });
  }

  Future<void> saveEditedProfile(
      String hmNumber, PatitentEntity patient) async {
    try {
      final token = await AuthLocalDataSourceImpl().getToken();
      final response = await http.put(
          Uri.parse('https://backend-pg-cm2b.onrender.com/patients/$hmNumber'),
          headers: {
            "Content-Type": "application/json",
            if (token != null) "Authorization": "Bearer $token"
          },
          body: jsonEncode({
            'name': patient.name,
            'citizen_id': patient.citizen_id,
            'phone_no': patient.phone_no,
            'gender': patient.gender,
            'blood_type': bloodTypeController.text,
            'age': int.parse(ageController.text),
            'date_of_birth': patient.date_of_birth,
            'weight': weightController.text,
            'height': heightController.text,
            'bmi': bmiController.text,
          }));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final body = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${body['message']}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating!'),
          ),
        );
      }
    } catch (e) {
      throw Exception('Cannot update the data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'Profile',
          style: appbarTestStyle,
        ),
      ),
      body: BlocBuilder<PatientCubit, PatientState>(
        builder: (context, state) {
          if (state is PatientFetching) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is PatientFetchedSuccess) {
            DateFormat formatter = DateFormat('MMMM d, yyyy');
            DateTime bDate = DateTime.parse(state.patient.date_of_birth);
            String formattedDate = formatter.format(bDate);
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile avatar
                  Row(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Color(0xffD9F2EF),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: mainBgColor,
                                  width: 2.0,
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                color: mainBgColor,
                                size: 60,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: mainBgColor,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name card
                          Text(
                            state.patient.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          SizedBox(height: 6),
                          Text(
                            "Patient",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 24),
                  // Contact information card
                  Text(
                    "Contact Information",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: mainBgColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoItem(
                            Icons.badge,
                            "Hospital Number",
                            state.patient.hn_number,
                          ),
                          Divider(height: 24),
                          _buildInfoItem(
                            CupertinoIcons.phone_fill,
                            "Phone Number",
                            state.patient.phone_no,
                          ),
                          Divider(height: 24),
                          _buildInfoItem(
                            Icons.credit_card,
                            "Citizen ID",
                            state.patient.citizen_id,
                          ),
                          Divider(height: 24),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  // Contact information card
                  Text(
                    "Health Information",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: mainBgColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoItem(
                            CupertinoIcons.calendar_badge_plus,
                            "Date of Birth",
                            formattedDate,
                          ),
                          Divider(height: 24),
                          _buildInfoItem(
                            Icons.transgender,
                            "Gender",
                            state.patient.gender,
                          ),
                          Divider(height: 24),
                          onEditMode
                              ? _editInfoItem(
                                  Icons.bloodtype,
                                  "Blood Type",
                                  state.patient.blood_type,
                                  bloodTypeController,
                                )
                              : _buildInfoItem(
                                  Icons.bloodtype,
                                  "Blood Type",
                                  state.patient.blood_type,
                                ),
                          Divider(height: 24),
                          onEditMode
                              ? _editInfoItem(
                                  Icons.person,
                                  "Age",
                                  '${state.patient.age}',
                                  ageController,
                                )
                              : _buildInfoItem(
                                  Icons.person,
                                  "Age",
                                  '${state.patient.age}',
                                ),
                          Divider(height: 24),
                          onEditMode
                              ? _editInfoItem(
                                  Icons.monitor_weight,
                                  "Weight",
                                  ' ${state.patient.weight}',
                                  weightController,
                                )
                              : _buildInfoItem(
                                  Icons.monitor_weight,
                                  "Weight",
                                  '${state.patient.weight}',
                                ),
                          Divider(height: 24),
                          onEditMode
                              ? _editInfoItem(
                                  Icons.height,
                                  "Height",
                                  '${state.patient.height}',
                                  heightController,
                                )
                              : _buildInfoItem(
                                  Icons.height,
                                  "Height",
                                  '${state.patient.height}',
                                ),
                          Divider(height: 24),
                          onEditMode
                              ? _editInfoItem(
                                  Icons.scale,
                                  "BMI",
                                  '${state.patient.bmi}',
                                  bmiController,
                                )
                              : _buildInfoItem(
                                  Icons.scale,
                                  "BMI",
                                  '${state.patient.bmi}',
                                ),
                          Divider(height: 24),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  //Update button
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton.icon(
                  //     onPressed: () async {
                  //       if (onEditMode) {
                  //         await saveEditedProfile(
                  //           state.patient.hn_number,
                  //           state.patient,
                  //         );
                  //         context.read<PatientCubit>().getPatientInfo();
                  //       }
                  //       setState(() {
                  //         onEditMode = !onEditMode;
                  //       });
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: mainBgColor,
                  //       foregroundColor: Colors.white,
                  //       padding: EdgeInsets.symmetric(vertical: 15),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //       elevation: 2,
                  //     ),
                  //     // icon: Icon(Icons.edit),
                  //     label: Text(
                  //       onEditMode ? 'Save Profile' : 'Update Profile',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await AuthLocalDataSourceImpl().deleteToken();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                       backgroundColor: mainBgColor,
                       foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      // icon: Icon(Icons.edit),
                      label: Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is PatientFetchchedFailed) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Oops! ${state.error}'),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await context.read<PatientCubit>().getPatientInfo();
                    },
                    child: Text('Try Again'),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

Widget _buildInfoItem(IconData icon, String title, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xffD9F2EF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: mainBgColor,
          size: 40,
        ),
      ),
      SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _editInfoItem(IconData icon, String title, String value,
    TextEditingController controller) {
  controller.text = value;
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xffD9F2EF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: mainBgColor,
          size: 40,
        ),
      ),
      SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            TextFormField(
              controller: controller,
            ),
          ],
        ),
      ),
    ],
  );
}
