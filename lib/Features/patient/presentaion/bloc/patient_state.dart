// ignore_for_file: non_constant_identifier_names

import 'package:mobile_app_2/Features/patient/domain/entities/patient_entity.dart';

abstract class PatientState {}

class PatientInitial extends PatientState {}

class PatientFetching extends PatientState {}

class PatientFetchedSuccess extends PatientState {
  final PatitentEntity patient;

  PatientFetchedSuccess({required this.patient});
}

class PatientFetchchedFailed extends PatientState {
  final String error;

  PatientFetchchedFailed({required this.error});
}
