import 'package:mobile_app_2/Features/patient/domain/entities/patient_entity.dart';
import 'package:mobile_app_2/Features/patient/domain/respositories/patient_repo.dart';

class GetPatientInfo {
  final PatientRepo repo;

  GetPatientInfo(this.repo);

  Future<PatitentEntity> call() async {
    return await repo.getPatientInfo();
  }
}
