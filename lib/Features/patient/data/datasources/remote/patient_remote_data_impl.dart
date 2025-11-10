import 'dart:convert';
import 'package:mobile_app_2/Features/patient/data/datasources/remote/patient_remote_data.dart';
import 'package:mobile_app_2/app/utilities/api_service.dart';

class PatientRemoteDataImpl implements PatientRemoteData {
  @override
  Future<dynamic> getPatientInfo() async {
    try {
      final response = await ApiService().get('patients/profile');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);
        print(data);
        final user = data['user'];
        return user;
      } else {
        throw Exception('Error in fetching ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fail to fetch the api');
    }
  }
}
