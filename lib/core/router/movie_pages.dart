import 'package:flimmix/view/pages/movie_details/binding.dart';
import 'package:flimmix/view/pages/search/binding.dart';
import 'package:flimmix/view/pages/search/search_movies.dart';
import 'package:get/get.dart';

import '../../view/pages/bookmark_movies/binding.dart';
import '../../view/pages/bookmark_movies/bookmark_movies.dart';
import '../../view/pages/home/binding.dart';
import '../../view/pages/home/home.dart';
import '../../view/pages/movie_details/movies_details_page.dart';
import '../../view/pages/popular_movie/binding.dart';
import '../../view/pages/popular_movie/popular_movies.dart';
import '../../view/pages/top_rate_movie/binding.dart';
import '../../view/pages/top_rate_movie/top_rated_movies.dart';
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
        page: () => MoviesDetailsPage(),
        binding: MovieDetailsBinding(),
        transitionDuration: Duration.zero,
        transition: Transition.noTransition),
    GetPage(
        name: MovieRoutes.popularMovie,
        page: () => PopularMovies(),
        binding: PopularMovieBinding(),
        transitionDuration: Duration.zero,
        transition: Transition.noTransition),
    GetPage(
        name: MovieRoutes.searchMovie,
        page: () => SearchMoviesPage(),
        binding: SearchMovieBinding(),
        transitionDuration: Duration.zero,
        transition: Transition.noTransition),
    GetPage(
        name: MovieRoutes.bookmarkMovie,
        page: () => BookMarkMoviesPage(),
        binding: BookMarkBinding(),
        transitionDuration: Duration.zero,
        transition: Transition.noTransition),
  ];
}
