import 'package:mobile_app_2/Features/patient/domain/entities/patient_entity.dart';

abstract class PatientRepo {
  //fetch patient data
  Future<PatitentEntity> getPatientInfo();
}
