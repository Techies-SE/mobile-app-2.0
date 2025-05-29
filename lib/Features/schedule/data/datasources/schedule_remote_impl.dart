import 'dart:convert';
import 'package:mobile_app_2/Features/schedule/data/datasources/schedule_remote.dart';
import 'package:mobile_app_2/app/utilities/api_service.dart';

class ScheduleRemoteImpl implements DepartmentRemoteDataSource, DoctorRemoteDataSource {
  @override
  Future<List<dynamic>> fetchAllDepartments() async {
    try {
      final response = await ApiService().get('departments');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      }else{
         throw Exception('fail fetching ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('fail api $e');
    }
  }

  @override
  Future<Map<String, dynamic>> fetchDepartmentById(int id) async{
    try {
      final response = await ApiService().get('departments/id=$id');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      }else{
         throw Exception('fail fetching ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('fail api $e');
    }
  }

  @override
  Future<Map<String, dynamic>> fetchDoctorById(int id) async{
     try {
      final response = await ApiService().get('schedule/doctor/$id');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      }else{
         throw Exception('fail fetching ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('fail api $e');
    }
  }
}
