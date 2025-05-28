import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_2/Features/appointment/domain/usecases/fetch_appointment.dart';
import 'package:mobile_app_2/Features/appointment/domain/usecases/request_appointment.dart';
import 'package:mobile_app_2/Features/appointment/domain/usecases/reschedule_appointment.dart';
import 'package:mobile_app_2/Features/appointment/presentation/bloc/appointment_event.dart';
import 'package:mobile_app_2/Features/appointment/presentation/bloc/appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final FetchAppointment fetchAppointment;
  final RequestAppointment requestAppointment;
  final RescheduleAppointment rescheduleAppointment;

  AppointmentBloc({
    required this.fetchAppointment,
    required this.requestAppointment,
    required this.rescheduleAppointment,
  }) : super(AppointmentInitial()) {
    on<FetchAppointmentByUserIdEvent>(_fetchAppointment);
    on<RequestAppointmentEvent>(_requestAppointment);
    on<RescheduledAppointmentEvent>(_rescheduleAppointment);
  }

  Future<void> _fetchAppointment(FetchAppointmentByUserIdEvent event,
      Emitter<AppointmentState> emit) async {
    emit(AppointmentFetching());
    try {
      final result = await fetchAppointment.call();
      emit(AppointmentFetchingSuccess(appointmentEntityList: result));
    } catch (e) {
      emit(AppointmentFetchingFail(error: e.toString()));
    }
  }

  Future<void> _requestAppointment(
      RequestAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentRequesting());
    try {
      await requestAppointment.call(
        event.doctorId,
        event.patientId,
        event.date,
        event.time,
        event.note,
      );
      emit(AppointmentRequestingSuccess());
    } catch (e) {
      emit(AppointmentRequestingFail(error: e.toString()));
    }
  }

  Future<void> _rescheduleAppointment(
      RescheduledAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentRescheduling());
    try {
      await rescheduleAppointment.call(
        event.patientId,
        event.doctorId,
        event.appointmentId,
        event.time,
        event.date,
        event.note,
      );
      emit(AppointmentReschedulingSuccess());
    } catch (e) {
      emit(AppointmentReschedulingFail(error: e.toString()));
    }
  }
}
