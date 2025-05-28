import 'package:mobile_app_2/Features/patient/data/datasources/local/patient_local_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientLocalDataImpl implements PatientLocalData {
  @override
  Future<void> savePatientId(String patientId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('patient_id', patientId);
  }

  @override
  Future<String?> getPatientId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('patient_id');
  }

  @override
  Future<void> deletePatientId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('patient_id');
  }
}
