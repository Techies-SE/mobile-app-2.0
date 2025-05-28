// ignore_for_file: non_constant_identifier_names

import 'package:mobile_app_2/Features/appointment/domain/entities/appointment_entity.dart';

class Appointment extends AppointmentEntity {
  Appointment(
    super.appointmentId,
    super.doctor_id,
    super.doctor,
    super.specialization,
    super.date,
    super.time,
    super.status, // Fixed typo from 'staus' to 'status'
  );

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      json['id'] as int,
      json['doctor_id'] as int,
      json['doctor'] as String,
      json['specialization'] as String,
      json['appointment_date'] as String,
      json['appointment_time'] as String,
      json['status'] as String,
    );
  }

  static List<Appointment> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Appointment.fromJson(json)).toList();
  }

  AppointmentEntity toEntity() => AppointmentEntity(
      appointmentId, doctor_id, doctor, specialization, date, time, status);
}