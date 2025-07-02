import 'package:dio/dio.dart';

class ApiManager {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhY2JkMjEyYzIxMGQyMzQwMGJjZDllNDFlNTQzYTA3YiIsInN1YiI6IjVkZGRhYTkxNGY1ODAxMDAxNmY5NzEwNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Skgy8lPWp-f23nZhMglFJ2aDrmemD8iCJNtsNrjx1Ko',
        'Content-Type': 'application/json',
      },
    ),
  );

  Dio get dio => _dio;
}
