import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 1) {
      Get.toNamed('/search');
    }
  }
}
