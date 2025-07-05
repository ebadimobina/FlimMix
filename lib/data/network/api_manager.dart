import 'package:dio/dio.dart';

class ApiManager {
  late final Dio _dio;

  ApiManager() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3',
        headers: {
          'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhY2JkMjEyYzIxMGQyMzQwMGJjZDllNDFlNTQzYTA3YiIsInN1YiI6IjVkZGRhYTkxNGY1ODAxMDAxNmY5NzEwNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Skgy8lPWp-f23nZhMglFJ2aDrmemD8iCJNtsNrjx1Ko',
          'Content-Type': 'application/json',
        },
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
      ),
    );

    //dio interceptors
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

  Dio get dio => _dio;
}
