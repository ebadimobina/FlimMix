import 'package:get/get.dart';
import '../../../controllers/bookmark_movie.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/popular_movie.dart';
import '../../../controllers/search_movie_controller.dart';
import '../../../controllers/top_rate_movie.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<TopRateMovieController>(() => TopRateMovieController());
    Get.lazyPut<PopularMovieController>(() => PopularMovieController());
    Get.lazyPut<SearchMovieController>(() => SearchMovieController());
    Get.lazyPut<BookMarkMoviesController>(() => BookMarkMoviesController());
  }
}
