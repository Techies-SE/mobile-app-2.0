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
    required super.gender,
    required super.blood_type,
    required super.age,
    required super.weight,
    required super.height,
    required super.bmi,
  });

  factory PatientModel.fromJson(dynamic json) {
    return PatientModel(
      id: json['id'],
      name: json['name'],
      citizen_id: json['citizen_id'],
      hn_number: json['hn_number'],
      phone_no: json['phone_no'],
      date_of_birth: json['lab_data'][0]['date_of_birth'] ?? 'none',
      gender: json['lab_data'][0]['gender'] ?? '',
      blood_type: json['lab_data'][0]['blood_type'] ?? 'none',
      age: json['lab_data'][0]['age'] ?? 0,
      weight: double.parse('${json['lab_data'][0]['weight']}') ,
      height: double.parse('${json['lab_data'][0]['height']}'),
      bmi: double.parse('${json['lab_data'][0]['bmi']}'),
    );
  }

  PatitentEntity toEntity() => PatitentEntity(
        id: id,
        hn_number: hn_number,
        name: name,
        citizen_id: citizen_id,
        phone_no: phone_no,
        date_of_birth: date_of_birth,
        gender: gender,
        blood_type: blood_type,
        age: age,
        weight: weight,
        height: height,
        bmi: bmi,
      );
}
