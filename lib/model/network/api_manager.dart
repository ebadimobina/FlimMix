import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'endpoints.dart';

class ApiManager {
  static final ApiManager _instance = ApiManager._internal();
  factory ApiManager() => _instance;

  late final Dio _dio;

  ApiManager._internal() {
    _dio = Dio();
    _dio.options = BaseOptions(
      baseUrl: Endpoints.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      validateStatus: (status) => status != null && status >= 200 && status < 300,
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            debugPrint('🚀 [DIO] Request: ${options.method} ${options.uri}');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            debugPrint('✅ [DIO] Response [${response.statusCode}] from: ${response.requestOptions.path}');
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            debugPrint('❌ [DIO] Error [${e.response?.statusCode}]: ${e.message} at ${e.requestOptions.uri}');
            return handler.next(e);
          },
        ),
      );
    }
  }

  Dio get dio {
    _dio.options.baseUrl = Endpoints.baseUrl;
    return _dio;
  }
}
