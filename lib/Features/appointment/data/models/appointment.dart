import 'package:mobile_app_2/Features/appointment/domain/entities/appointment_entity.dart';

class Appointment extends AppointmentEntity {
  Appointment(
    super.appointmentId,
    super.doctorId,
    super.date,
    super.time,
  );

  factory Appointment.fromJson(dynamic json) {
    return Appointment(
      json['appointmentId'],
      json['doctorId'],
      json['date'],
      json['time'],
    );
  }

  AppointmentEntity toEntity() =>
      AppointmentEntity(appointmentId, doctorId, date, time);
}
