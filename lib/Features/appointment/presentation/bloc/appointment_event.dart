abstract class AppointmentEvent {}

class FetchAppointmentByUserIdEvent extends AppointmentEvent {}

class ConfirmRescheduledAppointmentEvent extends AppointmentEvent {
  final int appointmentId;
  ConfirmRescheduledAppointmentEvent({required this.appointmentId});
}

class RequestAppointmentEvent extends AppointmentEvent {
  final int patientId;
  final int doctorId;
  final String time;
  final String date;
  final String note;
  RequestAppointmentEvent({
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.note,
  });
}

class RescheduledAppointmentEvent extends AppointmentEvent {
  final int patientId;
  final int appointmentId;
  final int doctorId;
  final String time;
  final String date;
  final String note;
  RescheduledAppointmentEvent({
    required this.patientId,
    required this.appointmentId,
    required this.doctorId,
    required this.time,
    required this.date,
    required this.note,
  });
}
