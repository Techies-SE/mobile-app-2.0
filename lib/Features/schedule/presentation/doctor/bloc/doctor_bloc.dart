// doctor_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_2/Features/schedule/domain/repositories.dart';
import 'package:mobile_app_2/Features/schedule/presentation/doctor/bloc/doctor_event.dart';
import 'package:mobile_app_2/Features/schedule/presentation/doctor/bloc/doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorRepository repository;

  DoctorBloc({required this.repository}) : super(DoctorLoading()) {
    on<FetchDoctorById>(_onFetchDoctorById);
  }

  Future<void> _onFetchDoctorById(
    FetchDoctorById event,
    Emitter<DoctorState> emit,
  ) async {
    emit(DoctorLoading());
    try {
      final doctor = await repository.fetchDoctorById(event.id);
      emit(DoctorLoaded(doctor));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }
}