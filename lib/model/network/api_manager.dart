import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiManager {
  final Dio _dio = Dio();

  ApiManager() {
    final bearerToken = dotenv.env['TMDB_BEARER'];
    _dio.options = BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: {
        if (bearerToken != null && bearerToken.isNotEmpty)
          'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      validateStatus: (status) => status != null && status < 500,
    );

    // Remove api_key injection; prefer bearer token via Authorization header.
  }

  Future<Response?> dioGetRequest(String endpoint, [Map<String, dynamic>? params]) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: params);
      return response;
    } catch (e) {
      if (e is DioException) handleError(e);
      return null;
    }
  }

  Future<Response?> dioPostRequest(String endpoint, dynamic data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } catch (e) {
      if (e is DioException) handleError(e);
      return null;
    }
  }

  void handleError(DioException e) {
    print('❌ Dio Error: ${e.message}');
    if (e.response != null) {
      print('📥 Status Code: ${e.response?.statusCode}');
      print('📥 Response Body: ${e.response?.data}');
    }
  }

  Dio get dio => _dio;
}
