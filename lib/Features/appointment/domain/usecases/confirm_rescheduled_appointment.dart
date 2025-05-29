import 'package:mobile_app_2/Features/appointment/domain/repositorioes/appointment_repo.dart';

class ConfirmRescheduledAppointment {
  final AppointmentRepo repo;

  ConfirmRescheduledAppointment(this.repo);

  Future<void> call(int appointmentId) async {
    await repo.confirmRescheduledAppoinment(appointmentId);
  }
}
