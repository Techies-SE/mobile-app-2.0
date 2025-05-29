// department_state.dart
import 'package:mobile_app_2/Features/schedule/domain/entites.dart';

abstract class DepartmentState {}

class DepartmentLoading extends DepartmentState {}
class DepartmentsLoaded extends DepartmentState {
  final List<DepartmentEntity> departments;
  DepartmentsLoaded(this.departments);
}
class DepartmentLoaded extends DepartmentState {
  final DepartmentEntity department;
  DepartmentLoaded(this.department);
}
class DepartmentError extends DepartmentState {
  final String message;
  DepartmentError(this.message);
}