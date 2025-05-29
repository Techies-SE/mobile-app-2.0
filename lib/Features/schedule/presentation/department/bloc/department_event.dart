// department_event.dart
abstract class DepartmentEvent {}

class FetchAllDepartments extends DepartmentEvent {}
class FetchDepartmentById extends DepartmentEvent {
  final int id;
  FetchDepartmentById(this.id);
}