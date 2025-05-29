// department_repository_impl.dart
import 'package:mobile_app_2/Features/schedule/data/datasources/schedule_remote.dart';
import 'package:mobile_app_2/Features/schedule/data/sechule_models.dart';
import 'package:mobile_app_2/Features/schedule/domain/entites.dart';
import 'package:mobile_app_2/Features/schedule/domain/repositories.dart';

class DepartmentRepositoryImpl implements DepartmentRepository {
  final DepartmentRemoteDataSource remoteDataSource;

  DepartmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<DepartmentEntity>> fetchAllDepartments() async {
    final response = await remoteDataSource.fetchAllDepartments();
    return response.map((json) => DepartmentModel.fromJson(json)).toList();
  }

  @override
  Future<DepartmentEntity> fetchDepartmentById(int id) async {
    final response = await remoteDataSource.fetchDepartmentById(id);
    return DepartmentModel.fromJson(response);
  }
}

// doctor_repository_impl.dart
class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;

  DoctorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DoctorEntity> fetchDoctorById(int id) async {
    final response = await remoteDataSource.fetchDoctorById(id);
    return DoctorModel.fromJson(response['doctor']);
  }
}