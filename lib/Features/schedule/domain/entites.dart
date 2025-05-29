// department_entity.dart
class DepartmentEntity {
  final int id;
  final String name;
  final List<DoctorEntity> doctors;

  DepartmentEntity({
    required this.id,
    required this.name,
    required this.doctors,
  });
}

// doctor_entity.dart
class DoctorEntity {
  final int id;
  final String name;
  final String phoneNo;
  final String email;
  final String specialization;
  final String status;
  final List<ScheduleEntity>? schedules;

  DoctorEntity({
    required this.id,
    required this.name,
    required this.phoneNo,
    required this.email,
    required this.specialization,
    required this.status,
    this.schedules,
  });
}

// schedule_entity.dart
class ScheduleEntity {
  final int scheduleId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;

  ScheduleEntity({
    required this.scheduleId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}