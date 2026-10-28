import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/service/movie_api.dart';
import '../model/dto/cast_movie.dart';
import '../model/dto/movie.dart';
import '../model/storage/local_storage_manager.dart';
import 'bookmark_movie.dart';

class MovieDetailsController extends GetxController {
  late MovieModel movie;
  final Rx<String?> currentStatus = Rx<String?>(null);
  final RxList<CastMember> castList = <CastMember>[].obs;
  final RxList<MovieModel> similarMovies = <MovieModel>[].obs;
  final RxBool isLoadingCast = false.obs;
  final RxBool isLoadingSimilar = false.obs;
  final MovieApi _movieApi = MovieApi();

  String? get posterUrl => movie.posterUrl;
  String? get backdropUrl => movie.backdropUrl;
  String get title => movie.title;
  String get vote => movie.ratingText;
  String get releaseDate => movie.formattedReleaseDate;
  String get overview => movie.overview ?? 'No description available.';
  String get year => movie.releaseYear;
  List<String> get genres => movie.genreNames;

  bool get isFavorite => currentStatus.value == 'favorite';
  bool get isWatchlist => currentStatus.value == 'watchlist';
  bool get isWatched => currentStatus.value == 'watched';

  void loadStatus() {
    currentStatus.value = LocalStorageManager.getMovieStatus(movie.id);
  }

  void setWatchlistStatus(String status) {
    if (currentStatus.value == status) {
      LocalStorageManager.setMovieStatus(movie, 'none');
      currentStatus.value = null;
    } else {
      LocalStorageManager.setMovieStatus(movie, status);
      currentStatus.value = status;
    }

    if (Get.isRegistered<BookMarkMoviesController>()) {
      Get.find<BookMarkMoviesController>().refreshFavorites();
    }
  }

  void toggleFavorite() {
    setWatchlistStatus('favorite');
  }

  void shareMovie(BuildContext context) {
    final movieUrl = 'https://www.tvmaze.com/shows/${movie.id}';
    final message = 'Check out this title: $title\n\n$movieUrl';

    SharePlus.instance.share(
      ShareParams(
        text: message,
        subject: title,
      ),
    );
  }

  Future<void> searchOnline() async {
    final query = Uri.encodeComponent('$title movie watch online');
    final url = Uri.parse('https://www.google.com/search?q=$query');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar('Error', 'Could not open browser: $e');
    }
  }

  Future<void> watchTrailer() async {
    final query = Uri.encodeComponent('$title official trailer');
    final url = Uri.parse('https://www.youtube.com/results?search_query=$query');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar('Error', 'Could not open trailer: $e');
    }
  }

  Future<void> loadCredits(int movieId) async {
    isLoadingCast.value = true;
    try {
      final credits = await _movieApi.fetchMovieCredits(movieId);
      castList.assignAll(credits.cast);
    } catch (e) {
      debugPrint('Failed to load cast: $e');
    } finally {
      isLoadingCast.value = false;
    }
  }

  Future<void> loadSimilarMovies() async {
    isLoadingSimilar.value = true;
    try {
      final searchKeyword = movie.genreNames.isNotEmpty
          ? movie.genreNames.first
          : movie.title.split(' ').first;
      final response = await _movieApi.searchMovies(searchKeyword);
      final filtered = response.results
          .where((m) => m.id != movie.id && m.posterUrl != null)
          .take(8)
          .toList();
      similarMovies.assignAll(filtered);
    } catch (e) {
      debugPrint('Failed to load similar: $e');
    } finally {
      isLoadingSimilar.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is MovieModel) {
      movie = args;
    } else if (args is Map<String, dynamic>) {
      movie = MovieModel.fromJson(args);
    } else {
      debugPrint('Invalid argument passed to MovieDetailsController: $args');
      return;
    }

    loadStatus();
    loadCredits(movie.id);
    loadSimilarMovies();
  }
}
