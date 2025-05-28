import 'package:mobile_app_2/Features/appointment/domain/repositorioes/appointment_repo.dart';

class RescheduleAppointment {
  final AppointmentRepo repo;
  RescheduleAppointment(this.repo);

  Future<void> call(
    int patientId,
    int doctorId,
    int appointmentId,
    String time,
    String date,
    String note,
  ) async {
    repo.rescheduledAppointment(
      patientId,
      doctorId,
      appointmentId,
      time,
      date,
      note,
    );
  }
}
