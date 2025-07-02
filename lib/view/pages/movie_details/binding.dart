import 'package:get/get.dart';

import '../../../controllers/movie_details_page.dart';

class MovieDetailsBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<MovieDetailsController>(() => MovieDetailsController());

  }
}