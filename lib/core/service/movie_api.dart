import 'package:flutter/cupertino.dart';

import '../../model/dto/cast_movie.dart';
import '../../model/dto/popular_movie.dart';
import '../../model/dto/top_rate_movie.dart';
import '../../model/network/api_manager.dart';
import '../../model/network/endpoints.dart';

class MovieApi {
  //use central dio
  final ApiManager _apiManager = ApiManager();

  //fetch top rate movie from TMDB
  Future<TopRateMovie> fetchTopRatedMovies() async {
    try {
      final response = await _apiManager.dio.get(Endpoints.topRated);
      if (response.statusCode == 200) {
        return TopRateMovie.fromJson(response.data);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }

  //fetch movie credits from TMDB
  Future<MovieCredits> fetchMovieCredits(int movieId) async {
    try {
      print('Fetching credits for movie ID: $movieId');
      final response = await _apiManager.dio.get(Endpoints.movieCredits(movieId));
      print('Status code: ${response.statusCode}');
      print('Response: ${response.data}');
      if (response.statusCode == 200) {
        return MovieCredits.fromJson(response.data);
      } else {
        throw Exception('Failed to load credits with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('fetchMovieCredits error: $e');
      rethrow;
    }
  }

  //fetch popular movie from TMDB
  Future<Popular> fetchPopularMovies() async {
    try {
      final response = await _apiManager.dio.get(Endpoints.popular);
      if (response.statusCode == 200) {
        return Popular.fromJson(response.data);
      } else {
        throw Exception('Failed to load popular movies with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load popular movies: $e');
    }
  }
}
