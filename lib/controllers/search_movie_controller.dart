import 'dart:async';
import 'package:get/get.dart';
import '../../../core/service/movie_api.dart';
import '../model/dto/movie.dart';

class SearchMovieController extends GetxController {
  final searchText = ''.obs;
  final searchResults = <MovieModel>[].obs;
  final isLoading = false.obs;
  var sortByRating = 'none'.obs;
  final movieApi = MovieApi();
  Timer? _debounce;

  void sortResults() {
    if (sortByRating.value == 'high') {
      searchResults.sort(
          (a, b) => (b.voteAverage ?? 0).compareTo(a.voteAverage ?? 0));
    } else if (sortByRating.value == 'low') {
      searchResults.sort(
          (a, b) => (a.voteAverage ?? 0).compareTo(b.voteAverage ?? 0));
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
    try {
      final result = await movieApi.searchMovies(query);
      searchResults.value = result.results;
      sortResults();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
