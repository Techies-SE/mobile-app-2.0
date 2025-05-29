// department_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_2/Features/schedule/domain/repositories.dart';
import 'package:mobile_app_2/Features/schedule/presentation/department/bloc/department_event.dart';
import 'package:mobile_app_2/Features/schedule/presentation/department/bloc/department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final DepartmentRepository repository;

  DepartmentBloc({required this.repository}) : super(DepartmentLoading()) {
    on<FetchAllDepartments>(_onFetchAllDepartments);
    on<FetchDepartmentById>(_onFetchDepartmentById);
  }

  Future<void> _onFetchAllDepartments(
    FetchAllDepartments event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(DepartmentLoading());
    try {
      final departments = await repository.fetchAllDepartments();
      emit(DepartmentsLoaded(departments));
    } catch (e) {
      emit(DepartmentError(e.toString()));
    }
  }

  Future<void> _onFetchDepartmentById(
    FetchDepartmentById event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(DepartmentLoading());
    try {
      final department = await repository.fetchDepartmentById(event.id);
      emit(DepartmentLoaded(department));
    } catch (e) {
      emit(DepartmentError(e.toString()));
    }
  }
}
