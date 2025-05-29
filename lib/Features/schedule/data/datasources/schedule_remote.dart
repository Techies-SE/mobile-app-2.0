// department_remote_data_source.dart
abstract class DepartmentRemoteDataSource {
  Future<List<dynamic>> fetchAllDepartments();
  Future<Map<String, dynamic>> fetchDepartmentById(int id);
}

// doctor_remote_data_source.dart
abstract class DoctorRemoteDataSource {
  Future<Map<String, dynamic>> fetchDoctorById(int id);
}