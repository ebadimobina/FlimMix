import 'package:get/get.dart';

import '../../../controllers/popular_movie.dart';

class PopularMovieBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<PopularMovieController>(
          () => PopularMovieController(),
    );
  }
}