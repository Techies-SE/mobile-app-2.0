// ignore_for_file: non_constant_identifier_names

import 'package:mobile_app_2/Features/recommendation/data/recommendation_model.dart';
import 'package:mobile_app_2/Features/recommendation/data/remote/recom_remote_data_impl.dart';
import 'package:mobile_app_2/Features/recommendation/domain/recommendation_entity.dart';
import 'package:mobile_app_2/Features/recommendation/domain/recommendation_repo.dart';

class RecommendationRepoImpl implements RecommendationRepo {
  final RecomRemoteDataImpl remoteDataSource;

  RecommendationRepoImpl(this.remoteDataSource);

  @override
  Future<List<RecommendationEntity>> fetchAllRecommendations() async {
    final json = await remoteDataSource.getAllRecommendation();
    final recommendationList = RecommendationModel.fromJsonList(json);
    return recommendationList
        .map((recommendation) => recommendation.toEntity())
        .toList();
  }
}
