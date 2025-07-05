import 'package:flimmix/data/dto/top_rate_movie.dart';
import 'package:flimmix/data/dto/cast_movie.dart';
import 'package:flimmix/data/network/api_manager.dart';
import 'package:flimmix/data/network/endpoints.dart';
import 'package:flutter/cupertino.dart';

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
      final response = await _apiManager.dio.get(
        'movie/$movieId/credits',
        queryParameters: {'language': 'en-US'},
      );

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

}
