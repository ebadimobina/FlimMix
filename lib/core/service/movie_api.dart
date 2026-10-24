import 'package:dio/dio.dart';
import '../../model/dto/cast_movie.dart';
import '../../model/dto/movie.dart';
import '../../model/network/api_manager.dart';
import '../../model/network/endpoints.dart';

class MovieApiException implements Exception {
  final String message;
  final int? statusCode;

  MovieApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class MovieApi {
  final ApiManager _apiManager = ApiManager();

  List<MovieModel>? _cachedShows;

  Future<T> _get<T>(
    String url,
    T Function(dynamic) fromJson, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _apiManager.dio.get(
        url,
        queryParameters: queryParameters,
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      String message = 'An unexpected network error occurred.';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'Connection timed out. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        message = 'Unable to reach the server. Please check your internet connection.';
      } else if (statusCode == 404) {
        message = 'The requested movie or show was not found.';
      } else if (e.response?.data is Map<String, dynamic>) {
        final serverMsg = e.response?.data['message'] ?? e.response?.data['status_message'];
        if (serverMsg is String && serverMsg.isNotEmpty) {
          message = serverMsg;
        }
      }

      throw MovieApiException(message, statusCode: statusCode);
    } catch (e) {
      if (e is MovieApiException) rethrow;
      throw MovieApiException('Failed to process data: $e');
    }
  }

  Future<List<MovieModel>> _fetchAllShows({int page = 0}) async {
    if (page == 0 && _cachedShows != null && _cachedShows!.isNotEmpty) {
      return _cachedShows!;
    }

    final response = await _get<dynamic>(
      Endpoints.shows,
      (data) => data,
      queryParameters: {'page': page},
    );

    if (response is List) {
      final shows = response
          .whereType<Map<String, dynamic>>()
          .map((item) => MovieModel.fromJson(item))
          .toList();

      if (page == 0) {
        _cachedShows = shows;
      }
      return shows;
    }
    return [];
  }

  /// Fetch top-rated movies/shows (sorted by rating descending)
  Future<MovieResponse> fetchTopRatedMovies({int page = 0}) async {
    final shows = await _fetchAllShows(page: page);
    final sorted = List<MovieModel>.from(shows)
      ..sort((a, b) => (b.voteAverage ?? 0).compareTo(a.voteAverage ?? 0));

    return MovieResponse(
      page: page,
      results: sorted,
      totalPages: 10,
      totalResults: sorted.length,
    );
  }

  /// Fetch popular movies/shows (sorted by weight/popularity descending)
  Future<MovieResponse> fetchPopularMovies({int page = 0}) async {
    final shows = await _fetchAllShows(page: page);
    final sorted = List<MovieModel>.from(shows)
      ..sort((a, b) => (b.popularity ?? 0).compareTo(a.popularity ?? 0));

    return MovieResponse(
      page: page,
      results: sorted,
      totalPages: 10,
      totalResults: sorted.length,
    );
  }

  /// Fetch movie/show credits (cast & crew)
  Future<MovieCredits> fetchMovieCredits(int showId) async {
    return _get(
      Endpoints.showCast(showId),
      (data) => MovieCredits.fromJson(data),
    );
  }

  /// Search for movies/shows by query
  Future<MovieResponse> searchMovies(String query, {int page = 1}) async {
    final response = await _get<dynamic>(
      Endpoints.searchShows,
      (data) => data,
      queryParameters: {'q': query},
    );

    if (response is List) {
      final results = response
          .whereType<Map<String, dynamic>>()
          .map((item) => MovieModel.fromJson(item))
          .toList();

      return MovieResponse(
        page: page,
        results: results,
        totalPages: 1,
        totalResults: results.length,
      );
    }

    return MovieResponse(page: 1, results: [], totalPages: 1, totalResults: 0);
  }
}
