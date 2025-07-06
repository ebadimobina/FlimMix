import 'package:dio/dio.dart';

class ApiManager {
  final Dio _dio = Dio();

  ApiManager() {
    _dio.options = BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhY2JkMjEyYzIxMGQyMzQwMGJjZDllNDFlNTQzYTA3YiIsInN1YiI6IjVkZGRhYTkxNGY1ODAxMDAxNmY5NzEwNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Skgy8lPWp-f23nZhMglFJ2aDrmemD8iCJNtsNrjx1Ko',
        'Content-Type': 'application/json',
      },
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      validateStatus: (status) => status != null && status < 500,
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters.addAll({
            'api_key': 'acbd212c210d23400bcd9e41e543a07b',
          });
          return handler.next(options);
        },
      ),
    );
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
