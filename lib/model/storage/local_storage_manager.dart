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
}
