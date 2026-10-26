import 'package:get/get.dart';
import '../model/dto/movie.dart';
import '../model/storage/local_storage_manager.dart';

class BookMarkMoviesController extends GetxController {
  final RxList<MovieModel> allBookmarks = <MovieModel>[].obs;
  final RxString selectedFilter = 'all'.obs;

  List<MovieModel> get filteredMovies {
    if (selectedFilter.value == 'all') return allBookmarks;
    return allBookmarks
        .where((m) => m.watchlistStatus == selectedFilter.value)
        .toList();
  }

  int get favoritesCount =>
      allBookmarks.where((m) => m.watchlistStatus == 'favorite').length;
  int get watchlistCount =>
      allBookmarks.where((m) => m.watchlistStatus == 'watchlist').length;
  int get watchedCount =>
      allBookmarks.where((m) => m.watchlistStatus == 'watched').length;

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void refreshFavorites() {
    allBookmarks.assignAll(LocalStorageManager.getBookmarks());
  }

  void setMovieStatus(MovieModel movie, String status) {
    LocalStorageManager.setMovieStatus(movie, status);
    refreshFavorites();
  }

  void toggleFavorite(MovieModel movie) {
    LocalStorageManager.toggleBookmark(movie);
    refreshFavorites();
  }

  void removeBookmark(MovieModel movie) {
    LocalStorageManager.setMovieStatus(movie, 'none');
    refreshFavorites();
  }

  bool isFavorite(int id) {
    return allBookmarks.any((m) => m.id == id);
  }

  @override
  void onInit() {
    refreshFavorites();
    super.onInit();
  }
}
