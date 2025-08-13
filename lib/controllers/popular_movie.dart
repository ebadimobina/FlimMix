import 'package:get/get.dart';

import '../core/service/movie_api.dart';
import '../model/dto/genre_movie.dart';
import '../model/dto/popular_movie.dart';

class PopularMovieController extends GetxController {
  final RxBool isLoading = RxBool(false);
  final RxList<ResultPopular> popularMovie = RxList();
  late final ResultPopular movie;
  final MovieApi _movieApi = MovieApi();
  final expandedGenreIndexes = <int>{}.obs;

  void toggleGenres(int index) {
    if (expandedGenreIndexes.contains(index)) {
      expandedGenreIndexes.remove(index);
    } else {
      expandedGenreIndexes.add(index);
    }
  }

  String shortOverview(String overview) {
    return overview.length > 100
        ? '${overview.substring(0, 100)}...'
        : overview;
  }

  Future<void> fetchPopularMovies() async {
    try {
      isLoading.value = true;
      final response = await _movieApi.fetchPopularMovies();
      popularMovie.assignAll(response.results);
      if (popularMovie.isNotEmpty) {
        movie = popularMovie.first;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  int get itemCount => isLoading.value ? 8 : popularMovie.length;

  bool get hasMovies => popularMovie.isNotEmpty;

  bool get isLoadingNow => isLoading.value;

  List<String> genresAt(int index) {
    final movie = movieAt(index);
    return movie != null ? getGenreNames(movie.genreIds) : [];
  }

  ResultPopular? movieAt(int index) {
    if (isLoading.value) return null;
    if (index < 0 || index >= popularMovie.length) return null;
    return popularMovie[index];
  }

  String posterUrl(int index) {
    final movie = movieAt(index);
    return movie?.posterPath != null
        ? 'https://image.tmdb.org/t/p/w500${movie!.posterPath}'
        : '';
  }

  String movieTitle(int index) => movieAt(index)?.title ?? '';

  String movieRating(int index) {
    final movie = movieAt(index);
    return movie != null ? '${movie.voteAverage?.toStringAsFixed(1)}/10' : '';
  }

  @override
  void onInit() {
    fetchPopularMovies();
    super.onInit();
  }
}
