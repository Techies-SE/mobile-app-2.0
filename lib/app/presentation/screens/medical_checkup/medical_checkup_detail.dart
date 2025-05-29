// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_2/app/utilities/api_service.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

class MedicalCheckupDetail extends StatefulWidget {
  const MedicalCheckupDetail({
    super.key,
    required this.title,
    required this.time, required this.lab_test_id,
  });

  final String title;
  final String time;
  final int lab_test_id;



  @override
  State<MedicalCheckupDetail> createState() => _MedicalCheckupDetailState();
}

class _MedicalCheckupDetailState extends State<MedicalCheckupDetail> {

  bool? isLoading;
  List<dynamic> labItems = [];
  
  Future<void> _fetchLabResults() async {
    //final generalService = Provider.of<GeneralService>(context, listen: false);
    try {
      setState(() {
        isLoading = true;
      });
      final response = await ApiService().get(
          'patients/lab-tests/${widget.lab_test_id}/lab-test-items');
      //print('it is above the if');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // print('it is in the if');
        final data = json.decode(response.body);
        setState(() {
          labItems = data['data'];
          
          print('Lab Test: $labItems');
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
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLabResults();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: appbarTestStyle,
        ),
      ),
      body: isLoading == true?
      Center(
              child: CircularProgressIndicator(),
            ):
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.time,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Flexible(
                child: ListView.separated(
                  separatorBuilder:(context, index) => SizedBox(height: 10,),
                  itemCount: labItems.length,
                  itemBuilder: (context, index) {
                    final labItemDetail = labItems[index];
                    return Card(
                      //color: Color(0xffE6F6F4),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                 labItemDetail['lab_item_name'],
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  'Your Value',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff595959),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  'Normal Range',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff595959),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                   labItemDetail['lab_item_status']??'-',
                                    style: GoogleFonts.poppins(
                                    
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: mainBgColor),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  '${labItemDetail['lab_item_value'] ?? '-'} ${labItemDetail['unit']??'-'}',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff595959),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  labItemDetail['normal_range'] ?? '-',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff595959),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
