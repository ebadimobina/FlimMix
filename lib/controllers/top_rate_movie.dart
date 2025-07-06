import 'package:flimmix/core/service/movie_api.dart';
import 'package:get/get.dart';

import '../model/dto/top_rate_movie.dart';

class TopRateMovieController extends GetxController {
  final MovieApi _movieApi = MovieApi();

  final RxList<ResultTopRate> topMovies =RxList();
  final RxBool isLoading = RxBool(false);

  int get itemCount => isLoading.value ? 8 : topMovies.length;
  bool get hasMovies => topMovies.isNotEmpty;
  bool get isLoadingNow => isLoading.value;

  ResultTopRate? movieAt(int index) {
    if (isLoading.value) return null;
    if (index < 0 || index >= topMovies.length) return null;
    return topMovies[index];
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
    return movie != null
        ? '${movie.voteAverage.toStringAsFixed(1)}/10'
        : '';
  }

  Future<void> fetchTopRated() async {
    isLoading.value = true;
    try {
      final response = await _movieApi.fetchTopRatedMovies();
      topMovies.assignAll(response.results);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch movies');
      print('Error details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchTopRated();
    super.onInit();
  }
}