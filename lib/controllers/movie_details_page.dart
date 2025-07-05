import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flimmix/data/dto/top_rate_movie.dart';
import 'package:intl/intl.dart';
import '../data/dto/cast_movie.dart';
import '../data/dto/genre_movie.dart';
import '../data/network/movie_api.dart';

class MovieDetailsController extends GetxController {
  late final ResultTopRate movie;
  final RxBool isFavorite = false.obs;
  final RxList<CastMember> castList = <CastMember>[].obs;
  final _storage = GetStorage();
  final _favoritesKey = 'favorite_movies';

  final MovieApi _movieApi = MovieApi();

  String get posterUrl => movie.backdropPath.isNotEmpty == true
      ? 'https://image.tmdb.org/t/p/w780${movie.backdropPath}'
      : 'https://via.placeholder.com/780x439?text=No+Image';

  String get title => movie.title;

  String get vote => movie.voteAverage != null
      ? '${movie.voteAverage.toStringAsFixed(1)}/10'
      : 'N/A';

  String get releaseDate {
    if (movie.releaseDate == null) return 'Release date unknown';

    final format = DateFormat('MMMM d, y');
    return format.format(movie.releaseDate!);
  }

  String get overview => movie.overview.isNotEmpty == true
      ? movie.overview
      : 'No description available.';

  String get year =>
      movie.releaseDate != null ? movie.releaseDate!.year.toString() : '----';

  List<String> get genres => getGenreNames(movie.genreIds);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments == null || Get.arguments is! ResultTopRate) {
      Get.back();
      throw Exception("Invalid movie data");
    }
    movie = Get.arguments as ResultTopRate;
    _loadFavoriteStatus();
    fetchCast();
  }

  void _loadFavoriteStatus() {
    final favorites = _storage.read<List<dynamic>>(_favoritesKey) ?? [];
    isFavorite.value = favorites.any((item) => item['id'] == movie.id);
  }

  void toggleFavorite() {
    final favorites = _storage.read<List<dynamic>>(_favoritesKey) ?? [];

    if (isFavorite.value) {
      favorites.removeWhere((item) => item['id'] == movie.id);
    } else {
      favorites.add({
        'id': movie.id,
        'title': movie.title,
        'posterPath': movie.posterPath,
        'voteAverage': movie.voteAverage,
        'releaseDate': movie.releaseDate?.toIso8601String(),
        'overview': movie.overview,
        'genreIds': movie.genreIds,
      });
    }

    _storage.write(_favoritesKey, favorites);
    isFavorite.toggle();

    Get.snackbar(
      isFavorite.value ? 'Added to Favorites' : 'Removed from Favorites',
      isFavorite.value
          ? 'You liked ${movie.title}'
          : 'You removed ${movie.title} from favorites',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static List<ResultTopRate> getFavoriteMovies() {
    final storage = GetStorage();
    final favorites = storage.read<List<dynamic>>('favorite_movies') ?? [];
    return favorites.map((item) => ResultTopRate.fromJson(item)).toList();
  }

  void fetchCast() async {
    try {
      final response = await _movieApi.fetchMovieCredits(movie.id);
      debugPrint('Cast fetched: ${response.cast.length}');
      if (response.cast.isNotEmpty) {
        castList.assignAll(response.cast);
      } else {
        Get.snackbar('Info', 'No cast information available');
      }
    } catch (e) {
      debugPrint('fetchCast error: $e');
      Get.snackbar('Error', 'Failed to load cast list: $e');
    }
  }
}
