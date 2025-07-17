import 'package:get/get.dart';

import '../../../controllers/bookmark_movie.dart';

class BookMarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookMarkMoviesController>(() => BookMarkMoviesController());
  }
}
