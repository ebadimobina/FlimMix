import 'package:flutter/foundation.dart';
import '../../model/dto/cast_movie.dart';
import '../../model/dto/popular_movie.dart';
import '../../model/dto/search_movie.dart';
import '../../model/dto/top_rate_movie.dart';
import '../../model/network/api_manager.dart';
import '../../model/network/endpoints.dart';

/// Custom exception for Movie API
class MovieApiException implements Exception {
  final String message;
  final int? statusCode;

  MovieApiException(this.message, {this.statusCode});

  @override
  String toString() => 'MovieApiException(statusCode: $statusCode, message: $message)';
}

class MovieApi {
  final ApiManager _apiManager = ApiManager();

  /// Generic method for GET requests and converting JSON to model
  Future<T> _get<T>(String url, T Function(dynamic) fromJson,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
      await _apiManager.dio.get(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        return fromJson(response.data);
      } else {
        throw MovieApiException(
          'Failed with status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw MovieApiException('Failed to load data: $e');
    }
  }

  /// Fetch top-rated movies
  Future<TopRateMovie> fetchTopRatedMovies() async {
    return _get(Endpoints.topRated, (data) => TopRateMovie.fromJson(data));
  }

  /// Fetch movie credits
  Future<MovieCredits> fetchMovieCredits(int movieId) async {
    debugPrint('Fetching credits for movie ID: $movieId');
    try {
      final credits = await _get(
        Endpoints.movieCredits(movieId),
            (data) => MovieCredits.fromJson(data),
      );
      return credits;
    } catch (e) {
      debugPrint('fetchMovieCredits error: $e');
      rethrow;
    }
  }

  /// Fetch popular movies
  Future<Popular> fetchPopularMovies() async {
    return _get(Endpoints.popular, (data) => Popular.fromJson(data));
  }

  /// Search for movies
  Future<SearchMovieDto> searchMovies(String query) async {
    final encodedQuery = Uri.encodeQueryComponent(query);
    return _get(
      Endpoints.searchMovie,
          (data) => SearchMovieDto.fromJson(data),
      queryParameters: {'query': encodedQuery},
    );
  }
}
