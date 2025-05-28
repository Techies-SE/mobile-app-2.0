// ignore_for_file: non_constant_identifier_names

import 'package:mobile_app_2/Features/patient/domain/entities/patient_entity.dart';

class PatientModel extends PatitentEntity {
  PatientModel({
    required super.name,
    required super.citizen_id,
    required super.hn_number,
    required super.phone_no,
    required super.date_of_birth,
    required super.id,
  });

  factory PatientModel.fromJson(dynamic json) {
    return PatientModel(
        id: json['id'],
        name: json['name'],
        citizen_id: json['citizen_id'],
        hn_number: json['hn_number'],
        phone_no: json['phone_no'],
        date_of_birth: json['lab_data'][0]['date_of_birth'] ?? 'none');
  }

  PatitentEntity toEntity() => PatitentEntity(
        id: id,
        hn_number: hn_number,
        name: name,
        citizen_id: citizen_id,
        phone_no: phone_no,
        date_of_birth: date_of_birth,
      );
}
