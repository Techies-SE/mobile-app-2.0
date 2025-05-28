import 'package:mobile_app_2/Features/auth/data/datasources/local/auth_local_data_source_impl.dart';
import 'package:mobile_app_2/Features/patient/data/datasources/remote/patient_remote_data.dart';
import 'package:http/http.dart' as http;

class PatientRemoteDataImpl implements PatientRemoteData {
  @override
  Future<dynamic> getPatientInfo() async {
    try {
      final data = AuthLocalDataSourceImpl();
      final token = data.getToken();
      String url = '';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authentication': 'Bearer $token'
        },
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body;
      } else {
        throw Exception('Error in fetching ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fail to fetch the api');
    }
  }
}
