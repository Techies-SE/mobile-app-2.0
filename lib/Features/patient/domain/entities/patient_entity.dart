// ignore_for_file: non_constant_identifier_names

class PatitentEntity {
  final String hn_number;
  final String name;
  final String citizen_id;
  final String phone_no;
  final String date_of_birth;
  final int id;
  final String gender;
  final String blood_type;
  final int age;
  final double weight;
  final double height;
  final double bmi;
  const PatitentEntity({
    required this.hn_number,
    required this.name,
    required this.citizen_id,
    required this.phone_no,
    required this.date_of_birth,
    required this.id,
    required this.gender,
    required this.blood_type,
    required this.age,
    required this.weight,
    required this.height,
    required this.bmi,
  });
}
