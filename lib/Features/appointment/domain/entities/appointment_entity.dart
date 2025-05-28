// ignore_for_file: non_constant_identifier_names

class AppointmentEntity {
  int appointmentId;
  int doctor_id;
  String doctor;
  String specialization;
  String date;
  String time;
  String status;

  AppointmentEntity(
    this.appointmentId,
    this.doctor_id,
    this.doctor,
    this.specialization,
    this.date,
    this.time,
    this.status,
  );
}
