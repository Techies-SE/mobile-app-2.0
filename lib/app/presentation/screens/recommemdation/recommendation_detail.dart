import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_2/Features/recommendation/domain/recommendation_entity.dart';
import 'package:mobile_app_2/app/presentation/widgets/utilities/hospital_colors.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

class RecommendationDetailScreen extends StatelessWidget {
  final RecommendationEntity recommendation;

  const RecommendationDetailScreen({
    super.key,
    required this.recommendation,
  });

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
            'Recommendation Detail',
            style: appbarTestStyle,
          ),
          automaticallyImplyLeading: false,
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildRecommendationCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: HospitalColors.divider,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: HospitalColors.primarySoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ID: ${recommendation.recommendation_id}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: HospitalColors.primaryDark,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: HospitalColors.successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified,
                        size: 16,
                        color: HospitalColors.successGreen,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Doctor Approved',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: HospitalColors.successGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.person_outline,
              'Doctor',
              recommendation.doctor_name,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.calendar_today_outlined,
              'Lab Test Date',
              dateTimeParser(recommendation.lab_test_date)
              ,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: HospitalColors.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: HospitalColors.textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: HospitalColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: HospitalColors.divider,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.medical_information,
                  color: HospitalColors.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Clinical Recommendation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: HospitalColors.primaryDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: HospitalColors.primarySoft,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: HospitalColors.divider,
                  width: 1,
                ),
              ),
              child: Text(
                _formatRecommendationText(recommendation.recommendation),
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: HospitalColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 String _formatRecommendationText(String text) {
  if (text.isEmpty) return text;
  
  return text
      // Handle markdown bold (both ** and __ syntax)
      .replaceAllMapped(RegExp(r'(\*\*|__)(.*?)\1'), (match) => match.group(2)!)
      // Handle markdown italic (both * and _ syntax)
      .replaceAllMapped(RegExp(r'(\*|_)(.*?)\1'), (match) => match.group(2)!)
      // Convert list items (asterisk or hyphen at start of line)
      .replaceAllMapped(RegExp(r'^(\s*)[*\-]\s+', multiLine: true), 
          (match) => '${match.group(1)}• ')
      // Normalize multiple newlines (keep max 2)
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      // Trim whitespace from each line
      .split('\n')
      .map((line) => line.trim())
      .join('\n')
      // Final trim
      .trim();
}
}