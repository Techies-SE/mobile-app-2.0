// ignore_for_file: non_constant_identifier_names

import 'package:mobile_app_2/Features/recommendation/domain/recommendation_entity.dart';

abstract class RecommendationRepo {
  Future<List<RecommendationEntity>> fetchAllRecommendations();
}
