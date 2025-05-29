// ignore_for_file: non_constant_identifier_names

import 'package:mobile_app_2/Features/recommendation/domain/recommendation_entity.dart';

class RecommendationModel {
  final int recommendation_id;
  final String lab_test_date;
  final String doctor_name;
  final String recommendation;

  RecommendationModel({
    required this.recommendation_id,
    required this.lab_test_date,
    required this.doctor_name,
    required this.recommendation,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      recommendation_id: json['recommendation_id'],
      lab_test_date: json['lab_test_date'],
      doctor_name: json['doctor_name'],
      recommendation: json['generated_recommendation'],
    );
  }

  static List<RecommendationModel> fromJsonList(List<dynamic> jsons) {
    return jsons.map((json) => RecommendationModel.fromJson(json)).toList();
  }

  RecommendationEntity toEntity() => RecommendationEntity(
        lab_test_date: lab_test_date,
        doctor_name: doctor_name,
        recommendation: recommendation,
        recommendation_id: recommendation_id,
      );
}
