abstract class PatientLocalData {
  Future<void> savePatientId(String patientId);
  Future<String?> getPatientId();
  Future<void> deletePatientId();
}
