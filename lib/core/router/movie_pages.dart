import 'package:flimmix/view/pages/movie_details/binding.dart';
import 'package:flimmix/view/pages/movie_details/movie_details_page.dart';
import 'package:flimmix/view/pages/top_rate_movie/top_rate_movie.dart';
import 'package:get/get.dart';

import '../../view/pages/home/binding.dart';
import '../../view/pages/home/home.dart';
import '../../view/pages/top_rate_movie/binding.dart';
import 'movie_routes.dart';

class MoviePages {
  static List<GetPage> pages = [
    GetPage(
        name: MovieRoutes.home,
        page: () => HomePage(),
        binding: HomeBinding(),
        transitionDuration: Duration.zero,
        transition: Transition.noTransition),
    GetPage(
        name: MovieRoutes.topRateMovie,
        page: () => TopRatedMovies(),
        binding: TopRateBinding(),
        transitionDuration: Duration.zero,
        transition: Transition.noTransition),
    GetPage(
        name: MovieRoutes.movieDetails,
        page: () => MovieDetailsPage(),
        binding: MovieDetailsBinding(),
        transitionDuration: Duration.zero,
        transition: Transition.noTransition)
  ];
}
