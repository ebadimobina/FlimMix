import 'package:flimmix/controllers/top_rate_movie.dart';
import 'package:get/get.dart';

class TopRateListBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<TopRateMovieController>(
          () => TopRateMovieController(),
    );
  }
}