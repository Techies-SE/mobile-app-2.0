import 'package:mobile_app_2/Features/appointment/domain/entities/appointment_entity.dart';

abstract class AppointmentRepo {
  Future<List<AppointmentEntity>> fetchAppointmentByUserId();

  Future<void> requestAppointment(
    int doctorId,
    String time,
    String date,
    String? note,
  );

  Future<void> rescheduledAppointment(
    int patientId,
    int doctorId,
    int appointmentId,
    String time,
    String date,
    String note,
  );

  Future<void> confirmRescheduledAppoinment(
    int appointmentId,
  );

   Future<void> cancelRescheduledAppoinment(
    int appointmentId,
  );
}
