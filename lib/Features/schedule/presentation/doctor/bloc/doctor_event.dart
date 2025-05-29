// doctor_event.dart
abstract class DoctorEvent {}

class FetchDoctorById extends DoctorEvent {
  final int id;
  FetchDoctorById(this.id);
}