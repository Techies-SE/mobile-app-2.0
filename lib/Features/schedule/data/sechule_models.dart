// department_model.dart
import 'package:mobile_app_2/Features/schedule/domain/entites.dart';

class DepartmentModel extends DepartmentEntity {
  DepartmentModel({
    required super.id,
    required super.name,
    required super.doctors,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'],
      name: json['name'],
      doctors: (json['doctors'] as List)
          .map((doctor) => DoctorModel.fromJson(doctor))
          .toList(),
    );
  }
}

// doctor_model.dart
class DoctorModel extends DoctorEntity {
  DoctorModel({
    required super.id,
    required super.name,
    required super.phoneNo,
    required super.email,
    required super.specialization,
    required super.status,
    super.schedules,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'],
      phoneNo: json['phone_no'],
      email: json['email'],
      specialization: json['specialization'],
      status: json['status'],
      schedules: json['schedules'] != null
          ? (json['schedules'] as List)
              .map((schedule) => ScheduleModel.fromJson(schedule))
              .toList()
          : null,
    );
  }
}

// schedule_model.dart
class ScheduleModel extends ScheduleEntity {
  ScheduleModel({
    required super.scheduleId,
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      scheduleId: json['schedule_id'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}