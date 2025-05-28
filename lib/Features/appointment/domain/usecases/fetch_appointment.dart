import 'package:mobile_app_2/Features/appointment/domain/entities/appointment_entity.dart';
import 'package:mobile_app_2/Features/appointment/domain/repositorioes/appointment_repo.dart';

class FetchAppointment {
  final AppointmentRepo appointmentRepo;

  FetchAppointment(this.appointmentRepo);

  Future<AppointmentEntity> call() async {
    return await appointmentRepo.fetchAppointmentByUserId();
  }
}
