import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BookMarkMoviesController extends GetxController {
  RxList<Map<String, dynamic>> favorites = <Map<String, dynamic>>[].obs;
  final storage = GetStorage();

  void refreshFavorites() {
    final storedFavorites = storage.read<List<dynamic>>('favorite_movies') ?? [];
    favorites.value = List<Map<String, dynamic>>.from(storedFavorites);
  }

  void toggleFavorite(Map<String, dynamic> movie) {
    final current = List<Map<String, dynamic>>.from(storage.read<List<dynamic>>('favorite_movies') ?? []);
    final exists = current.any((m) => m['id'] == movie['id']);

    if (exists) {
      current.removeWhere((m) => m['id'] == movie['id']);
    } else {
      current.add(movie);
    }

    storage.write('favorite_movies', current);
    refreshFavorites();
  }

  bool isFavorite(int id) {
    return favorites.any((m) => m['id'] == id);
  }

  @override
  void onInit() {
    refreshFavorites();
    super.onInit();
  }
}
