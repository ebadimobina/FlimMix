import 'dart:async';
import 'package:get/get.dart';
import '../core/service/movie_api.dart';
import '../model/dto/movie.dart';

class SearchMovieController extends GetxController {
  final RxString searchText = ''.obs;
  final RxList<MovieModel> searchResults = <MovieModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString sortByRating = 'none'.obs;
  final MovieApi _movieApi = MovieApi();
  Timer? _debounce;

  void sortResults() {
    if (sortByRating.value == 'high') {
      searchResults.sort(
        (a, b) => (b.voteAverage ?? 0).compareTo(a.voteAverage ?? 0),
      );
    } else if (sortByRating.value == 'low') {
      searchResults.sort(
        (a, b) => (a.voteAverage ?? 0).compareTo(b.voteAverage ?? 0),
      );
    }
  }

  void onSearchTextChanged(String value) {
    searchText.value = value.trim();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (searchText.value.isNotEmpty) {
        searchMovie(searchText.value);
      } else {
        searchResults.clear();
      }
    });
  }

  Future<void> searchMovie(String query) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _movieApi.searchMovies(query);
      searchResults.assignAll(result.results);
      sortResults();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchText.value = '';
    searchResults.clear();
    errorMessage.value = '';
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
