import 'dart:async';
import 'package:get/get.dart';
import '../../../core/service/movie_api.dart';

class SearchMovieController extends GetxController {
  final searchText = ''.obs;
  final searchResults = <dynamic>[].obs;
  final isLoading = false.obs;

  final movieApi = MovieApi();
  Timer? _debounce;

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
