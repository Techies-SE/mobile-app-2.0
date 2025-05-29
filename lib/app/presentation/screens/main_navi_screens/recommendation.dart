import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_2/Features/recommendation/domain/recommendation_entity.dart';
import 'package:mobile_app_2/Features/recommendation/presentation/bloc/recommendation_cubit.dart';
import 'package:mobile_app_2/Features/recommendation/presentation/bloc/recommendation_state.dart';
import 'package:mobile_app_2/app/presentation/screens/recommemdation/recommendation_detail.dart';
import 'package:mobile_app_2/app/presentation/widgets/utilities/hospital_colors.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch recommendations when screen loads
    context.read<RecommendationCubit>().getAllRecommendations();
  }

  String dateTimeParser(String value) {
    DateTime dateTime = DateTime.parse(value);
    return DateFormat('d MMMM y').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Recommendation',
          style: appbarTestStyle,
        ),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<RecommendationCubit, RecommendationState>(
        builder: (context, state) {
          if (state is RecommendationsListFetching) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is RecommendationsListFetchSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<RecommendationCubit>().getAllRecommendations();
              },
              child: _buildRecommendationsList(state.recommendationEntityList),
            );
          } else if (state is RecommendationsListFetchFail) {
            return _buildErrorWidget(state.error);
          }
          return const Center(
            child: Text('Pull to refresh recommendations'),
          );
        },
      ),
    );
  }

  Widget _buildRecommendationsList(List<RecommendationEntity> recommendations) {
    if (recommendations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_information_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No recommendations available',
              style: TextStyle(
                fontSize: 18,
                color: HospitalColors.textLight,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final recommendation = recommendations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: HospitalColors.divider,
              width: 0.5,
            ),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecommendationDetailScreen(
                    recommendation: recommendation,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: HospitalColors.primarySoft,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'ID: ${recommendation.recommendation_id}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: HospitalColors.primaryDark,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: HospitalColors.successGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified,
                              size: 12,
                              color: HospitalColors.successGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Doctor Approved',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: HospitalColors.successGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: HospitalColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        recommendation.doctor_name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: HospitalColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: HospitalColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                       dateTimeParser( recommendation.lab_test_date),
                        style: TextStyle(
                          color: HospitalColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getPreview(recommendation.recommendation),
                    style: TextStyle(
                      color: HospitalColors.textLight,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: HospitalColors.warningOrange,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load recommendations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: HospitalColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HospitalColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<RecommendationCubit>().getAllRecommendations();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: HospitalColors.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPreview(String text) {
    // Remove markdown formatting and get first meaningful sentence
    String cleaned = text.replaceAll(RegExp(r'\*+'), '').trim();
    if (cleaned.length > 150) {
      return '${cleaned.substring(0, 150)}...';
    }
    return cleaned;
  }
}
