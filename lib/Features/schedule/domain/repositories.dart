// department_repository.dart
import 'package:mobile_app_2/Features/schedule/domain/entites.dart';

abstract class DepartmentRepository {
  Future<List<DepartmentEntity>> fetchAllDepartments();
  Future<DepartmentEntity> fetchDepartmentById(int id);
}

// doctor_repository.dart
abstract class DoctorRepository {
  Future<DoctorEntity> fetchDoctorById(int id);
}