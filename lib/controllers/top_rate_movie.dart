import 'package:get/get.dart';
import '../core/service/movie_api.dart';
import '../model/dto/movie.dart';

class TopRateMovieController extends GetxController {
  final MovieApi _movieApi = MovieApi();

  final RxList<MovieModel> topMovies = <MovieModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  int get itemCount => isLoading.value ? 12 : topMovies.length;
  bool get hasMovies => topMovies.isNotEmpty;
  bool get isLoadingNow => isLoading.value;

  MovieModel? movieAt(int index) {
    if (isLoading.value) return null;
    if (index < 0 || index >= topMovies.length) return null;
    return topMovies[index];
  }

  String posterUrl(int index) {
    final movie = movieAt(index);
    return movie?.posterUrl ?? '';
  }

  String movieTitle(int index) => movieAt(index)?.title ?? '';

  String movieRating(int index) {
    final movie = movieAt(index);
    return movie != null ? '${movie.ratingText}/10' : '';
  }

  Future<void> fetchTopRated() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _movieApi.fetchTopRatedMovies();
      topMovies.assignAll(response.results);
    } catch (e) {
      errorMessage.value = e.toString();
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
