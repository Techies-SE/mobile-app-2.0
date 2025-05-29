import 'dart:convert';

import 'package:mobile_app_2/Features/appointment/data/datasources/remote/appointments_remote_data.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app_2/Features/auth/data/datasources/local/auth_local_data_source_impl.dart';
import 'package:mobile_app_2/app/utilities/api_service.dart';

class AppointmentRemoteDataImpl implements AppointmentsRemoteData {
  @override
  Future<List<dynamic>> fetchAppointmentByUserId() async {
    try {
      final response = await ApiService().get('patients/appointments');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);
        return data['appointments'];
      } else {
        throw Exception('API error ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fail to fecth appointment $e');
    }
  }

  @override
  Future<void> confirmRescheduledAppointment(int appointmentId) async {
    try {
      final response = await ApiService()
          .put('patients/appointments/$appointmentId/confirm', {});
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        throw Exception('Fail api ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fail api $e');
    }
  }

  @override
  Future<void> cancelRescheduledAppointment(int appointmentId) async{
    try {
      final response = await ApiService()
          .put('patients/appointments/$appointmentId/cancel', {});
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        throw Exception('Fail api ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fail api $e');
    }
  }

  @override
  Future<void> requestAppointment(
    int doctorId,
    String time,
    String date,
    String? note,
  ) async {
    try {
      final response =
          await ApiService().post('patients/appointments/confirmation', {
        'doctor_id': doctorId,
        'appointment_time': time,
        'appointment_date': date,
        'notes': note
      });
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
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
