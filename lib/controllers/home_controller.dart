import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxString selectedGenre = 'All'.obs;

  final List<String> availableGenres = const [
    'All',
    'Drama',
    'Action',
    'Comedy',
    'Science-Fiction',
    'Thriller',
    'Crime',
    'Horror',
    'Adventure',
    'Animation',
    'Romance',
    'Mystery',
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }

  void selectGenre(String genre) {
    selectedGenre.value = genre;
  }
}
