import 'package:flimmix/controllers/home_controller.dart';
import 'package:flimmix/controllers/top_rate_movie.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<TopRateMovieController>(() => TopRateMovieController());
  }
}
