import 'package:get/get.dart';
import '../core/service/movie_api.dart';
import '../model/dto/genre_movie.dart';
import '../model/dto/movie.dart';

class PopularMovieController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<MovieModel> popularMovie = <MovieModel>[].obs;
  final MovieApi _movieApi = MovieApi();
  final RxSet<int> expandedGenreIndexes = <int>{}.obs;

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
      errorMessage.value = '';
      final response = await _movieApi.fetchPopularMovies();
      popularMovie.assignAll(response.results);
    } catch (e) {
      errorMessage.value = e.toString();
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

  MovieModel? movieAt(int index) {
    if (isLoading.value) return null;
    if (index < 0 || index >= popularMovie.length) return null;
    return popularMovie[index];
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

  @override
  void onInit() {
    fetchPopularMovies();
    super.onInit();
  }
}
