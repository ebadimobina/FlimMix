import 'package:flimmix/data/dto/top_rate_movie.dart';
import 'package:flimmix/data/network/movie_api.dart';
import 'package:get/get.dart';

class TopRateMovieController extends GetxController {
  var topMovies = <Result>[].obs;
  var isLoading = false.obs;

  final MovieApi _movieApi = MovieApi();

  @override
  void onInit() {
    fetchTopRated();
    super.onInit();
  }

  void fetchTopRated() async {
    isLoading.value = true;
    try {
      final response = await _movieApi.fetchTopRatedMovies();
      topMovies.value = response.results;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch movies');
    } finally {
      isLoading.value = false;
    }
  }

  int get itemCount => isLoading.value ? 8 : topMovies.length;

  bool get hasMovies => topMovies.isNotEmpty;

  bool get isLoadingNow => isLoading.value;

  Result? movieAt(int index) {
    if (isLoading.value) return null;
    if (index < 0 || index >= topMovies.length) return null;
    return topMovies[index];
  }

  String posterUrl(int index) {
    final movie = movieAt(index);
    if (movie == null) return '';
    return 'https://image.tmdb.org/t/p/w500${movie.posterPath}';
  }

  String movieTitle(int index) {
    final movie = movieAt(index);
    if (movie == null) return '';
    return movie.title;
  }

  String movieRating(int index) {
    final movie = movieAt(index);
    if (movie == null) return '';
    return '${movie.voteAverage.toStringAsFixed(1)}/10';
  }
}
