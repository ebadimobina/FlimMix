import 'package:get/get.dart';

import '../../../controllers/popular_movie.dart';

class PopularMovieBinding implements Bindings{
  @override
  void dependencies() {
    if (!Get.isRegistered<PopularMovieController>()) {
      Get.lazyPut<PopularMovieController>(() => PopularMovieController());
    }
  }
}