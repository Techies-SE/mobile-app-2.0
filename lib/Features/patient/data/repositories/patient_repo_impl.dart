import 'package:mobile_app_2/Features/patient/data/datasources/local/patient_local_data.dart';
import 'package:mobile_app_2/Features/patient/data/datasources/remote/patient_remote_data.dart';
import 'package:mobile_app_2/Features/patient/data/models/patient_model.dart';
import 'package:mobile_app_2/Features/patient/domain/entities/patient_entity.dart';
import 'package:mobile_app_2/Features/patient/domain/respositories/patient_repo.dart';

class PatientRepoImpl implements PatientRepo {
  final PatientRemoteData patientRemoteData;
  final PatientLocalData patientLocalData;

  PatientRepoImpl(this.patientLocalData, this.patientRemoteData);
  @override
  Future<PatitentEntity> getPatientInfo() async {
    final json = await patientRemoteData.getPatientInfo();
    final patientModel = PatientModel.fromJson(json);
    final patientEntity = patientModel.toEntity();
    patientLocalData.savePatientId(patientModel.hn_number);
    return patientEntity;
  }
}
