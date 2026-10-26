import 'package:get/get.dart';
import '../../view/pages/about/about.dart';
import '../../view/pages/bookmark_movies/binding.dart';
import '../../view/pages/bookmark_movies/bookmark_movies.dart';
import '../../view/pages/home/binding.dart';
import '../../view/pages/home/home.dart';
import '../../view/pages/movie_details/binding.dart';
import '../../view/pages/movie_details/movies_details_page.dart';
import '../../view/pages/popular_movie/binding.dart';
import '../../view/pages/popular_movie/popular_movie_list/popular_movies_list.dart';
import '../../view/pages/search/binding.dart';
import '../../view/pages/search/search_movies.dart';
import '../../view/pages/settings/settings_page.dart';
import '../../view/pages/top_rate_movie/binding.dart';
import '../../view/pages/top_rate_movie/top_rate_list/top_rated_movies_list.dart';
import 'movie_routes.dart';

class MoviePages {
  static List<GetPage> pages = [
    GetPage(
      name: MovieRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: MovieRoutes.topRateMovie,
      page: () => TopRatedMoviesList(),
      binding: TopRateBinding(),
    ),
    GetPage(
      name: MovieRoutes.movieDetails,
      page: () => MoviesDetailsPage(),
      binding: MovieDetailsBinding(),
    ),
    GetPage(
      name: MovieRoutes.popularMovie,
      page: () => PopularMoviesList(),
      binding: PopularMovieBinding(),
    ),
    GetPage(
      name: MovieRoutes.searchMovie,
      page: () => const SearchMoviesPage(),
      binding: SearchMovieBinding(),
    ),
    GetPage(
      name: MovieRoutes.bookmarkMovie,
      page: () => const BookMarkMoviesPage(),
      binding: BookMarkBinding(),
    ),
    GetPage(
      name: MovieRoutes.about,
      page: () => const AboutMePage(),
    ),
    GetPage(
      name: MovieRoutes.settings,
      page: () => const SettingsPage(),
    ),
  ];
}
