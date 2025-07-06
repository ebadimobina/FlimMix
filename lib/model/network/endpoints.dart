class Endpoints {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String topRated = '/movie/top_rated';
  static const String popular = '/movie/popular';
  static String movieCredits(int movieId) => '/movie/$movieId/credits';
}
