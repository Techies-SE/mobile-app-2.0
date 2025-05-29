// ignore_for_file: non_constant_identifier_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_2/Features/recommendation/data/recommendation_repo_impl.dart';
import 'package:mobile_app_2/Features/recommendation/presentation/bloc/recommendation_state.dart';

class RecommendationCubit extends Cubit<RecommendationState> {
  final RecommendationRepoImpl repo;
  RecommendationCubit(this.repo) : super(RecommendationInitial());

  Future<void> getAllRecommendations() async {
    emit(RecommendationsListFetching());
    try {
      final result = await repo.fetchAllRecommendations();
      emit(RecommendationsListFetchSuccess(result));
    } catch (e) {
      emit(RecommendationsListFetchFail(e.toString()));
    }
  }
}
