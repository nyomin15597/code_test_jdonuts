import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getHomeData() async {
    final response = await dio.get('/v1/home');

    final body = response.data;

    if (body is! Map<String, dynamic>) {
      throw Exception('Invalid API response.');
    }

    if (body['error'] != null) {
      throw Exception(body['error'].toString());
    }

    final data = body['data'];

    if (data is! Map<String, dynamic>) {
      throw Exception('Missing data in API response.');
    }

    return data;
  }
}