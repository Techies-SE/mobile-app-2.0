abstract class AppointmentsRemoteData {
  Future<dynamic> fetchAppointmentByUserId();
  Future<void> requestAppointment(
    int doctorId,
    String time,
    String date,
    String? note,
  );
  Future<void> rescheduledAppointment(
    int patientId,
    int appointmentId,
    int doctorId,
    String time,
    String date,
    String note,
  );
  Future<void> confirmReschsduledAppointment(
    int appointmentId,
  );
}
