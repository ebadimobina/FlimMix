import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../core/service/movie_api.dart';
import '../model/dto/cast_movie.dart';
import '../model/dto/genre_movie.dart';
import '../model/dto/movie.dart';

class MovieDetailsController extends GetxController {
  late MovieBase movie;
  RxBool isFavorite = RxBool(false);
  RxBool get isFav => isFavorite;

  RxList<CastMember> castList = RxList();
  final storage = GetStorage();
  final favoritesKey = 'favorite_movies';
  final MovieApi movieApi = MovieApi();

  String get posterUrl =>
      movie.backdropPath != null && movie.backdropPath!.isNotEmpty
          ? 'https://image.tmdb.org/t/p/w780${movie.backdropPath}'
          : 'https://via.placeholder.com/780x439?text=No+Image';

  String get title => movie.title;

  String get vote => movie.voteAverage != null
      ? '${movie.voteAverage!.toStringAsFixed(1)}/10'
      : 'N/A';

  String get releaseDate => movie.releaseDate != null
      ? DateFormat('MMMM d, y').format(movie.releaseDate!)
      : 'Release date unknown';

  String get overview => movie.overview ?? 'No description.';

  String get year => movie.releaseDate?.year.toString() ?? '----';

  List<String> get genres => getGenreNames(movie.genreIds);

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is MovieBase) {
      movie = args;
    } else {
      Get.back();
      throw Exception("Invalid movie model");
    }

    loadFavoriteStatus();
    loadCredits(movie.id);
    super.onInit();
  }

  void loadFavoriteStatus() {
    final favorites = storage.read<List<dynamic>>(favoritesKey) ?? [];
    isFavorite.value = favorites.any((item) => item['id'] == movie.id);
  }

  void toggleFavorite() {
    final favorites = storage.read<List<dynamic>>(favoritesKey) ?? [];
    if (isFavorite.value) {
      favorites.removeWhere((item) => item['id'] == movie.id);
    } else {
      favorites.add({
        'id': movie.id,
        'title': movie.title,
        'posterPath': movie.posterPath,
        'backdropPath': movie.backdropPath,
        'voteAverage': movie.voteAverage,
        'releaseDate': movie.releaseDate?.toIso8601String(),
        'overview': movie.overview,
        'genreIds': movie.genreIds,
        'popularity': movie.popularity,
        'originalTitle': movie.originalTitle,
      });
    }

    storage.write(favoritesKey, favorites);
    isFavorite.toggle();
  }

  void shareMovie(context) {
    final movieUrl = 'https://www.themoviedb.org/movie/${movie.id}';
    final message = 'Check out this movie: $title\n\n$movieUrl';

    Share.share(
      message,
      subject: title,
    );
  }

  void loadCredits(int movieId) async {
    try {
      final credits = await movieApi.fetchMovieCredits(movieId);
      castList.value = credits.cast;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load cast list');
    }
  }
}
