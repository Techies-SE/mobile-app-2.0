import 'package:mobile_app_2/Features/appointment/domain/repositorioes/appointment_repo.dart';

class RequestAppointment {
  final AppointmentRepo repo;
  RequestAppointment(this.repo);

  Future<void> call(int doctorId, String date, String time,
      String? note) async {
    await repo.requestAppointment( doctorId, time, date, note);
  }
}
