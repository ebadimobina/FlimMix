import 'package:flimmix/controllers/top_rate_movie.dart';
import 'package:flimmix/controllers/popular_movie.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<TopRateMovieController>(() => TopRateMovieController());
    Get.lazyPut<PopularMovieController>(() => PopularMovieController());
  }
}
