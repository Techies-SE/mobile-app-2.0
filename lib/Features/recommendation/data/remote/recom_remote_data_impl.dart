// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:mobile_app_2/Features/recommendation/data/remote/recom_remote_data.dart';
import 'package:mobile_app_2/app/utilities/api_service.dart';

class RecomRemoteDataImpl implements RecomRemoteData {
  @override
  Future<List> getAllRecommendation() async {
    try {
      final response = await ApiService().get('patients/recommendations');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Fail API ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fail API $e');
    }
  }
}
