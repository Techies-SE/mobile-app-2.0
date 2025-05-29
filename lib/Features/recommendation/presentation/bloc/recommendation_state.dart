import 'package:mobile_app_2/Features/recommendation/domain/recommendation_entity.dart';

class RecommendationState {}

class RecommendationInitial extends RecommendationState {}

class RecommendationsListFetching extends RecommendationState {}

class RecommendationsListFetchSuccess extends RecommendationState {
  final List<RecommendationEntity> recommendationEntityList;
  RecommendationsListFetchSuccess(this.recommendationEntityList);
}

class RecommendationsListFetchFail extends RecommendationState {
  final String error;
  RecommendationsListFetchFail(this.error);
}
