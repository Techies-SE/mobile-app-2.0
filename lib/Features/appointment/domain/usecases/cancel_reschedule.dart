import 'package:mobile_app_2/Features/appointment/domain/repositorioes/appointment_repo.dart';

class CancelReschedule {
  final AppointmentRepo repo;
  CancelReschedule(this.repo);

  Future<void> call(int appointmentId) async {
    await repo.cancelRescheduledAppoinment(appointmentId);
  }
}
