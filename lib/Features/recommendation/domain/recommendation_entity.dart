// ignore_for_file: non_constant_identifier_names

class RecommendationEntity {
  int recommendation_id;
  String lab_test_date;
  String doctor_name;
  String recommendation;

  RecommendationEntity(
      {required this.lab_test_date,
       required this.doctor_name,
      required this.recommendation,
      required this.recommendation_id});
}
