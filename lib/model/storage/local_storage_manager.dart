import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../dto/movie.dart';

class LocalStorageManager {
  static final GetStorage _box = GetStorage();
  static const String _favoritesKey = 'favorite_movies';

  /// Retrieve all bookmarked movies
  static List<MovieModel> getBookmarks() {
    final rawList = _box.read<List<dynamic>>(_favoritesKey) ?? [];
    return rawList
        .whereType<Map<String, dynamic>>()
        .map((item) => MovieModel.fromJson(item))
        .toList();
  }

  /// Check whether a movie with [movieId] is bookmarked
  static bool isBookmarked(int movieId) {
    final rawList = _box.read<List<dynamic>>(_favoritesKey) ?? [];
    return rawList.any((item) => item is Map && item['id'] == movieId);
  }

  /// Get status of movie ('favorite', 'watchlist', 'watched', or null)
  static String? getMovieStatus(int movieId) {
    final rawList = _box.read<List<dynamic>>(_favoritesKey) ?? [];
    for (final item in rawList) {
      if (item is Map && item['id'] == movieId) {
        return (item['watchlist_status'] ??
                item['watchlistStatus'] ??
                'favorite') as String;
      }
    }
    return null;
  }

  /// Set status for a movie ('favorite', 'watchlist', 'watched', or 'none' to remove)
  static void setMovieStatus(MovieModel movie, String status) {
    final rawList = List<Map<String, dynamic>>.from(
      (_box.read<List<dynamic>>(_favoritesKey) ?? [])
          .whereType<Map<String, dynamic>>(),
    );

    rawList.removeWhere((item) => item['id'] == movie.id);

    if (status != 'none') {
      final updatedMovie = movie.copyWith(watchlistStatus: status);
      rawList.add(updatedMovie.toJson());
    }

    _box.write(_favoritesKey, rawList);
  }

  /// Toggle simple bookmark status (defaulting to favorite)
  static bool toggleBookmark(MovieModel movie) {
    if (isBookmarked(movie.id)) {
      setMovieStatus(movie, 'none');
      return false;
    } else {
      setMovieStatus(movie, 'favorite');
      return true;
    }
  }

  /// Clear all saved bookmarks
  static void clearAll() {
    _box.remove(_favoritesKey);
  }

  /// Export bookmarks as formatted JSON string
  static String exportBookmarksJson() {
    final bookmarks = getBookmarks();
    final list = bookmarks.map((m) => m.toJson()).toList();
    return const JsonEncoder.withIndent('  ').convert({
      'version': '1.0',
      'app': 'FilmMix',
      'exported_at': DateTime.now().toIso8601String(),
      'count': list.length,
      'movies': list,
    });
  }

  /// Import bookmarks from a JSON string. Returns count of imported movies.
  static int importBookmarksJson(String jsonString) {
    try {
      final dynamic decoded = jsonDecode(jsonString);
      List<dynamic> items = [];
      if (decoded is List) {
        items = decoded;
      } else if (decoded is Map && decoded['movies'] is List) {
        items = decoded['movies'] as List<dynamic>;
      } else {
        return 0;
      }

      int count = 0;
      final existing = getBookmarks();
      final Map<int, MovieModel> map = {for (var m in existing) m.id: m};

      for (final raw in items) {
        if (raw is Map) {
          try {
            final movie = MovieModel.fromJson(Map<String, dynamic>.from(raw));
            map[movie.id] = movie;
            count++;
          } catch (_) {}
        }
      }

      final rawList = map.values.map((m) => m.toJson()).toList();
      _box.write(_favoritesKey, rawList);
      return count;
    } catch (_) {
      return 0;
    }
  }
}
