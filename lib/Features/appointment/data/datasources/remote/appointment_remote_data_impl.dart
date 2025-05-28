import 'package:mobile_app_2/Features/appointment/data/datasources/remote/appointments_remote_data.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app_2/Features/auth/data/datasources/local/auth_local_data_source_impl.dart';

class AppointmentRemoteDataImpl implements AppointmentsRemoteData {
  @override
  Future<dynamic> fetchAppointmentByUserId() async {
    try {
      String uri = '';
      final data = AuthLocalDataSourceImpl();
      final token = data.getToken();
      final response = await http.get(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body;
      } else {
        throw Exception('API error ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fail to fecth appointment $e');
    }
  }

  @override
  Future<void> requestAppointment(
    int patientId,
    int doctorId,
    String time,
    String date,
    String note,
  ) async {
    try {
      String uri = '';
      final data = AuthLocalDataSourceImpl();
      final token = data.getToken();
      final response = await http.post(Uri.parse(uri), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      }, body: {
        'patientId': patientId,
        'doctorId': doctorId,
        'time': time,
        'date': date,
        'note': note
      });
      if (response.statusCode >= 200 && response.statusCode < 300) {
      } else {
        throw Exception('API error ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fail to fecth appointment $e');
    }
  }

  @override
  Future<void> rescheduledAppointment(
    int patientId,
    int appointmentId,
    int doctorId,
    String time,
    String date,
    String note,
  ) async {
    try {
      String uri = '';
      final data = AuthLocalDataSourceImpl();
      final token = data.getToken();
      final response = await http.put(Uri.parse(uri), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      }, body: {
        'patientId': patientId,
        'appointmentId': appointmentId,
        'doctorId': doctorId,
        'time': time,
        'date': date,
        'note': note
      });
      if (response.statusCode >= 200 && response.statusCode < 300) {
      } else {
        throw Exception('API error ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fail to fecth appointment $e');
    }
  }
}
