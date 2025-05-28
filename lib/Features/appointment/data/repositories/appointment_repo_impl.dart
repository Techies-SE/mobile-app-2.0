import 'package:mobile_app_2/Features/appointment/data/datasources/remote/appointments_remote_data.dart';
import 'package:mobile_app_2/Features/appointment/data/models/appointment.dart';
import 'package:mobile_app_2/Features/appointment/domain/entities/appointment_entity.dart';
import 'package:mobile_app_2/Features/appointment/domain/repositorioes/appointment_repo.dart';

class AppointmentRepoImpl implements AppointmentRepo {
  final AppointmentsRemoteData appointmentRemoteData;

  AppointmentRepoImpl({required this.appointmentRemoteData});

  @override
  Future<AppointmentEntity> fetchAppointmentByUserId() async {
    final json = await appointmentRemoteData.fetchAppointmentByUserId();
    final appointment = Appointment.fromJson(json);
    final appointmentEntity = appointment.toEntity();

    return appointmentEntity;
  }

  @override
  Future<void> requestAppointment(
    int patientId,
    int doctorId,
    String time,
    String date,
    String note,
  ) async {
    await appointmentRemoteData.requestAppointment(
      patientId,
      doctorId,
      time,
      date,
      note,
    );
  }

  @override
  Future<void> rescheduledAppointment(
    int patientId,
    int doctorId,
    int appointmentId,
    String time,
    String date,
    String note,
  ) async {
    await appointmentRemoteData.rescheduledAppointment(
      patientId,
      appointmentId,
      doctorId,
      time,
      date,
      note,
    );
  }
}
