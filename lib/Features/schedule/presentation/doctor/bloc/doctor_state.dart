// doctor_state.dart
import 'package:mobile_app_2/Features/schedule/domain/entites.dart';

abstract class DoctorState {}

class DoctorLoading extends DoctorState {}
class DoctorLoaded extends DoctorState {
  final DoctorEntity doctor;
  DoctorLoaded(this.doctor);
}
class DoctorError extends DoctorState {
  final String message;
  DoctorError(this.message);
}