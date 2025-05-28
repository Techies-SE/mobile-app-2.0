import 'package:mobile_app_2/Features/appointment/domain/entities/appointment_entity.dart';

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}


//for appointment fetching
class AppointmentFetching extends AppointmentState {}

class AppointmentFetchingSuccess extends AppointmentState {
  final AppointmentEntity appointmentEntity;

  AppointmentFetchingSuccess({required this.appointmentEntity});
}

class AppointmentFetchingFail extends AppointmentState {
  final String error;

  AppointmentFetchingFail({required this.error});
}

//for appointment request
class AppointmentRequesting extends AppointmentState{}

class AppointmentRequestingSuccess extends AppointmentState{}

class AppointmentRequestingFail extends AppointmentState{
   final String error;

  AppointmentRequestingFail({required this.error});
}

//for appointment reschedule
class AppointmentRescheduling extends AppointmentState{}

class AppointmentReschedulingSuccess extends AppointmentState{}

class AppointmentReschedulingFail extends AppointmentState{
   final String error;

  AppointmentReschedulingFail({required this.error});
}
