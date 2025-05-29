import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_app_2/Features/auth/data/datasources/local/auth_local_data_source_impl.dart';

class ApiService {
  Future<dynamic> getHeaders() async {
    final token = await AuthLocalDataSourceImpl().getToken();
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token"
    };
  }

  Future<http.Response> get(String endPoint) async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('https://backend-pg-cm2b.onrender.com/$endPoint'),
      headers: headers,
    );
    return response;
  }

  Future<http.Response> post(String endPoint, dynamic body) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('https://backend-pg-cm2b.onrender.com/$endPoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> put(String endPoint, dynamic body) async {
    final headers = await getHeaders();
    final response = await http.put(
      Uri.parse('https://backend-pg-cm2b.onrender.com/$endPoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return response;
  }
}
