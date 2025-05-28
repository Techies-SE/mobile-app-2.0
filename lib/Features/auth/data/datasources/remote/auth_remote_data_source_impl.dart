// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_app_2/Features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:mobile_app_2/app/utilities/api_service.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<dynamic> logIn(
    String phone_no,
    String password,
  ) async {
    try {
      String url = 'https://backend-pg-cm2b.onrender.com/login/patients';
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone_no": phone_no, "password": password}),
      );
      if (response.statusCode >= 200 || response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Fail log in');
      }
    } catch (e) {
      throw Exception('Fail fetching API');
    }
  }

  @override
  Future<void> ChangePassword(String password) async {
    try {
      final response = await ApiService().post(
        'login/patients/change-password',
        {"password": password},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        //print('Chnaged Password');
      } else {
       // print('Fail change password ${response.statusCode}');
        throw Exception('Fail log in');
      }
    } catch (e) {
      //print('Fail API $e');
      throw Exception('Fail fetching API');
    }
  }
}
